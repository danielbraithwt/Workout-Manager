class HomeController < ApplicationController
  def index
	  puts "Home Controller : INDEX"

	  @workouts = Workout.all

	  puts "There are #{@workouts.size} workouts"
  end
end
