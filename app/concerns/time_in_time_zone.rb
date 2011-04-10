module TimeInTimeZone
  extend ActiveSupport::Concern

  private

  def today
    time_now.to_date
  end

  def time_now
    Time.now.in_time_zone(time_zone)
  end
end
