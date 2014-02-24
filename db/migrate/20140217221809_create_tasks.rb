class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.integer :points
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
