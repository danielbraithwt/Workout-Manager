class HomeController < ApplicationController

	##
	# Index action justs loads all the workouts asociated with a given user
	# so they can be displayed by the view
	##
  	def index
	  	puts "Home Controller : INDEX"

	  	@workouts = Workout.all

	  	puts "There are #{@workouts.size} workouts"
  	end
end
