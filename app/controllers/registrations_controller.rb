class RegistrationsController < Devise::RegistrationsController
  before_action :one_user_registered?, only: [:new, :create]

  protected
  def one_user_registered?
    if User.count == 1
      if user_signed_in?
        redirect_to root_path
      else
        redirect_to new_user_session_path
      end
    end
  end

  def update_resource(resource, params)
    if params["current_password"] == "" && params["password"] == "" && params["password_confirmation"] == ""
      # If the user just want to change the language he doesn't need the password
      params.delete("current_password")
      resource.update_without_password(params)
    else
      # If the user want to change the password
      resource.update_with_password(params)
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def account_update_params
    params.require(:user).permit(:username, :password, :password_confirmation, :current_password, :language, role_ids:[])
  end

end