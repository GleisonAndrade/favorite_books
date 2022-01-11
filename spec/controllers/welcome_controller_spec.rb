require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  
  describe "GET /" do
    context "no user logged in" do
      it "should return 302 and redirect to /users/sign_in" do
        get :index
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "with user logged in read profile" do
      login_read

      it "should return 200" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end
  end
end
