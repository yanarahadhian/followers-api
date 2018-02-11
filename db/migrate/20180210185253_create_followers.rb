class CreateFollowers < ActiveRecord::Migration[5.1]
  def change
    create_table :followers do |t|
      t.integer :follower_id

      t.timestamps
    end
    add_reference :followers, :user, index: true, foreign_key: {on_delete: :cascade}
  end
end
