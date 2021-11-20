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
      assert { @subject.year_and_month == '' }
      assert { @subject.prev_year == 2021 }
      assert { @subject.next_year == 2021 }
      assert { @subject.prev_month == 11 }
      assert { @subject.next_month == 12 }
    end
  end

  test '#year_and_month default January' do
    travel_to(Time.zone.parse('2021-01-11 09:00:00')) do
      @subject = CalendarPresenter.new([events(:default)], user: users(:default))
      assert { @subject.year_and_month == '' }
      assert { @subject.prev_year == 2021 }
      assert { @subject.next_year == 2021 }
      assert { @subject.prev_month == 1 }
      assert { @subject.next_month == 2 }
    end
  end

  test '#year_and_month default December' do
    travel_to(Time.zone.parse('2021-12-11 09:00:00')) do
      @subject = CalendarPresenter.new([events(:default)], user: users(:default))
      assert { @subject.year_and_month == '' }
      assert { @subject.prev_year == 2021 }
      assert { @subject.next_year == 2022 }
      assert { @subject.prev_month == 12 }
      assert { @subject.next_month == 1 }
    end
  end

  test '#year_and_month specified' do
    travel_to(Time.zone.parse('2021-11-11 09:00:00')) do
      @subject = CalendarPresenter.new([events(:default)], user: users(:default), year: 2001, month: 11)
      assert { @subject.year_and_month == '2001/11' }
      assert { @subject.prev_year == 2001 }
      assert { @subject.next_year == 2001 }
      assert { @subject.prev_month == 10 }
      assert { @subject.next_month == 12 }
    end
  end

  test '#year_and_month specified January' do
    travel_to(Time.zone.parse('2021-11-11 09:00:00')) do
      @subject = CalendarPresenter.new([events(:default)], user: users(:default), year: 2001, month: 1)
      assert { @subject.year_and_month == '2001/1' }
      assert { @subject.prev_year == 2000 }
      assert { @subject.next_year == 2001 }
      assert { @subject.prev_month == 12 }
      assert { @subject.next_month == 2 }
    end
  end

  test '#year_and_month specified December' do
    travel_to(Time.zone.parse('2021-11-11 09:00:00')) do
      @subject = CalendarPresenter.new([events(:default)], user: users(:default), year: 2001, month: 12)
      assert { @subject.year_and_month == '2001/12' }
      assert { @subject.prev_year == 2001 }
      assert { @subject.next_year == 2002 }
      assert { @subject.prev_month == 11 }
      assert { @subject.next_month == 1 }
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
