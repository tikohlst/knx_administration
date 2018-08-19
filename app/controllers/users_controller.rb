class UsersController < ApplicationController
  # CanCan authorizes the resource automatically for every action
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @users = if (params[:term] && params[:term] != "") ||
        ($users_search_params[current_user.username] && $users_search_params[current_user.username] != "")
      $users_search_params[current_user.username] = params[:term] if params[:term]
      User.where('username LIKE :p OR id LIKE :p', p: "%#{$users_search_params[current_user.username]}%")

      # Searching for role
      #User.joins(:roles).merge(Role.where('name LIKE :p', p: "%#{params[:term]}%"))
    else
      $users_search_params[current_user.username] = nil
      User.all
    end
  end

  def sort_by_ids
    @users = if (params[:term] && params[:term] != "") ||
        ($users_search_params[current_user.username] && $users_search_params[current_user.username] != "")
      $users_search_params[current_user.username] = params[:term] if params[:term]
      User.where('username LIKE :p OR id LIKE :p', p: "%#{$users_search_params[current_user.username]}%")
    else
      $users_search_params[current_user.username] = nil
      User.all
    end
  end

  def sort_by_usernames
    @users = if (params[:term] && params[:term] != "") ||
        ($users_search_params[current_user.username] && $users_search_params[current_user.username] != "")
      $users_search_params[current_user.username] = params[:term] if params[:term]
      User.where('username LIKE :p OR id LIKE :p', p: "%#{$users_search_params[current_user.username]}%")
    else
      $users_search_params[current_user.username] = nil
      User.all
    end
  end

  def sort_by_roles
    @users = if (params[:term] && params[:term] != "") ||
        ($users_search_params[current_user.username] && $users_search_params[current_user.username] != "")
      $users_search_params[current_user.username] = params[:term] if params[:term]
      User.where('username LIKE :p OR id LIKE :p', p: "%#{$users_search_params[current_user.username]}%")
    else
      $users_search_params[current_user.username] = nil
      User.all
    end
  end

  def new
    @user = User.new
  end

  def create
    respond_to do |format|
      @user = User.new(user_params)
      if @user.save
        format.html { redirect_to users_url, notice: (t ('views.created'), created: (t ('views.single_user'))) }
        format.json { head :no_content }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @user = User.find(params[:id])
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password].blank? and params[:user][:password_confirmation].blank?

    respond_to do |format|
      if @user.update(user_params)
        # If there is a new role, delete the old role and insert the new one into the database
        if params[:user][:role_ids] != @user.role_ids.first.to_s
          ActiveRecord::Base.connection.execute("DELETE FROM users_roles WHERE user_id = #{params[:id]};")
          ActiveRecord::Base.connection.execute("INSERT INTO users_roles VALUES (#{params[:id]}, #{params[:user][:role_ids]});")
        end
        format.html { redirect_to users_url, notice: (t ('views.updated'), updated: (t ('views.single_user'))) }
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: (t ('views.destroyed'), destroyed: (t ('views.single_user'))) }
      format.json { head :no_content }
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :username, :password, :password_confirmation, :language, :role_ids, org_unit_ids:[])
  end
end
