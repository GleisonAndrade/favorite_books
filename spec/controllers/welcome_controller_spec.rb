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

    context "with user logged in reader profile" do
      login_reader

      it "should return 302 to /books" do
        get :index
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(books_path)
        # expect(response).to have_http_status(:success)
      end
    end

    context "with user logged in librarian profile" do
      login_librarian

      it "should return 302 to /books" do
        get :index
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(books_path)
        # expect(response).to have_http_status(:success)
      end
    end

    context "with user logged in admin profile" do
      login_admin

      it "should return 302 to /books" do
        get :index
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(books_path)
        # expect(response).to have_http_status(:success)
      end
    end
  end
end
