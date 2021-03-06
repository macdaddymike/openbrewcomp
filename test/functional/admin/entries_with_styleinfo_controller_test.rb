# -*- coding: utf-8 -*-

require File.dirname(__FILE__) + '/../../test_helper'

class Admin::EntriesWithStyleinfoControllerTest < ActionController::TestCase

  def setup
    login_as(:admin)
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_new
    # Cannot create a new entry
    assert_raise(ActionController::UnknownAction) do
      get :new
    end
  end

  def test_create
    # Cannot create a new entry
    assert_raise(ActionController::UnknownAction) do
      post :create, :record => { :style_id => styles(:style_16E).id,
                                 :style_info => 'foo' }
    end
  end

  def test_search
    year = Date.today.year
    get :index, :search => year
    assert_template 'list'
  end

  def test_show
    get :show, :id => get_first_record.id
    assert_response :success
    assert_template 'show'
  end

  def test_edit
    get :edit, :id => get_first_record.id
    assert_response :success
    assert_template 'update'
  end

  def test_update
    record = get_first_required_record
    assert_no_difference [ 'Entry.count', 'get_record_count' ] do
      post :update, :id => record.id,
                    :record => { :style_info => "#{record.style_info} (modified)" }
    end
    assert_redirected_to admin_entries_with_styleinfo_index_path
  end

  def test_purge_style_info
    record = get_first_optional_record
    assert_difference('get_record_count', -1) do
      post :update, :id => record.id, :record => { :style_info => '' }
    end
    assert_redirected_to admin_entries_with_styleinfo_index_path
  end

  def test_destroy_action_should_not_be_recognized
    assert_raise(ActionController::UnknownAction) do
      delete :destroy, :id => get_first_record.id
    end
  end

  private

    def get_first_record
      Entry.find(:first,
                 :conditions => 'style_info IS NOT NULL')
    end

    def get_first_required_record
      Entry.find(:first,
                 :select => 'e.*',
                 :joins => %q{AS e INNER JOIN styles AS s ON (e.style_id = s.id)},
                 :conditions => %q{e.style_info IS NOT NULL AND s.styleinfo = 'r'})
    end

    def get_first_optional_record
      Entry.find(:first,
                 :select => 'e.*',
                 :joins => %q{AS e INNER JOIN styles AS s ON (e.style_id = s.id)},
                 :conditions => %q{e.style_info IS NOT NULL AND s.styleinfo = 'o'})
    end

    def get_record_count
      Entry.count(:conditions => 'style_info IS NOT NULL')
    end

end
