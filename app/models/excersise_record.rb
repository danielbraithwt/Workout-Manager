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

	def total_repetitions
		reps = 0

		excersise_sets.each do |set|
			reps += set.reps
		end

		return reps
	end

	def avg_diffculty
		total_diffculty = 0
		
		excersise_sets.each do |set|
			total_diffculty += set.diffculty
		end	

		return total_diffculty / excersise_sets.size
	end

	def max_diffculty
		return excersise_sets.inject(0) { |memo, result|
			if result.diffculty > memo
				result.diffculty
			else
				memo
			end
		}
	end
end 
