class AdministratesController < ApplicationController
  before_action :set_administrate, only: [:show, :edit, :update, :destroy]

  # GET /administrates
  # GET /administrates.json
  def index
    @administrates = Administrate.all
  end

  # GET /administrates/1
  # GET /administrates/1.json
  def show
  end

  # GET /administrates/new
  def new
    @administrate = Administrate.new
  end

  # GET /administrates/1/edit
  def edit
  end

  # POST /administrates
  # POST /administrates.json
  def create
    @administrate = Administrate.new(administrate_params)

    respond_to do |format|
      if @administrate.save
        format.html { redirect_to @administrate, notice: 'Administrate was successfully created.' }
        format.json { render :show, status: :created, location: @administrate }
      else
        format.html { render :new }
        format.json { render json: @administrate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /administrates/1
  # PATCH/PUT /administrates/1.json
  def update
    respond_to do |format|
      if @administrate.update(administrate_params)
        format.html { redirect_to @administrate, notice: 'Administrate was successfully updated.' }
        format.json { render :show, status: :ok, location: @administrate }
      else
        format.html { render :edit }
        format.json { render json: @administrate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /administrates/1
  # DELETE /administrates/1.json
  def destroy
    @administrate.destroy
    respond_to do |format|
      format.html { redirect_to administrates_url, notice: 'Administrate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_administrate
      @administrate = Administrate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def administrate_params
      params.require(:administrate).permit(:user_id, :room_id)
    end
end
