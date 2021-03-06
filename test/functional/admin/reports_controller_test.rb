# -*- coding: utf-8 -*-

require File.dirname(__FILE__) + '/../../test_helper'

class Admin::ReportsControllerTest < ActionController::TestCase

  def setup
    Award.stubs(:max_entries).returns(2)
    login_as(:admin)
    @competition_name = CompetitionData.instance.name
  end

  def test_index
    get :index
    assert_response :success

    # Validate page contents
    assert_select 'html > head > title', "#{@competition_name} Reports"
    assert_select 'div#content' do
      assert_select 'h1', "#{@competition_name} Reports"
      assert_select 'div#reports-menu > ul' do
        assert_select 'li', :minimum => 1
      end
    end
  end

  def test_report_entries_by_club
    get :report_entries_by_club
    assert_response :success

    assert_select 'div#content > table' do
      assert_select 'tr', :count => 7  # 4 clubs with registered entries + total + header and footer
      assert_select 'tr > td:first-child', :count => 4
    end
  end

  def test_report_processed_entries_by_club
    get :report_entries_by_club, :type => 'processed'
    assert_response :success

    assert_select 'div#content > table' do
      assert_select 'tr', :count => 7  # 4 clubs with processed entries + total + header and footer
      assert_select 'tr > td:first-child', :count => 4
    end
  end

  def test_report_unprocessed_entries_by_club
    get :report_entries_by_club, :type => 'unprocessed'
    assert_response :success

    assert_select 'div#content > table' do
      assert_select 'tr', :count => 5  # 2 clubs with unprocessed entries + total + header and footer
      assert_select 'tr > td:first-child', :count => 2
    end
  end

  def test_report_entries_by_individual
    get :report_entries_by_individual
    assert_response :success

    assert_select 'div#content > table' do
      assert_select 'tr', :count => 5  # 3 individuals with registered + header and footer
      assert_select 'tr > td:first-child', :count => 3
    end
  end

  def test_report_processed_entries_by_individual
    get :report_entries_by_individual, :type => 'processed'
    assert_response :success

    assert_select 'div#content > table' do
      assert_select 'tr', :count => 5  # 3 individuals with processed entries + header and footer
      assert_select 'tr > td:first-child', :count => 3
    end
  end

  def test_report_unprocessed_entries_by_individual
    get :report_entries_by_individual, :type => 'unprocessed'
    assert_response :success

    assert_select 'div#content > table' do
      assert_select 'tr', :count => 3  # 1 individual with unprocessed entries + header and footer
      assert_select 'tr > td:first-child', :count => 1
    end
  end

  def test_report_entries_by_team
    get :report_entries_by_team
    assert_response :success

    assert_select 'div#content > table' do
      assert_select 'tr', :count => 5  # 3 teams with registered entries + header and footer
      assert_select 'tr > td:first-child', :count => 3
    end
  end

  def test_report_processed_entries_by_team
    get :report_entries_by_team, :type => 'processed'
    assert_response :success

    assert_select 'div#content > table' do
      assert_select 'tr', :count => 4  # 2 teams with processed entries + header and footer
      assert_select 'tr > td:first-child', :count => 2
    end
  end

  def test_report_unprocessed_entries_by_team
    get :report_entries_by_team, :type => 'unprocessed'
    assert_response :success

    assert_select 'div#content > table' do
      assert_select 'tr', :count => 4  # 2 teams with unprocessed entries + header and footer
      assert_select 'tr > td:first-child', :count => 2
    end
  end

  def test_report_entries_by_style
    get :report_entries_by_style
    assert_response :success

    category_count = Category.count(:conditions => [ 'is_public = ?', true ])
    award_count = Award.count(:joins => 'AS a INNER JOIN categories AS c ON (c.id = a.category_id)', :conditions => [ 'c.is_public = ?', true ])
    style_count = Style.count

    assert_select 'div#content > table' do
      assert_select 'tr', :count => category_count + award_count + style_count + 3
      assert_select 'tr > th:first-child', :count => category_count + award_count + 3
      assert_select 'tr > td:first-child', :count => style_count
      assert_select 'tbody > tr:nth-last-child(1) > th:first-child', 'Total'
      assert_select 'tbody > tr:nth-last-child(1) > th:last-child', '42'
    end
  end

  def test_report_processed_entries_by_style
    get :report_entries_by_style, :type => 'processed'
    assert_response :success

    category_count = Category.count(:conditions => [ 'is_public = ?', true ])
    award_count = Award.count(:joins => 'AS a INNER JOIN categories AS c ON (c.id = a.category_id)', :conditions => [ 'c.is_public = ?', true ])
    style_count = Style.count

    assert_select 'div#content > table' do
      assert_select 'tr', :count => category_count + award_count + style_count + 3
      assert_select 'tr > th:first-child', :count => category_count + award_count + 3
      assert_select 'tr > td:first-child', :count => style_count
      assert_select 'tbody > tr:nth-last-child(1) > th:first-child', 'Total'
      assert_select 'tbody > tr:nth-last-child(1) > th:last-child', '34'
    end
  end

  def test_report_unprocessed_entries_by_style
    get :report_entries_by_style, :type => 'unprocessed'
    assert_response :success

    category_count = Category.count(:conditions => [ 'is_public = ?', true ])
    award_count = Award.count(:joins => 'AS a INNER JOIN categories AS c ON (c.id = a.category_id)', :conditions => [ 'c.is_public = ?', true ])
    style_count = Style.count

    assert_select 'div#content > table' do
      assert_select 'tr', :count => category_count + award_count + style_count + 3
      assert_select 'tr > th:first-child', :count => category_count + award_count + 3
      assert_select 'tr > td:first-child', :count => style_count
      assert_select 'tbody > tr:nth-last-child(1) > th:first-child', 'Total'
      assert_select 'tbody > tr:nth-last-child(1) > th:last-child', '8'
    end
  end

  def test_report_entries_by_region
    get :report_entries_by_region
    assert_response :success

    assert_select 'div#content > table' do
      assert_select 'tr', :count => 9  # 2 countries + 4 states/provinces + total + header and footer
      assert_select 'tr > th:first-child', :count => 5 # 2 countries + total + header and footer
      assert_select 'tr > td:first-child', :count => 4 # 3 states + 1 province
      assert_select 'tbody > tr:nth-child(1) > th:first-child', 'Canada'
      assert_select 'tbody > tr:nth-child(1) > th:last-child', '3'
      assert_select 'tbody > tr:nth-child(3) > th:first-child', 'United States'
      assert_select 'tbody > tr:nth-child(3) > th:last-child', '39'
      assert_select 'tbody > tr:nth-last-child(1) > th:first-child', 'Total'
      assert_select 'tbody > tr:nth-last-child(1) > th:last-child', '42'
    end
  end

  def test_report_processed_entries_by_region
    get :report_entries_by_region, :type => 'processed'
    assert_response :success

    assert_select 'div#content > table' do
      assert_select 'tr', :count => 9  # 2 countries + 4 states/provinces + total + header and footer
      assert_select 'tr > th:first-child', :count => 5 # 2 countries + total + header and footer
      assert_select 'tr > td:first-child', :count => 4 # 3 states + 1 province
      assert_select 'tbody > tr:nth-child(1) > th:first-child', 'Canada'
      assert_select 'tbody > tr:nth-child(1) > th:last-child', '3'
      assert_select 'tbody > tr:nth-child(3) > th:first-child', 'United States'
      assert_select 'tbody > tr:nth-child(3) > th:last-child', '31'
      assert_select 'tbody > tr:nth-last-child(1) > th:first-child', 'Total'
      assert_select 'tbody > tr:nth-last-child(1) > th:last-child', '34'
    end
  end

  def test_report_unprocessed_entries_by_region
    get :report_entries_by_region, :type => 'unprocessed'
    assert_response :success

    assert_select 'div#content > table' do
      assert_select 'tr', :count => 6  # 1 country + 2 states + total + header and footer
      assert_select 'tr > th:first-child', :count => 4 # 1 country + total + header and footer
      assert_select 'tr > td:first-child', :count => 2 # 2 states
      assert_select 'tbody > tr:nth-child(1) > th:first-child', 'United States'
      assert_select 'tbody > tr:nth-child(1) > th:last-child', '8'
      assert_select 'tbody > tr:nth-last-child(1) > th:first-child', 'Total'
      assert_select 'tbody > tr:nth-last-child(1) > th:last-child', '8'
    end
  end

  def test_report_excess_entries
    get :report_excess_entries
    assert_response :success

    assert_select 'div#content > table' do
      assert_select 'tr', :count => 38  # 1 individual + 3 teams + 7 awards + 25 entries + header and footer
      assert_select 'tr > th:first-child', :count => 13 # 1 individual + 3 teams + 7 awards + header and footer
      assert_select 'tr > td:first-child', :count => 25 # 25 entries
    end
  end

  def test_report_processed_excess_entries
    get :report_excess_entries, :type => 'processed'
    assert_response :success

    assert_select 'div#content > table' do
      assert_select 'tr', :count => 22  # 1 team + 4 awards + 15 entries + header and footer
      assert_select 'tr > th:first-child', :count => 7 # 1 team + 4 awards + header and footer
      assert_select 'tr > td:first-child', :count => 15 # 15 entries
    end
  end

  def test_report_unprocessed_excess_entries
    get :report_excess_entries, :type => 'unprocessed'
    assert_response :success

    assert_select 'div#content > table' do
      assert_select 'tr', :count => 13  # 1 individual + 1 team + 2 awards + 7 entries + header and footer
      assert_select 'tr > th:first-child', :count => 6 # 1 individual + 1 team + 2 awards + header and footer
      assert_select 'tr > td:first-child', :count => 7 # 7 entries
    end
  end

  def test_report_confirmed_judges
    get :report_confirmed_judges
    assert_response :success

    assert_select 'div#content > table > tbody' do
      assert_select 'tr', :count => 5
    end
  end

end
