class CreateFollows < ActiveRecord::Migration[5.1]
  def change
    create_table :follows do |t|
      t.integer :following_id
      t.integer :follower_id
      t.boolean :subscribed, default: false
      t.boolean :blocked, default: false

      t.timestamps
    end

    add_index :follows, [:following_id, :follower_id], unique: true
  end
end
