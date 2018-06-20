class UsersController < ApplicationController
  before_action :authenticate_user!, :except => [:show]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
    @user = User.find_by_id(params[:id])
  end
end
