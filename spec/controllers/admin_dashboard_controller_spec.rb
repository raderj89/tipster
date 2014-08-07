require 'spec_helper'

describe Admin::DashboardController do
  let(:admin) { create(:admin) }

  describe 'GET #index' do
    context "not signed in" do
      it "should redirect to the admin log in page" do
        get :index 
        expect(response).to redirect_to('/admin/log_in')
      end

      it "renders the page with a flash message" do
        get :index 
        expect(flash[:notice]).to match(/^Please sign in./)
      end
    end

    context "signed in" do
      before { admin_log_in(admin) }

      it "should render the dashboard index" do
        get :index
        expect(response).to render_template(:index)
      end
    end
  end
end