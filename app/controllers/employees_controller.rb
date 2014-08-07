class EmployeesController < ApplicationController

  before_action :set_employee

  def new
  end

  def setup_payment
  end

  private

    def set_employee
      @employee = current_employee
    end 
end