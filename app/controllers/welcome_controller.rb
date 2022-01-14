class WelcomeController < ApplicationController
  # skip_before_action :authenticate_user!, :only => :index

  def index
    redirect_to books_url
  end
end  
