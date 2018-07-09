class UsersController < ApplicationController
  before_action :authenticate_user!, :except => [:show]

  # GET /users
  def index
    @users = User.all
  end
end
