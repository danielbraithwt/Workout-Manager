class ExcersiseRecord < ActiveRecord::Base
	belongs_to :workout_record
	belongs_to :excersise

	has_many :excersise_sets
end 
