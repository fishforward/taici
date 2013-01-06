class CreateStands < ActiveRecord::Migration
  def change
    create_table :stands do |t|
      t.integer :a
      t.integer :b
      t.string :s_type
      t.string :comment
      t.string :status
      t.integer :creator_id
      t.string :creator_name

      t.timestamps
    end
  end
end
