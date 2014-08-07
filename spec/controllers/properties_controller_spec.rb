require 'spec_helper'

describe PropertiesController do
  let(:manager_invitation) { create(:manager_invitation) }
  let(:building_manager) { create(:building_manager) }

  describe 'GET #new' do
    context 'with invalid invitation token' do
      it "redirects to root path" do
        get :new, invitation_token: 'asdfsae'

        expect(response).to redirect_to(root_path)
      end

      it "flashes the correct notice" do
        get :new, invitation_token: 'asdfsae'

        expect(flash[:notice]).to match(/^You need to be invited to sign up./)
      end
    end

    context 'with invitation token' do
      it "renders the page" do
        get :new, invitation_token: manager_invitation.token

        expect(response).to render_template(:new)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid form information' do

      it "creates the property" do
        expect {
          post :create, property: attributes_for(:property) 
        }.to change(Property, :count).by(1) 
      end

      # it "creates the employee" do
      #   expect {
      #     post :create, { property: attributes_for(:property), property_employee: attributes_for(:property_employee_admin),
      #                     employee: attributes_for(:building_manager) }
      #   }.to change(PropertyEmployee, :count).by(1) 
      # end

      # it "creates the property_employee record" do

      # end

      # it "creates the title record" do

      # end

      # it "sets the employee ID in the session"

      # end
    end
  end

end