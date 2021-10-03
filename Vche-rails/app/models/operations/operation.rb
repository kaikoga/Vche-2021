class Operations::Operation
  def valid?
    validate
    true
  rescue
    false
  end

  def perform!
    raise ActiveRecord::RecordInvalid unless valid?
    perform
  end
end
