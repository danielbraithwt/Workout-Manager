class CreateExcersiseRecords < ActiveRecord::Migration
  	def change
    	create_table :excersise_records do |t|
			t.integer "workout_record_id"
			t.integer "excersise_id"	
			t.integer "sets"
			t.integer "reps"
			t.float "diffculty"

      		t.timestamps
    	end

		add_index(:excersise_records, :workout_record_id)
		add_index(:excersise_records, :excersise_id)
  	end
end 
