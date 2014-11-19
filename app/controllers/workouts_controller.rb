class WorkoutsController < ApplicationController
	require 'date'

	layout "application", except: :do	
	before_action :confirm_logged_in

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
		render layout: false

	end

	def create_record
		puts "Creating Record"
		workout = Workout.find(params[:id]);

		# Confirm that the user has access to this workout
		allowed = confirm_user_auth(workout)
		redirect_to :controller => "access", :action => "not_authorised" if !allowed

		# Create the record for the workout
		workout_record = WorkoutRecord.new
		workout_record.workout = workout

		workout.excersises.each do |excersise|
			excersise_record = ExcersiseRecord.new

			excersise_record.diffculty = params["#{excersise.id}"]
			excersise_record.sets = excersise.sets
			excersise_record.reps = excersise.reps

			excersise_record.excersise = excersise
			excersise_record.save
			
			workout_record.excersise_records << excersise_record
		end

		workout_record.save
	end

	def track
		workout = Workout.find(params[:id]);
		
		@range = 30
		@max_diffculty = 0;
		
		dates = []
		month_ago = Date.today - @range
		
		i = 0
		while i <= @range
			dates << (month_ago + i)
			i += 1
		end

		puts dates

		# Confirm that the user has access to this workout
		allowed = confirm_user_auth(workout)
		redirect_to :controller => "access", :action => "not_authorised" if !allowed

		# For each of the workkout records we want to record the time stamp and the
		# numbber of repitions and diffculty
		@records = {}

		# We want to have a hash of the diffcultys for each excersise which we can use
		# to calculate varaious stats about excersise progression
		diffcultys = {}

		workout.workout_records.order('created_at DESC').each do |record|
			
			truncated_time = Date.parse(record.created_at.change(:seconds => 0, :minute => 0, :hour => 0).to_s.split(" ")[0])
			puts truncated_time

			position = dates.index truncated_time
			next if position == nil

			record.excersise_records.each do |excersise_record|
				e = []
				e << position + 1
				e << excersise_record.diffculty
				e << (excersise_record.sets * excersise_record.reps)
				
				# If the current diffculty is the biggest then update the max diffculty
				@max_diffculty = excersise_record.diffculty if excersise_record.diffculty > @max_diffculty
				
				# Add the record to the records hash, if nothing has been added for this excersise yet then initilise
				# it to an empty array
				@records[excersise_record.excersise.name] = [] if @records[excersise_record.excersise.name] == nil
				@records[excersise_record.excersise.name] << e

				# Add the diffculty to the diffcultys hash
				diffcultys[excersise_record.excersise.name] = [] if diffcultys[excersise_record.excersise.name] == nil
				diffcultys[excersise_record.excersise.name] << excersise_record.diffculty
			end

		end

		# Using the diffcultys calculate various stastics
		#
		# To Be Calculated :
		#  1) Total change : newest diffculty - oldest diffculty
		
		@total_changes = []

		@records.keys.each do |key|
			# Sort all the array of diffcultys
			d = diffcultys[key].sort
				
			# Add the change to the array
			@total_changes << (d[d.length-1] - d[0])
		end

		puts @total_changes
		
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
