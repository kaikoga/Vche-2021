class Operations::Operation
  def valid?
    validate
    true
  rescue
    false
  end

  def perform!
    validate
    perform
  end
end
