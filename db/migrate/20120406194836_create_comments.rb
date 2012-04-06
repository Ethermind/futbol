class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :match_id
      t.integer :user_id
      t.string :message

      t.timestamps
    end
  end
end
