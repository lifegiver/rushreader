module ArticlesHelper

#  def current_user?(user)
#    user == current_user
#  end

  def deny_access
    redirect_to login_path, :notice => "Please sign in to access this page."
  end

  def user_utc_shift
    ActiveSupport::TimeZone[current_user.setting.utc].now.hour - Time.now.hour
  end

  def user_time
    Time.now + user_utc_shift.hours
  end

  def last_read_article
    current_user.articles.find(:first, :order => "updated_at DESC", :limit => 1,
                               :conditions => { :read => true } )
  end

  def time_from_last_reading
    Time.now - last_read_article.updated_at.to_time
  end

  def last_read_time
    last_article = last_read_article
    if last_article.nil?
      "Well, you haven't read any article yet."
    else
      #time_without_utc = last_read_article.updated_at - 4.hours
      #time_with_utc = time_without_utc + user_utc_shift.hours
      #last_updated = "Last time you have read your articles at #{time_with_utc.to_s(format = :short)}. That was #{time_ago_in_words(read_article.updated_at)} ago"
      "Last article was read #{time_ago_in_words(last_article.updated_at)} ago."
    end
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
