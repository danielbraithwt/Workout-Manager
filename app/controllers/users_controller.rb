class UsersController < ApplicationController

	before_action :confirm_logged_in, :except => [:create]

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

	def edit
		@user = User.find(session[:user_id])
	end

	def update
		user = User.find(session[:user_id])

		user.email = params[:email] if params[:email].present?
		user.password = params[:password] if params[:password].present?

		if user.save
			flash[:message] = "User account updated scussfully"
			redirect_to :controller => "home", :action => "index"
		else
			flash[:message] = "An error occored while updating"
			redirect_to :action => "index"
		end
	end

	private
	
	def confirm_logged_in
		unless session[:user_id]
			flash[:notice] = "You must be logged in"
			redirect_to(:action => 'login')
			return false
		else
			return true
		end
	end

end
