class CreateExcersises < ActiveRecord::Migration
  def change
    create_table :excersises do |t|

      t.timestamps
    end
  end
end
