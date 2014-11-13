class Excersise < ActiveRecord::Base

	belongs_to :workout
	has_many :excersise_records

	def get_units
		if excersisetype == 1
			return "kg"
		elsif excersisetype == 2
			return "sec"
		else
			return ""
		end
	end

end 
