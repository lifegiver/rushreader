module SessionsHelper

# If user is new (his login doesn't presence in user database), the user is registered.
# If user exists and didn't protect his account with password, the user is signed in.
# If user exists and protect his accout with password, the user is asked for password.
  def password_check
    user = User.find_by_email(params[:session][:email])
    if user.nil?
      @user = User.new(:email => params[:session][:email])
      @user.save
      sign_in @user
      redirect_to @user, :flash => { :success => "Welcome!" }
    else
      if (user && user.encrypted_password.nil?)
        sign_in user
        redirect_back_or user
      else
        session[:email] = params[:session][:email]
        respond_to do |format|
          format.js do
              render :partial => "sessions/form", :layout => false, :status => 401
          end
          format.html do
              redirect_to signin_path
          end
        end

        #:flash => { :failure => "The account #{session[:email]} is protected by password"
      end
    end
  end

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user 
    @current_user ||= user_from_remember_token
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def current_user?(user)
    user == current_user
  end

  def authenticate
    deny_access unless signed_in?
  end

  def deny_access
    store_location
    redirect_to root_path, :notice => "Please sign in to access this page."
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  def clear_return_to
    session[:return_to] = nil
  end

  def admin_user
    redirect_to(root_path) if (!current_user.admin?)
  end

  private
  
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end
    
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end

end
