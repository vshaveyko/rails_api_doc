# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
class Api::DataController < ApplicationController

  before_action :set_datum, only: [:show, :edit, :update, :destroy]

  has_scope :creation_date

  parameter :creation_date, type: :datetime
  parameter :comment, type: :string

  def api_member_route
  end

  def api_collection_route
  end

  # GET /data
  def index
    @data = Datum.all
  end

  # GET /data/1
  def show
  end

  # GET /data/new
  def new
    @datum = Datum.new
  end

  # GET /data/1/edit
  def edit
  end

  # POST /data
  def create
    @datum = Datum.new(datum_params)

    if @datum.save
      redirect_to @datum, notice: 'Datum was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /data/1
  def update
    if @datum.update(datum_params)
      redirect_to @datum, notice: 'Datum was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /data/1
  def destroy
    @datum.destroy
    redirect_to data_url, notice: 'Datum was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_datum
    @datum = Datum.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def datum_params
    params.require(:datum).permit(:creation_date, :comment)
  end

end
