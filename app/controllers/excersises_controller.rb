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

		# Even though the JS function wont send a request if all the fields
		# arnt present, it dosnt stop people from sending requests form another means
		# so it pays to check anyway
		
		if !params[:group].present?  || !params[:name].present? || !params[:type].present?  || !params[:diffculty].present? || !params[:sets].present? || !params[:reps].present?
			@m = "nc"
			puts "Not Complete"
			return false
		end

		# Make sure that all the paramaters are valid, if one isnt then return the respective error code
		# and quit the action

		if is_numeric?(params[:group]) && params[:group].to_i > 0
			excersise.group = params[:group]
		else
			@m = "group"
			return false
		end
		
		if params[:name].length < 30 && params[:name].length >= 4
	  		excersise.name = params[:name]
		else
			@m = "name"
			return false
		end

		if is_numeric?(params[:type]) && ( params[:type].to_i == 1 || params[:type].to_i == 2 || params[:type].to_i == 3 )#[1,2,3].includes?(params[:type].to_i)
			excersise.excersisetype = params[:type]
		else
			@m = "type"
			return false
		end
		
		if is_numeric?(params[:diffculty]) && params[:diffculty].to_f > 0
	  		excersise.diffculty = params[:diffculty]
		elsif params[:type].to_i == 3
			excersise.diffculty = 0
		else
			@m = "diffculty"
			return false
		end

		if is_numeric?(params[:sets]) && params[:sets].to_i > 0
			excersise.sets = params[:sets]
		else
			@m = "sets"
			return false
		end

		if is_numeric?(params[:reps]) && params[:reps].to_i > 0
	  		excersise.reps = params[:reps]
		else
			@m = "reps"
			return false
		end

	  	# If the excersise saves then output the id of the excersise
	  	if excersise.save
			@m = excersise.id
	  	else
		 	@m = -1
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

	def track
		@excersise = Excersise.find(params[:id])

		# Makesure that the user can access that workout if they dont redirect them to the
		# login page
		allowed = confirm_user_auth(@excersise)
		redirect_to :controller => 'access', :action => 'not_authorised' if !allowed
		
		@range = 30#30.days.ago.beginning_of_day.to_datetime..Date.today.end_of_day.to_datetime
		@data = @excersise.graphable_data(@range)
	end

	private

	def is_numeric?(str)
		str.to_i.to_s == str || str.to_f.to_s == str
	end

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
