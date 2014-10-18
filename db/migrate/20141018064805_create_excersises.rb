class CreateExcersises < ActiveRecord::Migration
  def change
    create_table :excersises do |t|
		t.string "name", :limit => "100"
		t.integer "type"
		t.float "diffculty"
		t.integer "group", :defualt => 0
		t.integer "position"

      t.timestamps
    end
  end
end
