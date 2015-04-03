class WelcomeController < ApplicationController
  def index
	@messages = Messages.all
  end
end
