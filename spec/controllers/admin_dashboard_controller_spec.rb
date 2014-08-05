require 'spec_helper'

describe Admin::DashboardController do
  let(:admin) { create(:admin) }

  describe 'GET #index' do
    context "not signed in" do
      before { get :index }

      it "should redirect to the admin log in page" do
        expect(response).to redirect_to('/admin/log_in')
      end

      it "renders the page with a flash message" do
        expect(flash[:notice]).to match(/^Please sign in./)
      end
    end

    context "signed in" do
      before do
        admin_log_in(admin)
        get :index
      end

      it "should render the dashboard index" do
        expect(response).to render_template(:index)
      end
    end
  end
end