class WelcomeController < ApplicationController
  # skip_before_action :authenticate_user!, :only => :index
  skip_after_action :verify_authorized, :only => :index
  skip_after_action :verify_policy_scoped, :only => :index

  def index
    redirect_to books_url
  end
end  
