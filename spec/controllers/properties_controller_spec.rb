require 'spec_helper'

describe PropertiesController do
  let(:manager_invitation) { create(:manager_invitation) }

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
          post :create, property: property_params_hash
        }.to change(Property, :count).by(1) 
      end

      it "creates the employee" do
        expect {
          post :create, property: property_params_hash
        }.to change(Employee, :count).by(1) 
      end

      it "creates the property_employee record" do
        expect {
          post :create, property: property_params_hash
        }.to change(PropertyEmployee, :count).by(1) 
      end

      it "creates the title record" do
        expect {
          post :create, property: property_params_hash
        }.to change(Title, :count).by(1) 
      end

      it "sets the employee ID in the session" do
        post :create, property: property_params_hash
        expect(session[:employee_id]).to eq Employee.last.id
      end

      it "responds with a success flash message" do
        post :create, property: property_params_hash
        expect(flash[:success]).to match(/^Your account was successfully created!/)
      end

      it "redirects to the employee invitations page" do
        post :create, property: property_params_hash
        expect(response).to redirect_to new_property_employee_invitation_path(Property.last, Employee.last)
      end
    end

    context 'with invalid form information' do

      it "does not create a property record" do
        expect {
          post :create, property: invalid_property_params_hash
        }.to_not change(Property, :count).by(1) 
      end

      it "does not create an employee record" do
        expect {
          post :create, property: invalid_property_params_hash
        }.to_not change(Employee, :count).by(1) 
      end

      it "does not create a property employee record" do
        expect {
          post :create, property: invalid_property_params_hash
        }.to_not change(PropertyEmployee, :count).by(1) 
      end

      it "does not create a title record" do
        expect {
          post :create, property: invalid_property_params_hash
        }.to_not change(Title, :count).by(1) 
      end

      it "does not set the employee ID in the session" do
        post :create, property: invalid_property_params_hash
        expect(session[:employee_id]).to be_nil
      end

      it "responds with an error flash message" do
        post :create, property: invalid_property_params_hash
        expect(flash[:error]).to match(/^There was a problem creating your account./)
      end

      it "renders the new property page" do
        post :create, property: invalid_property_params_hash
        expect(response).to render_template(:new)
      end
    end
  end

end