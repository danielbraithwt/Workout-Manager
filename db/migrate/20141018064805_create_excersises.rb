class CreateExcersises < ActiveRecord::Migration
  def change
    create_table :excersises do |t|
		t.integer "workout_id"
		t.string "name", :limit => "100"
		t.integer "excersisetype"
		t.float "diffculty"
		t.integer "sets"
		t.integer "reps"
		t.integer "group", :defualt => 0
		t.integer "position"

      t.timestamps
    end

	add_index("excersises", "workout_id")
  end
end
