class Excersise < ActiveRecord::Base

	belongs_to :workout

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
