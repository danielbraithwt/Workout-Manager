class ExcersisesController < ApplicationController

	before_action :confirm_logged_in

	layout false

	##
	# Create action creates a new excersise in the database and appends
	# it to the workout specified by the workout id in the paramaters
	# Error Codes: 
	# 	-1 : excersise dident save correctly
	# 	-2 : workout not found ( NOTE: this error shouldent happen) 

  	def create
		# Make sure the passed workout id is valid
		workout = Workout.find_by_id(params[:workoutid])

		# Makesure that the user can access that workout if they dont redirect them to the
		# login page
		allowed = confirm_user_auth_workout(workout)
		redirect_to :controller => 'access', :action => 'not_authorised' if !allowed

		if workout != nil

	  		#TODO: Need to permit mass assignment
			
	  		excersise = Excersise.new
			excersise.name = "Name"
			excersise.excersisetype = 1
			excersise.diffculty = 1.0
			excersise.sets = 1
			excersise.reps = 1
			excersise.group = params[:group]
				
			# If the excersise saves scussfully then print a message and add the
			# new excersise to the workout
	  		if excersise.save
				puts "Excerises Created"
				workout.excersises << excersise
				workout.save
				@id = excersise.id
	  		else
				@id = -1
	  		end
		else
			@id = -2
		end
  	end

  	##
  	# Update action takes all the diffrent sections of an excersise and updates
  	# the excersise stored in the database to these values
  	# 
  	# Error Codes:
 	#  -1 : excersise dident save correctly
 	##
  	def update
		 excersise = Excersise.find(params[:id])

		# Makesure that the user can access that workout if they dont redirect them to the
		# login page
		allowed = confirm_user_auth(excersise)
		redirect_to :controller => 'access', :action => 'not_authorised' if !allowed

	  	#TODO: Allow mass assignment

	  	excersise.group = params[:group]
	  	excersise.name = params[:name]
	  	excersise.diffculty = params[:diffculty]
	  	excersise.excersisetype = params[:type]
	  	excersise.sets = params[:sets]
	  	excersise.reps = params[:reps]

	  	# If the excersise saves then output the id of the excersise
	  	if excersise.save
			@id = excersise.id
	  	else
		 	@id = -1
	  	end
  	end

	##
	# Destroy action takes a given excersise and removes it from the database
	##
	def destroy
		@excersise = Excersise.find(params[:id])

		# Makesure that the user can access that workout if they dont redirect them to the
		# login page
		allowed = confirm_user_auth(@excersise)
		redirect_to :controller => 'access', :action => 'not_authorised' if !allowed

		@excersise.destroy
  	end

	##
	# Update position action just changes the position of a given excersise
	#
	# Error Codes:
	#  -1 : excersise dident save correctly
	##
  	def update_position
		excersise = Excersise.find(params[:id])
		
		# Makesure that the user can access that workout if they dont redirect them to the
		# login page
		allowed = confirm_user_auth(excersise)
		redirect_to :controller => 'access', :action => 'not_authorised' if !allowed


	  	excersise.position = params[:position]

	  	if excersise.save
		  	@id = excersise.id;
	  	else
		  	@id = -1;
	  	end
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

	def confirm_user_auth(excersise)
		if excersise.workout.user.id == session[:user_id]
			return true
		else
			return false
		end
	end

	def confirm_user_auth_workout(workout)
		if workout.user.id == session[:user_id]
			return true
		else
			return false
		end
	end


end
