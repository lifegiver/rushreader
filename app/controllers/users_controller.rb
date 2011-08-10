class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit]
  before_filter :admin_user, :only => :destroy 

  def index
    redirect_to root_path
  end
  
  def show
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
   # raise params[:user].inspect
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      redirect_to @user, :flash => { :success => "Welcome!" }
    else
      #@title = "Sign up"
      render 'new'  
    end
  end

  def edit

  end

  def update
    current_user.update_attributes(params[:user])
    current_user.save
    #user = User.authenticate(current_user.email, params[:user][:password])
    sign_in current_user
    redirect_back_or current_user
    flash.now[:success] = "Your account is protected by password"
  end

  def destroy
    @user.destroy
    redirect_to user_path, :flash => { :success => "User destroyed."}    
  end

  private

    def correct_user
      if !params[:id].nil?
        @user = User.find(params[:id])
        redirect_to(root_path) unless current_user?(@user)
      else
        true
      end
    end

    def admin_user
      @user = User.find(params[:id])
      redirect_to(root_path) if (!current_user.admin? || current_user?(@user))
    end

end
