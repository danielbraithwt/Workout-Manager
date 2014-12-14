class IndexController < ApplicationController
	
	layout false

	def index

		# If the user is allready logged in then redirect the to the loged
		# in home page
		if session[:user_id] != nil
			redirect_to(:controller => 'home', :action => 'index')
		end
	
	end

end
