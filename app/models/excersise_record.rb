class ExcersiseRecord < ActiveRecord::Base
	belongs_to :workout_record
	belongs_to :excersise
end 
