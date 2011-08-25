module ArticlesHelper
  require 'albino'

# Highlighting of string with css syntax
  def highlight(text)
    Albino.colorize(text, :css).to_s.html_safe
  end 

  def deny_access
    redirect_to login_path, :notice => "Please sign in to access this page."
  end

# Difference between server and user time zones
  def user_utc_shift
    ActiveSupport::TimeZone[current_user.setting.utc].now.hour - Time.now.hour
  end

  def user_time
    Time.now + user_utc_shift.hours
  end

  def read_in
    current_user.setting.interval_between_readings.minutes
  end

  def load_popular_articles
    popart_ids = YAML::load(File.open('lib/popular_articles.yml'))
  end

  def popular_articles_empty?
    return load_popular_articles.blank?
  end

  def last_read_article
    current_user.user_articles.where(:read => true).order("updated_at DESC").first
  end

  def time_from_last_reading
    (Time.zone.now - last_read_article.updated_at.to_time).floor
  end

  def last_read_time
    read_in - time_from_last_reading
  end

#  def time_ago
#    lu = current_user.articles.find(:first, :order => "updated_at DESC", :limit => 1,
#                                 :conditions => { :read => true } )
#    if lu.nil?
#      last_updated = ""
#    else
#      last_updated = lu.updated_at.to_s()
#    end
#  end


#  def store_location
#    session[:return_to] = request.fullpath
#  end

#  def redirect_back_or(default)
#    redirect_to(session[:return_to] || default)
#    clear_return_to
#  end

#  def clear_return_to
#    session[:return_to] = nil
#  end

end
