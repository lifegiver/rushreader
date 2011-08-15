class SessionsController < ApplicationController

  def new
    @title = "Sign in"
  end
  
  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      respond_to do |format|
        flash.now[:error] = "Invalid password."
        format.js { render :partial => "sessions/form", :layout => !request.xhr?, :status => 401 }
        format.html { render 'new' }
      end

    else
      sign_in user
      redirect_back_or user
    end
  end
 
  def destroy
    session[:email] = nil
    session[:password] = nil
    sign_out
    redirect_to root_path
  end

end
