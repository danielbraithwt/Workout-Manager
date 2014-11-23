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

	def stastics
		stats = []

		return stats if excersise_records.size == 0

		if excersisetype == 1
			stats << ["Avg Rep Time", avg_rep_completion_time/1000.0, "s"]
			stats << ["Min Rep Time", min_rep_completion_time/1000.0, "s"]
			stats << ["Avg Tonnage", avg_tonnage, "kg"]
			stats << ["Max Tonnage", max_tonnage, "kg"]
		elsif excersisetype == 2

		end

		return stats
	end

	private

	def avg_rep_completion_time
		total_time = 0

		excersise_records.each do |record|
			total_time += record.avg_time_per_rep
		end

		return total_time / excersise_records.size
	end

	def min_rep_completion_time
		return excersise_records.inject(0) { |memo, result| 
			if memo == 0
				result.avg_time_per_rep
			elsif result.avg_time_per_rep < memo
				result.avg_time_per_rep
			else
				memo
			end 
		}
	end

	def avg_tonnage
		total_tonnage = 0

		excersise_records.each do |record|
			total_tonnage += record.tonnage
		end

		return total_tonnage / excersise_records.size
	end

	def max_tonnage
		return excersise_records.inject(0) { |memo, result| 
			if result.tonnage > memo
				result.tonnage
			else
				memo
			end 
		}
	end

end 
