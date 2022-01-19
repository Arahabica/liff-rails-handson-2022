class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :authenticate_user!, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  skip_before_action :verify_authenticity_token # skip CSRF check if API

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:uid, :access_token])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:uid, :access_token])
  end
end