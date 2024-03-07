class DissertationsController < ApplicationController
  before_action :set_dissertation, only: %i[ show edit update destroy ]

  # GET /dissertations or /dissertations.json
  def index
    @dissertations = Dissertation.order(year: :desc).page(params[:page]).per(30)
  end

  # GET /dissertations/1 or /dissertations/1.json
  def show
  end

  # GET /dissertations/new
  def new
    @dissertation = Dissertation.new
  end

  # GET /dissertations/1/edit
  def edit
  end

  # POST /dissertations or /dissertations.json
  def create
    @dissertation = Dissertation.new(dissertation_params)

    respond_to do |format|
      if @dissertation.save
        format.html { redirect_to dissertation_url(@dissertation), notice: "Dissertation was successfully created." }
        format.json { render :show, status: :created, location: @dissertation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @dissertation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dissertations/1 or /dissertations/1.json
  def update
    respond_to do |format|
      if @dissertation.update(dissertation_params)
        format.html { redirect_to dissertation_url(@dissertation), notice: "Dissertation was successfully updated." }
        format.json { render :show, status: :ok, location: @dissertation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @dissertation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dissertations/1 or /dissertations/1.json
  def destroy
    @dissertation.destroy

    respond_to do |format|
      format.html { redirect_to dissertations_url, notice: "Dissertation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dissertation
      @dissertation = Dissertation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def dissertation_params
      params.require(:dissertation).permit(:name, :title, :date, :link, :evaluations, :kind, :year)
    end
end
