class HomeController < ApplicationController
	
	before_action :confirm_logged_in, :except => [:signup]
	layout false

	##
	# Index action justs loads all the workouts asociated with a given user
	# so they can be displayed by the view
	##
  	def index
	  	puts "Home Controller : INDEX"

		@workouts = User.find(session[:user_id]).workouts

		@header_title_name = "Workouts"

	  	puts "There are #{@workouts.size} workouts"

		render(:layout => "application")
  	end

	def siginup
		puts "Home Controller : SIGNUP"
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
