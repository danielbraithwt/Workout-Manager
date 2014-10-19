class ExcersisesController < ApplicationController

  def create
	  	# Make sure the passed workout id is valid
		workout = Workout.find_by_id(params[:workoutid])

		if workout != nil

	  		#TODO: Need to permit mass assignment
			
	  		excersise = Excersise.new
			excersise.name = "Name"
			excersise.excersisetype = 1
			excersise.diffculty = 1.0;

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

	  excersise.name = params[:name]
	  excersise.diffculty = params[:diffculty]
	  excersise.excersisetype = params[:type]

	  if excersise.save
		  @id = excersise.id
	  else
		  @id = -1
	  end
  end

  def destory
  end
end
