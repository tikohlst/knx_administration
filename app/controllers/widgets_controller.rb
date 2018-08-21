class WidgetsController < ApplicationController
  # CanCan authorizes the resource automatically for every action
  load_and_authorize_resource
  before_action :set_widget, only: [:show, :edit, :update, :destroy]

  # GET /widgets
  # GET /widgets.json
  def index
    access_org_units = []
    current_user.accesses.each do |access|
      access_org_units << access.org_unit_id
    end
    @widgets = if (params[:term] && params[:term] != "") || $widgets_search_params[current_user.username]
      $widgets_search_params[current_user.username] = params[:term] if params[:term]
      Widget.where('(id LIKE :p OR name LIKE :p) AND (org_unit_id REGEXP :q)',
                   p: "%#{$widgets_search_params[current_user.username]}%",
                   q: "#{access_org_units.join '|'}")
    else
      $widgets_search_params[current_user.username] = nil
      Widget.where('org_unit_id REGEXP :q', q: "#{access_org_units.join '|'}")
    end
    @lightings = $lightings
  end

  def sort_by_org_units
    access_org_units = []
    current_user.accesses.each do |access|
      access_org_units << access.org_unit_id
    end
    @widgets = if params[:term] || $widgets_search_params[current_user.username]
      $widgets_search_params[current_user.username] = params[:term] if params[:term]
      Widget.where('(id LIKE :p OR name LIKE :p) AND (org_unit_id REGEXP :q)',
                   p: "%#{$widgets_search_params[current_user.username]}%",
                   q: "#{access_org_units.join '|'}")
    else
      $widgets_search_params[current_user.username] = nil
      Widget.where('org_unit_id REGEXP :q', q: "#{access_org_units.join '|'}")
    end
    @lightings = $lightings
  end

  def sort_by_locations
    access_org_units = []
    current_user.accesses.each do |access|
      access_org_units << access.org_unit_id
    end
    @widgets = if params[:term] || $widgets_search_params[current_user.username]
      $widgets_search_params[current_user.username] = params[:term] if params[:term]
      Widget.where('(id LIKE :p OR name LIKE :p) AND (org_unit_id REGEXP :q)',
                   p: "%#{$widgets_search_params[current_user.username]}%",
                   q: "#{access_org_units.join '|'}")
    else
      $widgets_search_params[current_user.username] = nil
      Widget.where('org_unit_id REGEXP :q', q: "#{access_org_units.join '|'}")
    end
    @lightings = $lightings
  end

  def sort_alphabetically
    access_org_units = []
    current_user.accesses.each do |access|
      access_org_units << access.org_unit_id
    end
    @widgets = if params[:term] || $widgets_search_params[current_user.username]
      $widgets_search_params[current_user.username] = params[:term] if params[:term]
      Widget.where('(id LIKE :p OR name LIKE :p) AND (org_unit_id REGEXP :q)',
                   p: "%#{$widgets_search_params[current_user.username]}%",
                   q: "#{access_org_units.join '|'}").sort_by{|widget| widget.name}
    else
      $widgets_search_params[current_user.username] = nil
      Widget.where('org_unit_id REGEXP :q', q: "#{access_org_units.join '|'}")
          .order(:name)
    end
    @lightings = $lightings
  end

  def sort_backwards_alphabetically
    access_org_units = []
    current_user.accesses.each do |access|
      access_org_units << access.org_unit_id
    end
    @widgets = if params[:term] || $widgets_search_params[current_user.username]
      $widgets_search_params[current_user.username] = params[:term] if params[:term]
      Widget.where('(id LIKE :p OR name LIKE :p) AND (org_unit_id REGEXP :q)',
                   p: "%#{$widgets_search_params[current_user.username]}%",
                   q: "#{access_org_units.join '|'}").sort_by{|widget| widget.name}.reverse!
    else
      $widgets_search_params[current_user.username] = nil
      Widget.where('org_unit_id REGEXP :q', q: "#{access_org_units.join '|'}")
          .order(name: :desc)
    end
    @lightings = $lightings
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
