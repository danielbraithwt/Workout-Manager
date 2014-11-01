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

		@workout = Workout.find(params[:id])
		@excersises = @workout.excersises.order("position asc")
		
		excersise_frequency = {}
		@excersise_order = []

		index = 0

		while index < @excersises.length

			excersise_frequency[index] = 0 if excersise_frequency[index] == nil
			excersise_frequency[index] += 1
			@excersise_order << index

			if index != 0 && @excersises[index-1].group == @excersises[index].group && excersise_frequency[index-1] != @excersises[index-1].sets
				index -= 1
			else
				index += 1
			end
		end
		
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
