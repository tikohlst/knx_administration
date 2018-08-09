class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  def set_locale
    I18n.locale = if ["de", "en"].include? params.try(:[], :user).try(:[], :language)
      params[:user][:language]
    elsif ["de", "en"].include? params[:locale]
      params[:locale]
    else
      I18n.default_locale
    end
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def after_sign_in_path_for(resource)
    widgets_url
  end

  protect_from_forgery
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to widgets_url
  end

  protected
  def configure_permitted_parameters
    # Allows the parameter "language" for the actual user
    devise_parameter_sanitizer.permit(:sign_up, keys: [:language])
    devise_parameter_sanitizer.permit(:account_update, keys: [:language])
  end

end
