class ApplicationController < ActionController::Base
  prepend_before_action :set_locale
  protect_from_forgery prepend: true
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def set_locale
    # Only if the parameter "username" matches the username of the current user, the language
    # may be changed
    if params.try(:[], :user).try(:[], :username) == current_user.try(:[], :username)
      # Whitelist locales available for the application
      locales = I18n.available_locales.map(&:to_s)
      I18n.locale = if locales.include? params.try(:[], :user).try(:[], :language)
        params[:user][:language]
      elsif locales.include? params[:locale]
        params[:locale]
      else
        I18n.default_locale
      end
    else
      # Because of an internal I18n problem, sometimes the I18n.locale variable is mysteriously
      # overwritten in the background. So for security I have to set it again to the stored language
      I18n.locale = params[:locale]
    end
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def after_sign_in_path_for(resource)
    # Set the user language after the sign in
    if resource.is_a?(User) and resource.language != I18n.locale
      I18n.locale = resource.language
    end

    # Get to the widgets path after the sign in
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
