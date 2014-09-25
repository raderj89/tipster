class PropertiesController < ApplicationController
  def index
    @properties = Property.search(params[:term], fields: [:address, :full_address])
    render json: @properties, only: [:id, :name, :full_address, :picture], methods: [:picture_thumb]
  end
end