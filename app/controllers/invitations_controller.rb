class InvitationsController < ApplicationController
  respond_to :js

  before_action :set_employee

  def new
    @invitations = @employee.sent_invitations.all
    @invitation = @employee.sent_invitations.build
  end

  def create
    @invitation = @employee.sent_invitations.build(invitation_params)

    if @invitation.save
      flash.now[:success] = "Invite sent successfully!"
    else
      flash.now[:error] = "There was a problem sending your invitation."
    end

    respond_with(@invitation) do |f|
      f.html { redirect_to new_employee_invitation_path }
    end
  end

  private

    def set_employee
      @employee = current_employee
    end

    def invitation_params
      params.require(:invitation).permit(:recipient_email, :position)
    end

end