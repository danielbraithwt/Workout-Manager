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
			stats << ["Best Rep Time", min_rep_completion_time/1000.0, "s"]
			stats << ["Avg Tonnage", avg_tonnage, "kg"]
			stats << ["Max Tonnage", max_tonnage, "kg"]
		elsif excersisetype == 2
			stats << ["Average Diffculty", avg_diffculty, "s"]
			stats << ["Max Diffculty", max_diffculty, "s"]
		elsif excersisetype == 3
			stats << ["Avg Rep Time", avg_rep_completion_time/1000.0, "s"]
			stats << ["Best Rep Time", min_rep_completion_time/1000.0, "s"]
			stats << ["Average Repetitions", avg_repetitions, "reps"]
			stats << ["Max Repetitions", max_repetitions, "reps"]
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

	def avg_repetitions
		total_repetitions = 0

		excersise_records.each do |record|
			total_repetitions += record.total_repetitions
		end

		return total_repetitions / excersise_records.size
	end
 
	def max_repetitions
		return excersise_records.inject(0) { |memo, result|
			if result.total_repetitions > memo
				result.total_repetitions
			else
				memo
			end
		}
	end

	def avg_diffculty
		total_diffculty = 0

		excersise_records.each do |record|
			total_diffculty += record.avg_diffculty
		end

		return total_diffculty / excersise_records.size
	end

	def max_diffculty
		return excersise_records.inject(0) { |memo, result|
			if result.max_diffculty > memo
				result.max_diffculty
			else
				memo
			end
		}
	end

end 
