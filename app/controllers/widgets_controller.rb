class WidgetsController < ApplicationController
  # CanCan authorizes the resource automatically for every action
  load_and_authorize_resource
  before_action :set_widget, only: [:show, :edit, :update, :destroy]

  # GET /widgets
  # GET /widgets.json
  def index
    @widgets = if params[:term]
      # Searching for name
      Widget.joins(:room).where('widgets.id LIKE :p OR widgets.name LIKE :p OR
      rooms.name LIKE :p', p: "%#{params[:term]}%")
    else
      Widget.all
    end
  end

  # GET /widgets/1
  # GET /widgets/1.json
  def show
  end

  # GET /widgets/1/rules
  def rules
    respond_to do |format|
      format.js
    end
  end

  # GET /widgets/new
  def new
    @widget = Widget.new
    @widget.rules.build
  end

  # GET /widgets/1/edit
  def edit
  end

  # POST /widgets
  # POST /widgets.json
  def create
    @widget = Widget.new(widget_params)

    respond_to do |format|
      if @widget.save
        format.html { redirect_to @widget, notice: 'Widget was successfully created.' }
        format.json { render :show, status: :created, location: @widget }
      else
        format.html { render :new }
        format.json { render json: @widget.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /widgets/1
  # PATCH/PUT /widgets/1.json
  def update
    respond_to do |format|
      if widget_params.keys[0] == "value"
        if (@widget.use == "lighting")
          if widget_params.values[0] == "0"
            @errors = @widget.update_attribute(:value, 1)
          else
            @errors = @widget.update_attribute(:value, 0)
          end
        else
          @errors = @widget.update_attribute(:value, widget_params.values[0])
        end
      else
        @errors = @widget.update(widget_params)
      end

      if @errors
        format.html { redirect_to action: "index" }
        #format.json { render :show, status: :ok, location: @widget }

        ActionCable.server.broadcast 'widgets', @widget
      else
        format.html { render :edit }
        format.json { render json: @widget.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /widgets/1
  # DELETE /widgets/1.json
  def destroy
    @widget.destroy
    respond_to do |format|
      format.html { redirect_to widgets_url, notice: 'Widget was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_widget
      @widget = Widget.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def widget_params
      params.require(:widget).permit(:name, :active, :value, :knx_module_id, :room_id, rules_attributes: [:id, :name, :status, :start_value, :end_value, :steps, :widget_id])
    end
end
