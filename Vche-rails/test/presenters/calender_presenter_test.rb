require 'test_helper'

class CalendarPresenterTest < ActiveSupport::TestCase
  setup do
    @user = users(:default)
    @events = events(:default)
  end

  teardown do
  end

  test '#year_and_month default' do
    travel_to(Time.zone.parse('2021-11-11 09:00:00')) do
      @subject = CalendarPresenter.new([events(:default)], user: users(:default))
      assert { @subject.current }
      assert { @subject.current_date_text == '' }
      assert { @subject.prev_date == Time.zone.parse('2021-11-01') }
      assert { @subject.next_date == Time.zone.parse('2021-12-01') }
    end
  end

  test '#year_and_month default January' do
    travel_to(Time.zone.parse('2021-01-11 09:00:00')) do
      @subject = CalendarPresenter.new([events(:default)], user: users(:default))
      assert { @subject.current }
      assert { @subject.current_date_text == '' }
      assert { @subject.prev_date == Time.zone.parse('2021-01-01') }
      assert { @subject.next_date == Time.zone.parse('2021-02-01') }
    end
  end

  test '#year_and_month default December' do
    travel_to(Time.zone.parse('2021-12-11 09:00:00')) do
      @subject = CalendarPresenter.new([events(:default)], user: users(:default))
      assert { @subject.current }
      assert { @subject.current_date_text == '' }
      assert { @subject.prev_date == Time.zone.parse('2021-12-01') }
      assert { @subject.next_date == Time.zone.parse('2022-01-01') }
    end
  end

  test '#year_and_month specified' do
    travel_to(Time.zone.parse('2021-11-11 09:00:00')) do
      @subject = CalendarPresenter.new([events(:default)], user: users(:default), date: Time.zone.parse('20011101'))
      assert { !@subject.current }
      assert { @subject.current_date_text == '2001/11' }
      assert { @subject.prev_date == Time.zone.parse('2001-10-01') }
      assert { @subject.next_date == Time.zone.parse('2001-12-01') }
    end
  end

  test '#year_and_month specified January' do
    travel_to(Time.zone.parse('2021-11-11 09:00:00')) do
      @subject = CalendarPresenter.new([events(:default)], user: users(:default), date: Time.zone.parse('20010101'))
      assert { !@subject.current }
      assert { @subject.current_date_text == '2001/01' }
      assert { @subject.prev_date == Time.zone.parse('2000-12-01') }
      assert { @subject.next_date == Time.zone.parse('2001-02-01') }
    end
  end

  test '#year_and_month specified December' do
    travel_to(Time.zone.parse('2021-11-11 09:00:00')) do
      @subject = CalendarPresenter.new([events(:default)], user: users(:default), date: Time.zone.parse('20011201'))
      assert { !@subject.current }
      assert { @subject.current_date_text == '2001/12' }
      assert { @subject.prev_date == Time.zone.parse('2001-11-01') }
      assert { @subject.next_date == Time.zone.parse('2002-01-01') }
    end
  end

  test '#cells_by_date specified days' do
    travel_to(Time.zone.parse('2021-11-11 09:00:00')) do
      @subject = CalendarPresenter.new([events(:default)], user: users(:default), months: 0, days: 14)
      assert { @subject.cells_by_date.keys.include? Time.zone.parse('2021-11-11 00:00:00') }
      assert { @subject.cells_by_date.keys.include? Time.zone.parse('2021-11-18 00:00:00') }
      assert { @subject.cells_by_date.keys.exclude? Time.zone.parse('2021-11-25 00:00:00') }
      assert { @subject.cells_by_date.keys.count == 14 }
    end
  end

  test '#cells_by_date specified months' do
    travel_to(Time.zone.parse('2021-11-11 09:00:00')) do
      @subject = CalendarPresenter.new([events(:default)], user: users(:default), months: 1, days: 0)
      assert { @subject.cells_by_date.keys.include? Time.zone.parse('2021-11-11 00:00:00') }
      assert { @subject.cells_by_date.keys.include? Time.zone.parse('2021-11-30 00:00:00') }
      assert { @subject.cells_by_date.keys.include? Time.zone.parse('2021-12-10 00:00:00') }
      assert { @subject.cells_by_date.keys.exclude? Time.zone.parse('2021-12-20 00:00:00') }
      assert { @subject.cells_by_date.keys.count.in?(30..37) }
    end
  end
end
