module ArticlesHelper

#  def current_user?(user)
#    user == current_user
#  end

  def deny_access
    redirect_to login_path, :notice => "Please sign in to access this page."
  end

  def last_updated
    read_article = current_user.articles.find(:first, :order => "updated_at DESC", :limit => 1,
                                 :conditions => { :read => true } )
    if read_article.nil?
      last_updated = "You haven't read any article yet"
    else
      time_without_utc = read_article.updated_at + 3.hours
      difference = ActiveSupport::TimeZone[current_user.setting.utc].now.hour - Time.now.hour
      time_with_utc = time_without_utc + difference.hours
      last_updated = "Last time you have read your articles at #{time_with_utc.to_s(format = :short)}. That was #{time_ago_in_words(read_article.updated_at)} ago"
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
