class ExcersiseSet < ActiveRecord::Base
	belongs_to :excersise_record

	def tonnage
		return reps * diffculty
	end
end
 
 
