require 'test_helper'

class EntriesControllerTest < ActionController::TestCase
  setup do
    @entry = entries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:entries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create entry" do
    assert_difference('Entry.count') do
      post :create, entry: { bicycle_description: @entry.bicycle_description, brand: @entry.brand, circumstances: @entry.circumstances, city: @entry.city, color: @entry.color, country: @entry.country, date_abandoned: @entry.date_abandoned, date_missing: @entry.date_missing, date_recovered: @entry.date_recovered, info_url: @entry.info_url, model: @entry.model, neighborhood: @entry.neighborhood, owner_name: @entry.owner_name, photo_1_url: @entry.photo_1_url, photo_2_url: @entry.photo_2_url, photo_3_url: @entry.photo_3_url, reward: @entry.reward, sbdx_member: @entry.sbdx_member, sbdx_member_entry_identifier: @entry.sbdx_member_entry_identifier, serial_number: @entry.serial_number, sighting_report_instructions: @entry.sighting_report_instructions, sighting_report_url: @entry.sighting_report_url, size: @entry.size, state: @entry.state, year: @entry.year, zip: @entry.zip }
    end

    assert_redirected_to entry_path(assigns(:entry))
  end

  test "should show entry" do
    get :show, id: @entry
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @entry
    assert_response :success
  end

  test "should update entry" do
    put :update, id: @entry, entry: { bicycle_description: @entry.bicycle_description, brand: @entry.brand, circumstances: @entry.circumstances, city: @entry.city, color: @entry.color, country: @entry.country, date_abandoned: @entry.date_abandoned, date_missing: @entry.date_missing, date_recovered: @entry.date_recovered, info_url: @entry.info_url, model: @entry.model, neighborhood: @entry.neighborhood, owner_name: @entry.owner_name, photo_1_url: @entry.photo_1_url, photo_2_url: @entry.photo_2_url, photo_3_url: @entry.photo_3_url, reward: @entry.reward, sbdx_member: @entry.sbdx_member, sbdx_member_entry_identifier: @entry.sbdx_member_entry_identifier, serial_number: @entry.serial_number, sighting_report_instructions: @entry.sighting_report_instructions, sighting_report_url: @entry.sighting_report_url, size: @entry.size, state: @entry.state, year: @entry.year, zip: @entry.zip }
    assert_redirected_to entry_path(assigns(:entry))
  end

  test "should destroy entry" do
    assert_difference('Entry.count', -1) do
      delete :destroy, id: @entry
    end

    assert_redirected_to entries_path
  end
end
