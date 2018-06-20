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

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password, room_ids:[])
  end

end