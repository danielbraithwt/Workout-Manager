class ExcersiseRecord < ActiveRecord::Base
	belongs_to :workout_record
	belongs_to :excersise

	has_many :excersise_sets

	def avg_time_per_rep
		total_time = 0
		total_reps = 0

		excersise_sets.each do |set|
			total_time += set.completion_time
			total_reps += set.reps
		end

		return total_time/total_reps
	end

	def total_time
		total_time = 0

		excersise_sets.each do |set|
			total_time += set.completion_time
		end

		return total_time  
	end

	def tonnage
		total_tonnage = 0 

		excersise_sets.each do |set|
			total_tonnage += set.tonnage
		end

		return total_tonnage
	end
end 
