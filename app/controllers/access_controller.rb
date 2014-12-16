class AccessController < ApplicationController
	
	before_action :confirm_logged_in, :except => [:login, :attempt_login, :logout]


  	def index
  	end

  	def login
		# Redirect to home page if user is allready logged in
		if session[:user_id] != nil
			redirect_to(:controller => 'home', :action => 'index')
		end

		@header_title_name = "Login"
		@header_title_desc = "Enter your login details"
		@header_links = []
		@header_links << ["/", "Home"]
  	end

  	def attempt_login
		# Redirect to home page if user is allready logged in
		if session[:user_id] != nil
			redirect_to(:controller => 'home', :action => 'index')
		end

		if params[:email].present? && params[:password].present?
			found_user = User.where(:email => params[:email]).first

			if found_user
				user = found_user.authenticate(params[:password])
			end
		end

		if user
			session[:user_id] = user.id
			session[:name] = user.first_name + " " + user.last_name

			redirect_to(:controller => 'home', :action => 'index')
		else
			flash[:notice] = "Invalid username/password combination."
			redirect_to(:action => 'login')
		end
  	end

  	def logout
		session[:user_id] = nil
		session[:username] = nil

		flash[:notice] = "Logged Out"
		redirect_to(:action => 'login')
  	end

	def not_authorised
		
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
