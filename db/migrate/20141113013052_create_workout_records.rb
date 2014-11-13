class CreateWorkoutRecords < ActiveRecord::Migration
  	def change
    	create_table :workout_records do |t|
			t.integer "workout_id"	

      		t.timestamps
    	end

		add_index(:workout_records, :workout_id)
  	end
end 
