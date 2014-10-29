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
end
