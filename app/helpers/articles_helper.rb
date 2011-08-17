module ArticlesHelper

#  def current_user?(user)
#    user == current_user
#  end
  require 'albino'

  def read?(article)
    #UserArticle.find(:first, :order => "updated_at DESC", :limit => 1,
     #                          :conditions => { :user_id => current_user.id, :read => true } )
    result = UserArticle.find( :first, :limit => 1,
                                  :conditions => { :article_id => article.id, 
                                                   :user_id => current_user.id })
    return result.read
  end

  def highlight(text)
    Albino.colorize(text, :css).to_s.html_safe
  end 

  def deny_access
    redirect_to login_path, :notice => "Please sign in to access this page."
  end

  def user_utc_shift
    ActiveSupport::TimeZone[current_user.setting.utc].now.hour - Time.now.hour
  end

  def user_time
    Time.now + user_utc_shift.hours
  end

  def read_in
    current_user.setting.interval_between_readings.minutes
  end

  def last_read_article
    duplicate_article = UserArticle.find(:first, :order => "updated_at DESC", :limit => 1,
                                         :conditions => {:user_id => current_user.id, :read => true})
    last_read_article = UserArticle.find(:first, :limit => 1, 
                                         :conditions => {:article_id => duplicate_article.id, 
                                                         :user_id => current_user.id})
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
