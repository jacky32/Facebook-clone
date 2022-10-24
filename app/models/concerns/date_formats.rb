module DateFormats
  extend ActiveSupport::Concern

  def formatted_date
    return created_at_local.strftime('%H:%M') if today?
    return created_at_local.strftime('%H:%M, %-d. %B %Y') unless this_year?
    return created_at_local.strftime('%H:%M, %-d. %B') unless this_year?
  end

  def time_difference
    return minutes if this_hour?
    return hours if today?
    return days if this_week?
    return weeks if this_month?
    return months if this_year?
  end

  def hover_date
    created_at_local.in_time_zone('Prague').strftime('%A, %B %d, %Y at %H:%M')
  end

  private

  def this_hour?
    time = (Time.current - created_at_local.to_time) / 60
    time < 60
  end

  def minutes
    "#{((Time.current - created_at_local.to_time) / 60).to_i}m"
  end

  def today?
    date = Date.current - created_at_local.to_date
    date < 1
  end

  def hours
    hours = ((Time.current - created_at_local.to_time) / 3600).to_i
    return "#{hours} hour ago" if hours == 1

    "#{hours} hours ago"
  end

  def this_week?
    date = Date.current - created_at_local.to_date
    date < 7
  end

  def days
    "#{((Time.current - created_at_local.to_time) / 86_400).to_i} days ago"
  end

  def this_month?
    date = Date.current - created_at_local.to_date
    date < 30
  end

  def weeks
    "#{((Time.current - created_at_local.to_time) / 604_800).to_i} weeks ago"
  end

  def this_year?
    date = Date.current - created_at_local.to_date
    date < 365
  end

  def months
    "#{((Time.current - created_at_local.to_time) / 2_629_743).to_i} months ago"
  end

  def years
    "#{((Time.current - created_at_local.to_time) / 31_556_926).to_i} years ago"
  end

  def created_at_local
    created_at.in_time_zone('Prague')
  end
end
