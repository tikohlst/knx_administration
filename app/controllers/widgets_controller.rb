class WidgetsController < ApplicationController
  # CanCan authorizes the resource automatically for every action
  load_and_authorize_resource
  before_action :set_widget, only: [:show, :edit, :update, :destroy]

  $params = nil

  # GET /widgets
  # GET /widgets.json
  def index
    @widgets = if params[:term] || $params
      $params = params[:term] if params[:term]
      Widget.where('id LIKE :p OR name LIKE :p', p: "%#{$params}%")
    else
      $params = nil
      Widget.all
    end
    @lightings = $lightings
  end

  def sort_by_org_units
    @widgets = if params[:term] || $params
      $params = params[:term] if params[:term]
      Widget.where('id LIKE :p OR name LIKE :p', p: "%#{$params}%")
    else
      $params = nil
      Widget.all
    end
    @lightings = $lightings

    respond_to do |format|
      format.js
    end
  end

  def sort_by_locations
    @widgets = if params[:term] || $params
      $params = params[:term] if params[:term]
      Widget.where('id LIKE :p OR name LIKE :p', p: "%#{$params}%")
    else
      $params = nil
      Widget.all
    end
    @lightings = $lightings

    respond_to do |format|
      format.js
    end
  end

  def sort_alphabetically
    @widgets = if params[:term] || $params
      $params = params[:term] if params[:term]
      Widget.where('id LIKE :p OR name LIKE :p', p: "%#{$params}%").sort_by{|widget| widget.name}
    else
      $params = nil
      Widget.all.sort_by{|widget| widget.name}
    end
    @lightings = $lightings

    respond_to do |format|
      format.js
    end
  end

  def sort_backwards_alphabetically
    @widgets = if params[:term] || $params
      $params = params[:term] if params[:term]
      Widget.where('id LIKE :p OR name LIKE :p', p: "%#{$params}%").sort_by{|widget| widget.name}.reverse!
    else
      $params = nil
      Widget.all.sort_by{|widget| widget.name}.reverse!
    end
    @lightings = $lightings

    respond_to do |format|
      format.js
    end
  end

  # GET /widgets/1
  # GET /widgets/1.json
  def show
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
    if widget_params.keys[0] == "value"
      if (@widget.use == "lighting")
        if widget_params.values[0] == "1"
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

    respond_to do |format|
      if @errors
        format.json { head :no_content }

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
      params.require(:widget).permit(:name, :active, :use, :value)
    end
end
