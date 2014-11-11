class WorkoutsController < ApplicationController
	
	before_action :confirm_logged_in
		
	layout false

	def show
		@workout = Workout.find(params[:id])

		# Makesure that the user can access that workout if they dont redirect them to the
		# login page
		allowed = confirm_user_auth(@workout)
		redirect_to :controller => 'access', :action => 'not_authorised' if !allowed

		@excersises = @workout.excersises
	end

  	def new
		
  	end
	
	##
	# Create action creates a new workout object and will then redirect you to the page
	# to edit it, if it cant create the new workout it will just redirect to the home page
	#
	# TODO: Should make home page display message if it fails
	##
 	def create
		puts "Creating workout with '#{params[:workout]}'"
		
		# Create new workout with specified name and then assign the new
		# workout to the current user
		w = Workout.new(:name => params[:workout][:name])
		w.user = User.find(session[:user_id])
		w.save

		if w.save
			redirect_to :action => "edit", :id => w.id
		else
			puts "Error while saving workout"
			redirect_to :controller => "home", :action => "index"
		end
  	end
	
	##
	# Edit action loads the workout and loads the excersises in ascending order
	# by there position
	##
	def edit
		puts "Editing Workout : #{params[:id]}"

		@workout = Workout.find(params[:id])

		# Makesure that the user can access that workout if they dont redirect them to the
		# login page
		allowed = confirm_user_auth(@workout)
		redirect_to :controller => 'access', :action => 'not_authorised' if !allowed


		@excersises = @workout.excersises.order("position asc")
	end
	
	##
	# Delete action loads the workout that the user said they wanted
	# to delete
	##
	def delete
		@workout = Workout.find(params[:id])

		# Makesure that the user can access that workout if they dont redirect them to the
		# login page
		allowed = confirm_user_auth(@workout)
		redirect_to :controller => 'access', :action => 'not_authorised' if !allowed

	end
	
	##
	# Destroy action removes a workout from the database and all its
	# related excersises
	##
	def destroy
		@workout = Workout.find(params[:id])

		# Makesure that the user can access that workout if they dont redirect them to the
		# login page
		allowed = confirm_user_auth(@workout)
		redirect_to :controller => 'access', :action => 'not_authorised' if !allowed
		
		@workout.excersises.each do |excersise|
			excersise.destroy
		end

		@workout.destroy

		redirect_to :controller => "home", :action => "index"
	end
	
	##
	# Update Name action takes a workout id and new name for that workout and updates
	# that workout in the databse
	#
	# Error Codes:
	#  -1 : if the workout dident save scussfully
	##
	def update_name
		puts "Updating Workout Name: => #{params[:id]}"

		@workout = Workout.find(params[:id])

		# Makesure that the user can access that workout if they dont redirect them to the
		# login page
		allowed = confirm_user_auth(@workout)
		redirect_to :controller => 'access', :action => 'not_authorised' if !allowed

		@workout.name = params[:name]

		puts params[:name]

		@id = @workout.id

		@id = -1 if !@workout.save
	end
	
	##
	# Do action retreves the specified workout and related excersises so that
	# it can be processed to get the order in which the excersises are to be done
	##
	def do
		puts "Doing Workout : #{params[:id]}"

		@encouragements = ["Lets Do It", "Go For It!"]

		@workout = Workout.find(params[:id])

		# Makesure that the user can access that workout if they dont redirect them to the
		# login page
		allowed = confirm_user_auth(@workout)
		redirect_to :controller => 'access', :action => 'not_authorised' if !allowed

		@excersises = @workout.excersises.order("position asc")
		
		@groups = {}
		excersise_frequency = {}
		@excersise_order = []

		# Sort the excersises into there groups
		@excersises.each do |excersise|
			@groups[excersise.group] = [] if @groups[excersise.group] == nil

			@groups[excersise.group] << excersise
		end

		# Itterate through the groups and 
		@groups.keys.sort.each do |group|
			excersise_group = @groups[group]
			group_finished = false
			
			# Untill all the excersises have been added the ammout they should
			# IE if you are doing 3 sets of something it should be added three times
			while !group_finished
				group_finished = true
				
				# for the current excersise group go through the excersises and add them
				# if they still need to be added
				excersise_group.each do |excersise|
					excersise_frequency[excersise.id] = 0 if excersise_frequency[excersise.id] == nil
					
					if excersise_frequency[excersise.id] < excersise.sets
						@excersise_order << excersise.position
						excersise_frequency[excersise.id] += 1

						group_finished = false
					end
				end
			end
		end

		# Get groups into an array
		@excersise_group_order = []

		@excersises.each do |excersise|
			@excersise_group_order << excersise.group
		end

		# Get the largest group
		@largest_group = @excersises.inject(0) { |memo, item| if item.group != nil && item.group > memo then item.group; else memo; end }

		## just for testing
		############################
		puts "\nWorkout Schedule: "

		@excersise_order.each do |i|
			puts "Excersise: #{@excersises[i].name}"
		end
		puts "\n"
		###########################
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

	def confirm_user_auth(workout)
		if workout.user.id == session[:user_id]
			return true
		else
			return false
		end
	end

end
