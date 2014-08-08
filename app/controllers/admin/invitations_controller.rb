class Admin::InvitationsController < Admin::BaseController
  respond_to :js

  before_action :require_admin_signin!
  before_action :set_admin

  def new
    @invitations = @admin.invitations.all
    @invitation = @admin.invitations.build
  end

  def create
    @invitation = @admin.invitations.build(invitation_params)
    @invitation.is_admin = true

    if @invitation.save
      UserInvitationMailer.property_admin_invite(@invitation).deliver
      flash.now[:success] = "Invite sent successfully!"
    else
      flash.now[:error] = "There was a problem sending your invitation."
    end

    respond_with(@invitation) do |f|
      f.html { redirect_to new_admin_invitation_path }
    end
  end

  private

    def set_admin
      @admin = current_admin
    end

    def invitation_params
      params.require(:invitation).permit(:recipient_email, :property_name, :property_address,
                                         :property_city, :property_state, :property_zip)
    end

end