class ExcersisesController < ApplicationController
	
	layout false

  def create
	  	# Make sure the passed workout id is valid
		workout = Workout.find_by_id(params[:workoutid])

		if workout != nil

	  		#TODO: Need to permit mass assignment
			
	  		excersise = Excersise.new
			excersise.name = "Name"
			excersise.excersisetype = 1
			excersise.diffculty = 1.0
			excersise.sets = 0
			excersise.reps = 0
			excersise.group = params[:group]

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

  def update
	  excersise = Excersise.find(params[:id])

	  #TODO: Allow mass assignment

	  excersise.group = params[:group]
	  excersise.name = params[:name]
	  excersise.diffculty = params[:diffculty]
	  excersise.excersisetype = params[:type]
	  excersise.sets = params[:sets]
	  excersise.reps = params[:reps]

	  if excersise.save
		  @id = excersise.id
	  else
		  @id = -1
	  end
  end

  def destory
  end

  def update_position
	  excersise = Excersise.find(params[:id])

	  excersise.position = params[:position]

	  excersise.save
  end
end
