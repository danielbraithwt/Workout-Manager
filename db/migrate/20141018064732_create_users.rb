class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
		t.string "first_name", :limit => 200
		t.string "last_name", :limit => 200
		t.string "email", :limit => 200
		t.string "password_digest"

      	t.timestamps
    end
  end

  def down
	drop_table :users
  end
end
