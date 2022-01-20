module ControllerMacros
  def login_admin
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @current_user = FactoryBot.create(:admin)
      # @current_user.confirm!
      sign_in @current_user
    end
  end

  def login_librarian
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @current_user = FactoryBot.create(:librarian)
      # @current_user.confirm!
      sign_in @current_user
    end
  end

  def login_reader
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @current_user = FactoryBot.create(:reader)
      # @current_user.confirm!
      sign_in @current_user
    end
  end
end
