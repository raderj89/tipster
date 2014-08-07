require 'spec_helper'

describe Admin::SessionsController do
  let(:admin) { create(:admin) }

  describe 'GET #new' do
    it "renders the login page" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context "with valid credentials" do 
      before(:each) { post :create, session: { email: admin.email, password: admin.password } }
      
      it "sets the admin ID in the session" do
        expect(session[:admin_id]).to eq admin.id
      end

      it "redirects to admin index upon successful login" do 
        expect(response).to redirect_to '/admin'
      end

      it "notifies the user of successful login" do
        expect(flash[:success]).to match(/^You have logged in successfully./)
      end
    end

    context "with invalid credentials" do
      before(:each) { post :create, session: { email: '', password: '' } }
      
        it "renders the login page" do
          expect(response).to render_template(:new)
        end

        it "flashes a notification of invalid login" do
          expect(flash[:notice]).to match(/^Incorrect email or password./)
        end
    end
  end

  describe 'DELETE #destroy' do
    before(:each) { delete :destroy }

    it "logs out the user, destroying admin ID in the session" do
      expect(session[:admin]).to be_nil
    end

    it "notifies the user they have logged out" do
      expect(flash[:notice]).to match(/^You have logged out successfully./)
    end
  end
end