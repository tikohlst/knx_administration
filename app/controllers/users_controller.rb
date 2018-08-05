class UsersController < ApplicationController
  # CanCan authorizes the resource automatically for every action
  before_action :authenticate_user!
  load_and_authorize_resource

  $params = nil

  def index
    puts params[:term]
    @users = if (params[:term] && params[:term] != "") || $params
      $params = params[:term] if params[:term]
      # Searching for username or id
      User.where('username LIKE :p OR id LIKE :p', p: "%#{$params}%")

      # Searching for role
      #User.joins(:roles).merge(Role.where('name LIKE :p', p: "%#{params[:term]}%"))
    else
      $params = nil
      User.all
    end
  end

  def sort_by_ids
    @users = if (params[:term] && params[:term] != "") || $params
      $params = params[:term] if params[:term]
      # Searching for username or id
      User.where('username LIKE :p OR id LIKE :p', p: "%#{$params}%")
    else
      $params = nil
      User.all
    end
  end

  def sort_by_usernames
    @users = if (params[:term] && params[:term] != "") || $params
      $params = params[:term] if params[:term]
      # Searching for username or id
      User.where('username LIKE :p OR id LIKE :p', p: "%#{$params}%")
    else
      $params = nil
      User.all
    end
  end

  def sort_by_roles
    @users = if (params[:term] && params[:term] != "") || $params
      $params = params[:term] if params[:term]
      # Searching for username or id
      User.where('username LIKE :p OR id LIKE :p', p: "%#{$params}%")
    else
      $params = nil
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
        format.html { redirect_to users_url, notice: 'User was successfully created.' }
        format.json { head :no_content }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      @user = User.find(params[:id])
      params[:user].delete(:password) if params[:user][:password].blank?
      params[:user].delete(:password_confirmation) if params[:user][:password].blank? and params[:user][:password_confirmation].blank?

      if @user.update(user_params)
        format.html { redirect_to users_url, notice: 'User was successfully updated.' }
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
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :username, :password, :password_confirmation, role_ids:[])
  end
end
