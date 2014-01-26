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
    
end
