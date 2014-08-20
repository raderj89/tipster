class InvitationsController < ApplicationController
  respond_to :js

  before_action :set_property
  before_action :set_employee
  before_action :signed_in_employee
  before_action :correct_employee
  before_action :set_invitation, only: [:destroy]

  def new
    @invitations = @employee.sent_invitations.all
    @invitation = @employee.sent_invitations.build
  end

  def create
    @invitation = @employee.sent_invitations.build(invitation_params)

    if @invitation.save
      UserInvitationMailer.property_employee_invite(@property, @invitation).deliver
      flash.now[:success] = "Invite sent successfully!"
    else
      flash.now[:error] = "There was a problem sending your invitation."
    end

    respond_with(@invitation) do |f|
      f.html { redirect_to new_property_employee_invitation_path }
    end
  end

  def destroy
    if @invitation.destroy
      flash.now[:success] = "Invitation successfully removed."
    else
      flash.now[:error] = "There was a problem removing this invitation."
    end

    respond_with(@invitation)
  end

  private

    def set_property
      @property = Property.find(params[:property_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, notice: "We couldn't find that page."
    end

    def set_employee
      @employee = Employee.find(params[:employee_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, notice: "We couldn't find that page."
    end

    def signed_in_employee
      unless employee_signed_in?
        redirect_to root_path, notice: "Please sign in."
      end
    end

    def correct_employee
      @employee = Employee.find(params[:employee_id])
      redirect_to root_path unless current_employee?(@employee)
    end

    def invitation_params
      params.require(:invitation).permit(:recipient_email, :position)
    end

    def set_invitation
      @invitation = Invitation.find(params[:id])
    end

end