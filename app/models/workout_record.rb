class WorkoutRecord < ActiveRecord::Base
	belongs_to :workout
	has_many :excersise_records

	def total_excersise_time
		total_excersise_time = 0

		excersise_records.each do |record|
			total_excersise_time += record.total_time
		end

		return total_excersise_time
	end

	def total_rest_time
		return completion_time - total_excersise_time
	end

	def excersise_avg_rep_time_array
		rep_times = []

		excersise_records.each do |record|
			rep_times << record.avg_time_per_rep
		end

		return rep_times
	end

	def excersise_tonnage_array
		tonnages = []
 
		excersise_records.each do |record|
			tonnages << record.tonnage if record.excersise.excersisetype == 1
		end

		return tonnages
	end
end
