class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.integer :taicii_id
      t.string :content
      t.string :creator_id
      t.string :creator_name
      t.string :tag
      t.integer :yes
      t.integer :no

      t.timestamps
    end
  end
end
