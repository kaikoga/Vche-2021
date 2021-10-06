class FeedbacksLoyalty < ApplicationLoyalty
  def new?
    true
  end

  def create?
    true
  end

  def done?
    true
  end
end
