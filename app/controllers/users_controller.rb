class UsersController < ApplicationController
  # CanCan authorizes the resource automatically for every action
  before_action :authenticate_user!, :except => [:show]

  # GET /users
  def index
    @users = User.all
  end
end
