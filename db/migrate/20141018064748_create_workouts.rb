class CreateWorkouts < ActiveRecord::Migration
  def change
    create_table :workouts do |t|
		t.string "name", :limit => 100

      t.timestamps
    end
  end
end
