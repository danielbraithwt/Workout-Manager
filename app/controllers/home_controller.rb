class HomeController < ApplicationController
	
	before_action :confirm_logged_in, :except => [:signup]

	##
	# Index action justs loads all the workouts asociated with a given user
	# so they can be displayed by the view
	##
  	def index
	  	puts "Home Controller : INDEX"

		@workouts = User.find(session[:user_id]).workouts

		@header_title_name = "Workouts"
		@header_title_desc = "Manage your various workouts from this screen"

	  	puts "There are #{@workouts.size} workouts"
  	end

	def signup
		puts "Home Controller : SIGNUP"

		@header_title_name = "Signup"
		@header_title_desc = "Enter your details to create an account"
		@header_links = []
		@header_links << ["/", "Home"]
	end

	private

	def confirm_logged_in
		unless session[:user_id]
			flash[:notice] = "You must be logged in"
			redirect_to(:controller => 'access', :action => 'login')
			return false
		else
			return true
		end
	end

end
