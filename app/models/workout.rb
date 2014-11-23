class Workout < ActiveRecord::Base

	belongs_to :user
	has_many :excersises
	has_many :workout_records
	
	def stastics
		stats = []

		return stats if workout_records.size == 0

		stats << ["Average Completion Time", avg_completion_time, "min"]
		stats << ["Average Rest Time", avg_rest_time, "min"]
		stats << ["Average Excersise Time", avg_excersise_time, "min"]

		return stats
	end

	private

	def avg_completion_time
		total_time = 0

		workout_records.each do |record|
			total_time += record.completion_time
		end

		return total_time / workout_records.size / 1000 / 60
	end

	def avg_rest_time
		total_time = 0

		workout_records.each do |record|
			total_time += record.total_rest_time
		end	

		return total_time / workout_records.size / 1000 / 60
	end

	def avg_excersise_time
		total_time = 0

		workout_records.each do |record|
			total_time += record.total_excersise_time	
		end

		return total_time / workout_records.size / 1000 / 60
	end
end
