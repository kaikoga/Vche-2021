require 'test_helper'

class CalendarPresenterTest < ActiveSupport::TestCase
  setup do
    @user = users(:default)
    @events = events(:default)
  end

  teardown do
    # Do nothing
  end

  test 'default' do
    travel_to(Time.zone.parse('2021-11-11 09:00:00')) do
      @subject = CalendarPresenter.new([events(:default)], user: users(:default))
      assert { @subject.year_and_month == '' }
      assert { @subject.prev_year == 2021 }
      assert { @subject.next_year == 2021 }
      assert { @subject.prev_month == 11 }
      assert { @subject.next_month == 12 }
    end
  end
end
