class WorkoutsController < ApplicationController
	
	layout false

	def show
		@workout = Workout.find(params[:id])
		@excersises = @workout.excersises

	end

  	def new
		
  	end

 	def create
		puts "Creating workout with '#{params[:workout]}'"

		# TODO: Make so can do mass assignment
		w = Workout.new(:name => params[:workout][:name])
		w.save

		if w.save
			redirect_to :action => "edit", :id => w.id
		else
			puts "Error while saving workout"
			redirect_to :controller => "home", :action => "index"
		end
  	end

	def edit
		puts "Editing Workout : #{params[:id]}"

		@workout = Workout.find(params[:id])
		@excersises = @workout.excersises.order("position asc")

	end

	def do
		puts "Doing Workout : #{params[:id]}"

		@encouragements = ["Lets Do It", "Go For It!"]

		@workout = Workout.find(params[:id])
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
			while !group_finished
				group_finished = true

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

		#index = 0

		#while index < @excersises.length

			#excersise_frequency[index] = 0 if excersise_frequency[index] == nil
			#excersise_frequency[index] += 1
			#@excersise_order << index

			#if index != 0 && @excersises[index-1].group == @excersises[index].group && excersise_frequency[index-1] != @excersises[index-1].sets
			#	index -= 1
			#elsif index < @excersises.length-1 && @excersises[index+1].group != @excersises[index].group

			#else
			#	index += 1
			#end
		#end
		
		## just for testing
		############################
		puts "\nWorkout Schedule: "

		@excersise_order.each do |i|
			puts "Excersise: #{@excersises[i].name}"
		end
		puts "\n"
		###########################
	end
end
