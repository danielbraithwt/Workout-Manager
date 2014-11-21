class CreateExcersiseSets < ActiveRecord::Migration
  	def change
    	create_table :excersise_sets do |t|
		
			t.integer "excersise_record_id"
			t.integer "reps"
			t.float "diffculty"
			t.integer "completion_time"

    		t.timestamps
    	end

		add_index(:excersise_sets, :excersise_record_id)
	end
end
