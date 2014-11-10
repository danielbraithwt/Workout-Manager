class UsersController < ApplicationController
  	def create
		user = User.new
	
		# TODO: Make sure that a user by that email isnt allready signed up

	  	user.first_name = params[:first_name]
	  	user.last_name = params[:last_name]
	  	user.email = params[:email]
		user.password = params[:password]

		if user.save
			flash[:message] = "User account created"
			redirect_to :controller => 'access', :action => 'login'
		else
			flash[:message] = "Something went wrong sorry"
			redirect_to :controller => 'home', :action =>'signup'
		end
  	end
end
