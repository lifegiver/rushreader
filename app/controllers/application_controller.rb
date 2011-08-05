class ApplicationController < ActionController::Base
  protect_from_forgery
  include ArticlesHelper
  enable_mobile_fu
end
