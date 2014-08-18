class PropertiesController < ApplicationController
  
  before_action :set_property, only: [:show]

  def index
    @properties = Property.search(params[:term], fields: [:address, :full_address])
    render json: @properties, only: [:id, :name, :full_address, :picture], methods: [:picture_thumb]
  end

  def show
  end

  def remove_employee
    @property_employee = @property
  end 

  private

    def set_property
      @property = Property.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, notice: "We couldn't find that page."
    end
end