class Entry < ActiveRecord::Base
  attr_accessible :bicycle_description, :brand, :circumstances, :city, :color, :country, :date_abandoned, :date_missing, :date_recovered,
    :info_url, :model, :neighborhood, :owner_name, :photo_1_url, :photo_2_url, :photo_3_url, :reward, :sbdx_member, :sbdx_member_entry_identifier,
    :serial_number, :sighting_report_instructions, :sighting_report_url, :size, :state, :year, :zip
    
    # sbdx_development=# \d entries
    #                                             Table "public.entries"
    #            Column                       Type                                  Modifiers                       
    # ---------------------------- --------------------------- ----------------------------------------------------
    # id                           integer                     not null default nextval('entries_id_seq'::regclass)
    # sbdx_member                  character varying(255)      
    # sbdx_member_entry_identifier character varying(255)      
    # date_missing                 date                        
    # date_recovered               date                        
    # date_abandoned               date                        
    # neighborhood                 character varying(255)      
    # city                         character varying(255)      
    # state                        character varying(255)      
    # zip                          character varying(255)      
    # country                      character varying(255)      
    # brand                        character varying(255)      
    # year                         integer                     
    # model                        character varying(255)      
    # color                        character varying(255)      
    # size                         character varying(255)      
    # serial_number                character varying(255)      
    # owner_name                   character varying(255)      
    # circumstances                text                        
    # bicycle_description          text                        
    # reward                       boolean                     
    # info_url                     character varying(255)      
    # sighting_report_url          character varying(255)      
    # sighting_report_instructions text                        
    # photo_1_url                  character varying(255)      
    # photo_2_url                  character varying(255)      
    # photo_3_url                  character varying(255)      
    # created_at                   timestamp without time zone not null
    # updated_at                   timestamp without time zone not null
    # Indexes:
    #     "entries_pkey" PRIMARY KEY, btree (id)
    #     "entry_ak" UNIQUE, btree (sbdx_member, sbdx_member_entry_identifier)
    
  require 'nokogiri'
  require 'open-uri'

  def Entry.bunch_from_stolen_bicycle_registry(start_oid, stop_oid=start_oid+100)
    while start_oid <= stop_oid
      begin
        Entry.snarf_from_stolen_bicycle_registry(start_oid)
        sleep 1
      rescue Exception => e
        Activity.record("stolenbicycleregistry", start_oid, "snarf", "error", e.message)
      end
      start_oid += 1
    end
  end

  def Entry.check_date(s)
    if s == '00-00-0000'
      nil
    else
      s
    end
  end

  def Entry.max_sbr_oid
    # select max(CAST(coalesce(sbdx_member_entry_identifier, '0') AS integer)) from entries
    Entry.select("max(CAST(coalesce(sbdx_member_entry_identifier, '0') AS integer)) as max_oid").first.max_oid.to_i
  end
  
  def Entry.get_latest_sbr
    do_more = true
    x = Entry.max_sbr_oid
    Activity.record("stolenbicycleregistry", x, "get_latest_sbr", "start")
    count = 0
    while do_more
      Entry.bunch_from_stolen_bicycle_registry(x, x+10)
      new_x = Entry.max_sbr_oid
      count += 1
      if new_x > x && count < 10
        x = new_x
      else
        do_more = false
      end
      Activity.record("stolenbicycleregistry", x, "get_latest_sbr", "continue")
    end
    Activity.record("stolenbicycleregistry", Entry.max_sbr_oid, "get_latest_sbr", "stop")
  end

  
  before_save :reset_non_serial
  def reset_non_serial
    if serial_number == '(This registrant did not provide a serial number.)'
      self_serial_number = nil
    end
  end
    
  before_save :normalize_serial
  def normalize_serial
    # This should/must match the logic in 
    # bike_index:SerialNormalizer#normalized
    
    # .gsub(/\s+/, "") would be used to remove ALL whitespace
    # but we're just removing leading+trailing whitespace for now.
    
    if serial_number.present?
      self.serial_normalized = serial_number.strip.upcase.tr(
        'O|ILSZB',
        '0111528'
      )
    else
      self.serial_normalized = nil
    end
    true
  end

  def Entry.update_missing_normalized_serials
    Entry.where("serial_number is NOT null and serial_normalized IS null").find_each do |e|
      e.normalize_serial
      e.update_attribute(:serial_normalized, e.serial_normalized)
    end
  end
  
  def Entry.snarf_from_stolen_bicycle_registry(oid)
    url = "http://stolenbicycleregistry.com/showbike.php?oid=#{oid}"
    read_url = "../snarf-sbr/sbr-showbike-#{oid}.html"
    # read_url = url
    
    known_keys = [
      'brand',
      'city/state/zip',
      'town/province/postalcode',
      'color',
      'country',
      'date stolen',
      'description',
      'model',
      'owner',
      'proof of ownership?',
      'serial #',
      'size',
      'year',
      'photo',
      'neighborhood',
      'police report?',
      'filed with',
      'report/reference #',
      'stolen from',
      'registered via'    # We're ignoring this field. Registered on some other site than SBR and fed in.
    ]

    doc = Nokogiri::HTML(open(read_url))

    data_table = doc.at_css("table:nth-of-type(3)")
    row_count = data_table.css("tr").count

    data = {}
    i = 0
    table_cells = data_table.css("td")
    while i < (row_count * 2)

      left_text = table_cells[i].text.strip.gsub(/\s+/, ' ').downcase.gsub(/:$/, '')
  
      if left_text == "photo"
        right_cell = table_cells[i+1]
        if right_cell.css("img").count > 0
          img_src = right_cell.css("img").attribute("src").value
          right_text = img_src
        end
      elsif left_text == 'bike specs'
        table_cells += table_cells[i+1].css("td")
        i += 2
        next
      elsif left_text == 'police report?'
        table_cells += table_cells[i+1].css("td")
        i += 2
        next
      end
  
      right_text ||= table_cells[i+1].text.strip.gsub(/\s+/, ' ')
      if left_text == 'date stolen'
        right_text = Date.strptime(right_text, "%m-%d-%Y")
      end
      
      data[left_text] = right_text
  
      i += 2
      right_text = nil
    end

    unknown_keys = (data.keys - known_keys)
    unknown_keys.each do |k|
      Activity.record("stolenbicycleregistry", oid, "snarf", "warning", "unknown key #{k}")
    end
    
    x = Entry.find_or_create_by_sbdx_member_and_sbdx_member_entry_identifier('stolenbicycleregistry', oid.to_s)
    
    x.date_missing                      = Entry.check_date(data['date stolen'])
    x.date_recovered                    = nil
    x.date_abandoned                    = nil
    x.neighborhood                      = data['neighborhood']
    x.city                              = data['city/state/zip'] || data['town/province/postalcode']
    x.state                             = nil
    x.zip                               = nil
    x.country                           = data['country']
    x.brand                             = data['brand']
    x.year                              = data['year']
    x.model                             = data['model']
    x.color                             = data['color']
    x.size                              = data['size']
    x.serial_number                     = data['serial #']
    x.owner_name                        = nil
    x.circumstances                     = nil
    x.stolen_from                       = data['stolen from']
    x.bicycle_description               = data['description']
    x.reward                            = data['reward']

    x.police_report_filed_with          = data['filed with'],
    x.police_report_reference           = data['report/reference #']

    x.info_url                          = url
    x.sighting_report_url               = url
    x.sighting_report_instructions      = url
    x.photo_1_url                       = data['photo']
    x.photo_2_url                       = nil
    x.photo_3_url                       = nil
    
    x.save!
    
    Activity.record("stolenbicycleregistry", oid, "snarf", "success")
    
  end
end
