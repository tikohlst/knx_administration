class KnxModulesController < ApplicationController
  # CanCan authorizes the resource automatically for every action
  load_and_authorize_resource
  before_action :set_knx_module, only: [:show, :edit, :update, :destroy]

  # GET /knx_modules
  # GET /knx_modules.json
  def index
    @knx_modules = KnxModule.all
  end

  # GET /knx_modules/1
  # GET /knx_modules/1.json
  def show
  end

  # GET /knx_modules/new
  def new
    @knx_module = KnxModule.new
  end

  # GET /knx_modules/1/edit
  def edit
  end

  # POST /knx_modules
  # POST /knx_modules.json
  def create
    @knx_module = KnxModule.new(knx_module_params)

    respond_to do |format|
      if @knx_module.save
        format.html { redirect_to @knx_module, notice: 'Knx module was successfully created.' }
        format.json { render :show, status: :created, location: @knx_module }
      else
        format.html { render :new }
        format.json { render json: @knx_module.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /knx_modules/1
  # PATCH/PUT /knx_modules/1.json
  def update
    respond_to do |format|
      if @knx_module.update(knx_module_params)
        format.html { redirect_to @knx_module, notice: 'Knx module was successfully updated.' }
        format.json { render :show, status: :ok, location: @knx_module }
      else
        format.html { render :edit }
        format.json { render json: @knx_module.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /knx_modules/1
  # DELETE /knx_modules/1.json
  def destroy
    @knx_module.destroy
    respond_to do |format|
      format.html { redirect_to knx_modules_url, notice: 'Knx module was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_knx_module
      @knx_module = KnxModule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def knx_module_params
      params.require(:knx_module).permit(:name)
    end
end
