class WidgetsController < ApplicationController
  # CanCan authorizes the resource automatically for every action
  load_and_authorize_resource

  # GET /widgets
  # GET /widgets.json
  def index
    # Save the org units where the user has access to
    access_org_units = []
    current_user.accesses.each do |access|
      access_org_units << OrgUnit.where(id: access.org_unit_id).pluck(:key).first
    end
    # Get all widgets by the org units that the user has access to
    buttons       = Widget::Button.find_by_org_units(access_org_units)
    progress_bars = Widget::ProgressBar.find_by_org_units(access_org_units)
    sliders       = Widget::Slider.find_by_org_units(access_org_units)
    text_fields   = Widget::TextField.find_by_org_units(access_org_units)

    if params[:term].present? or cookies[:search_widgets].present?
      cookies[:search_widgets] = params[:term] if params[:term]
      selected_buttons        = buttons.select{|widget| widget.desc.include? cookies[:search_widgets] }
      selected_progress_bars  = progress_bars.select{|widget| widget.desc.include? cookies[:search_widgets] }
      selected_sliders        = sliders.select{|widget| widget.desc.include? cookies[:search_widgets] }
      selected_text_fields    = text_fields.select{|widget| widget.desc.include? cookies[:search_widgets] }
      case params[:sort_by]
      when 'alphabetically'
        @widgets = {buttons:        selected_buttons.sort_by{|button| button.desc},
                    progress_bars:  selected_progress_bars.sort_by{|progress_bar| progress_bar.desc},
                    sliders:        selected_sliders.sort_by{|slider| slider.desc},
                    text_fields:    selected_text_fields.sort_by{|text_field| text_field.desc}}
      when 'backwards_alphabetically'
        @widgets = {buttons:        selected_buttons.sort_by{|button| button.desc}.reverse!,
                    progress_bars:  selected_progress_bars.sort_by{|progress_bar| progress_bar.desc}.reverse!,
                    sliders:        selected_sliders.sort_by{|slider| slider.desc}.reverse!,
                    text_fields:    selected_text_fields.sort_by{|text_field| text_field.desc}.reverse!}
      else
        @widgets = {buttons:        selected_buttons,
                    progress_bars:  selected_progress_bars,
                    sliders:        selected_sliders,
                    text_fields:    selected_text_fields.sort_by{|text_field| text_field.desc}}
      end
    else
      case params[:sort_by]
      when 'alphabetically'
        @widgets = {buttons:        buttons.sort_by{|button| button.desc},
                    progress_bars:  progress_bars.sort_by{|progress_bar| progress_bar.desc},
                    sliders:        sliders.sort_by{|slider| slider.desc},
                    text_fields:    text_fields.sort_by{|text_field| text_field.desc}}
      when 'backwards_alphabetically'
        @widgets = {buttons:        buttons.sort_by{|button| button.desc}.reverse!,
                    progress_bars:  progress_bars.sort_by{|progress_bar| progress_bar.desc}.reverse!,
                    sliders:        sliders.sort_by{|slider| slider.desc}.reverse!,
                    text_fields:    text_fields.sort_by{|text_field| text_field.desc}.reverse!}
      else
        @widgets = {buttons:        buttons,
                    progress_bars:  progress_bars,
                    sliders:        sliders,
                    text_fields:    text_fields.sort_by{|text_field| text_field.desc}}
      end
    end

    respond_to do |format|
      case params[:sort_by]
      when 'org_units'
        format.js { render "index", locals: {partial: "sort_by_org_units"} }
      when 'locations'
        format.js { render "index", locals: {partial: "sort_by_locations"} }
      when 'alphabetically', 'backwards_alphabetically'
        format.js { render "index", locals: {partial: "sort_alphabetically"} }
      else
        format.js { render "index", locals: {partial: "sort_by_locations"} }
        format.html
      end
    end
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
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def widget_params
      params.require(:widget).permit(:name, :active, :use, :value)
    end
end
