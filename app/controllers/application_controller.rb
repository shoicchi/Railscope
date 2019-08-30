# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # activeadminを使用していてuserとadmin両方でログインを順番に行うと両方ともdeviseを使用してログインを行なっているためInvalidAuthenticityTokenのerror発生CSRF保護を無効にして回避
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: -> { controller_name == 'sessions' && action_name == 'create' }

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
