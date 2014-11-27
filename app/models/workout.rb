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

	def graphable_data(range)
		data_sets = {}

		records = records_in_range(range)

		data_sets["Avg Completion Times"] = [avg_completion_times(records), "min"]
		data_sets["Avg Rest Times"] = [avg_rest_times(records), "min"]
		data_sets["Avg Excersise Times"] = [avg_excersise_times(records), "min"]

		return data_sets
	end

	def largest_group
		return excersises.inject(0) { |memo, result|
			if result.group > memo
				result.group
			else
				memo
			end
		}
	end

	private

	def records_in_range(range)
		records = []

		date = range.days.ago.beginning_of_day

		(0..range).step(1) do |i|
			records_for_time = workout_records.where(:created_at => (date+i.days)..(date+i.days).end_of_day).limit(1)
			
			if records_for_time.size != 0
				records << records_for_time[0]
			else
				records << nil
			end
		end

		return records
	end

	def avg_completion_time
		total_time = 0

		workout_records.each do |record|
			total_time += record.completion_time
		end

		return total_time / workout_records.size / 1000 / 60
	end

	def avg_completion_times(records)
		data_points = []

		records.each do |record|
			if record != nil
				data_points << (record.completion_time / 1000 / 60)
			else
				data_points << -1
			end
		end

		return data_points
	end

	def avg_rest_time
		total_time = 0

		workout_records.each do |record|
			total_time += record.total_rest_time
		end	

		return total_time / workout_records.size / 1000 / 60
	end

	def avg_rest_times(records)
		data_points = []

		records.each do |record|
			if record != nil
				data_points << (record.total_rest_time / 1000 / 60)
			else
				data_points << -1
			end
		end

		return data_points
	end

	def avg_excersise_time
		total_time = 0

		workout_records.each do |record|
			total_time += record.total_excersise_time	
		end

		return total_time / workout_records.size / 1000 / 60
	end

	def avg_excersise_times(records)
		data_points = []

		records.each do |record|
			if record != nil
				data_points << (record.total_excersise_time / 1000 / 60)
			else
				data_points << -1
			end
		end

		return data_points
	end
end
