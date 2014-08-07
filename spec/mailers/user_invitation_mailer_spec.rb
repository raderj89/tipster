require "spec_helper"

describe UserInvitationMailer do
  describe "confirm_invite" do
    let(:invitation) { create(:manager_invitation) }
    let(:mail) { UserInvitationMailer.confirm_invite(invitation) }

    it "renders the headers" do
      expect(mail.subject).to eq("Confirm invite")
      expect(mail.to).to eq([invitation.recipient_email])
      expect(mail.from).to eq(["no-reply@tipster.nycdevshop.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(/^You've been invited to Tipster!/)
    end

    it "includes the correct link" do
      expect(mail.body.encoded).to match(new_property_path(invitation.token))
    end
  end

end
