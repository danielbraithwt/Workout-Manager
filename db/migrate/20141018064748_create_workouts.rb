class CreateWorkouts < ActiveRecord::Migration
  def change
    create_table :workouts do |t|
		t.integer "user_id"
		t.string "name", :limit => 100

      t.timestamps
    end

	add_index("workouts", "user_id")
  end
end
