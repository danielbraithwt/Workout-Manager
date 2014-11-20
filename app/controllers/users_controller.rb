class UsersController < ApplicationController

	before_action :confirm_logged_in, :except => [:create]

  	def create
		# Make sure that the email isnt allready signed up
		found_user = User.where(:email => params[:email])
		if found_user != nil
			flash[:notice] = "There is allready an account regestered to that email"
			redirect_to :controller => "access", :action => "login"
			return false
		end
	
		user = User.new

	  	user.first_name = params[:first_name]
	  	user.last_name = params[:last_name]
	  	user.email = params[:email]
		user.password = params[:password]

		if user.save
			flash[:notice] = "User account created"
			redirect_to :controller => 'access', :action => 'login'
		else
			flash[:notice] = "Something went wrong sorry"
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
			flash[:notice] = "User account updated scussfully"
			redirect_to :controller => "home", :action => "index"
		else
			flash[:notice] = "An error occored while updating"
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
