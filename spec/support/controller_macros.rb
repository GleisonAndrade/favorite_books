module ControllerMacros
    def login_admin
      before(:each) do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        user = FactoryBot.create(:admin)
        # user.confirm!
        sign_in user
      end
    end

    def login_librarian
      before(:each) do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        user = FactoryBot.create(:librarian)
        # user.confirm!
        sign_in user
      end
    end

    def login_reader
      before(:each) do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        user = FactoryBot.create(:reader)
        # user.confirm!
        sign_in user
      end
    end
end