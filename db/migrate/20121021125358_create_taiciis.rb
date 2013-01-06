class CreateTaiciis < ActiveRecord::Migration
  def change
    create_table :taiciis do |t|
      t.string :t_type
      t.string :content
      t.string :source
      t.integer :creator_id
      t.string :creator_name
      t.string :tag
      t.integer :yes
      t.integer :no

      t.timestamps
    end
  end
end
