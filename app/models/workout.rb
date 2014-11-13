class Workout < ActiveRecord::Base

	belongs_to :user
	has_many :excersises
	has_many :workout_records

end
