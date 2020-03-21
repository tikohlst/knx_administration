class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:create]

  def create
    if params[:authentification] == "8CRcVFoMqnf2SgYx"
      Event.write_schedules
      Event.start_schedules($emi_server)
    end
  end
end
