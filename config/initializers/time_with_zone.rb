class ActiveSupport::TimeWithZone
  def as_json(options = {})
    strftime("%d-%b-%Y %H:%M:%S")
  end
end