class IndexController < ApplicationController
	
	def index

		# If the user is allready logged in then redirect the to the loged
		# in home page
		if session[:user_id] != nil
			redirect_to(:controller => 'home', :action => 'index')
		end

		# Set all the information for the header
		@header_links = []
		@header_links << ["/login", "Login"]
		@header_links << ["/signup", "Signup"]
		@header_title_name = "WOM"
		@header_title_desc = "Simple, affordable workout logging and tracking for everyone"
	
	end

end
