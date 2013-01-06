class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :target_id
      t.string :target_type
      t.string :title
      t.string :body
      t.string :subject
      t.integer :creator_id
      t.string :creator_name
      t.integer :yes
      t.integer :no

      t.timestamps
    end
  end
end
