class ApplicationController < ActionController::Base
  protect_from_forgery
  include ArticlesHelper
  enable_mobile_fu
  layout :layout_by_resource

  protected

  def layout_by_resource
    if devise_controller? && is_mobile_device?
      "blank"
    elsif devise_controller?
      "home"
    else
      "application"
    end
  end

end
