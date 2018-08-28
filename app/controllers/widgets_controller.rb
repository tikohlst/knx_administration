class WidgetsController < ApplicationController
  # CanCan authorizes the resource automatically for every action
  load_and_authorize_resource

  # GET /widgets
  # GET /widgets.json
  def index
    access_org_units = []
    current_user.accesses.each do |access|
      access_org_units << OrgUnit.where(id: access.org_unit_id).pluck(:key).first
    end
    #@widgets = if (params[:term] && params[:term] != "") || $widgets_search_params[current_user.username]
      #$widgets_search_params[current_user.username] = params[:term] if params[:term]
      #Widget.where('(id LIKE :p OR name LIKE :p) AND (org_unit_id REGEXP :q)',
      #             p: "%#{$widgets_search_params[current_user.username]}%",
      #             q: "#{access_org_units.join '|'}")
    #else
      #$widgets_search_params[current_user.username] = nil
      #Widget.where('org_unit_id REGEXP :q', q: "#{access_org_units.join '|'}")
    #end
    @buttons = Widget::Button.find_by_org_units(access_org_units)
    @progress_bars = Widget::ProgressBar.find_by_org_units(access_org_units)
    @sliders = Widget::Slider.find_by_org_units(access_org_units)
    @widgets = {buttons: @buttons, progress_bars: @progress_bars, sliders: @sliders}
    #@widgets = {sliders: @sliders}
  end

  def sort_by_org_units
    access_org_units = []
    current_user.accesses.each do |access|
      access_org_units << OrgUnit.where(id: access.org_unit_id).pluck(:key).first
    end
    @widgets = if params[:term] || $widgets_search_params[current_user.username]
      $widgets_search_params[current_user.username] = params[:term] if params[:term]
      #Widget.where('(id LIKE :p OR name LIKE :p) AND (org_unit_id REGEXP :q)',
      #             p: "%#{$widgets_search_params[current_user.username]}%",
      #             q: "#{access_org_units.join '|'}")
    else
      $widgets_search_params[current_user.username] = nil
      #Widget.where('org_unit_id REGEXP :q', q: "#{access_org_units.join '|'}")
    end
    @buttons = Widget::Button.find_by_org_units(access_org_units)
  end

  def sort_by_locations
    access_org_units = []
    current_user.accesses.each do |access|
      access_org_units << OrgUnit.where(id: access.org_unit_id).pluck(:key).first
    end
    @widgets = if params[:term] || $widgets_search_params[current_user.username]
      $widgets_search_params[current_user.username] = params[:term] if params[:term]
      #Widget.where('(id LIKE :p OR name LIKE :p) AND (org_unit_id REGEXP :q)',
      #             p: "%#{$widgets_search_params[current_user.username]}%",
      #             q: "#{access_org_units.join '|'}")
    else
      $widgets_search_params[current_user.username] = nil
      #Widget.where('org_unit_id REGEXP :q', q: "#{access_org_units.join '|'}")
    end
    @buttons = Widget::Button.find_by_org_units(access_org_units)
  end

  def sort_alphabetically
    access_org_units = []
    current_user.accesses.each do |access|
      access_org_units << OrgUnit.where(id: access.org_unit_id).pluck(:key).first
    end
    @widgets = if params[:term] || $widgets_search_params[current_user.username]
      $widgets_search_params[current_user.username] = params[:term] if params[:term]
      #Widget.where('(id LIKE :p OR name LIKE :p) AND (org_unit_id REGEXP :q)',
      #             p: "%#{$widgets_search_params[current_user.username]}%",
      #             q: "#{access_org_units.join '|'}").sort_by{|widget| widget.name}
    else
      $widgets_search_params[current_user.username] = nil
      #Widget.where('org_unit_id REGEXP :q', q: "#{access_org_units.join '|'}")
      #    .order(:name)
    end
    @buttons = Widget::Button.find_by_org_units(access_org_units)
  end

  def sort_backwards_alphabetically
    access_org_units = []
    current_user.accesses.each do |access|
      access_org_units << OrgUnit.where(id: access.org_unit_id).pluck(:key).first
    end
    @widgets = if params[:term] || $widgets_search_params[current_user.username]
      $widgets_search_params[current_user.username] = params[:term] if params[:term]
      #Widget.where('(id LIKE :p OR name LIKE :p) AND (org_unit_id REGEXP :q)',
      #             p: "%#{$widgets_search_params[current_user.username]}%",
      #             q: "#{access_org_units.join '|'}").sort_by{|widget| widget.name}.reverse!
    else
      $widgets_search_params[current_user.username] = nil
      #Widget.where('org_unit_id REGEXP :q', q: "#{access_org_units.join '|'}")
      #    .order(name: :desc)
    end
    @buttons = Widget::Button.find_by_org_units(access_org_units)
  end

  # PATCH/PUT /widgets/1
  # PATCH/PUT /widgets/1.json
  def update
    # Get widget with id and send the params to the device
    @widget = Widget.find_by_id(params[:id])

    case @widget
    when Widget::Button
      @widget.send_param
    when Widget::ProgressBar
      @widget.send_param(params[:progress_bar])
    when Widget::Slider
      @widget.send_param(params[:status])
    else
      puts "No valid widget!"
    end

    respond_to do |format|
      format.json { head :no_content }
    end

    # if widget_params.keys[0] == "value"
    #   if (@widget.use == "lighting")
    #     if widget_params.values[0] == "1"
    #       @errors = @widget.update_attribute(:value, 1)
    #     else
    #       @errors = @widget.update_attribute(:value, 0)
    #     end
    #   else
    #     @errors = @widget.update_attribute(:value, widget_params.values[0])
    #   end
    # else
    #   @errors = @widget.update(widget_params)
    # end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def widget_params
      params.require(:widget).permit(:name, :active, :use, :value)
    end
end
