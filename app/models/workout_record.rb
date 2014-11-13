class WorkoutRecord < ActiveRecord::Base
	belongs_to :workout
	has_many :excersise_records
end
