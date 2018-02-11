class CreateSubscribes < ActiveRecord::Migration[5.1]
  def change
    create_table :subscribes do |t|
      t.integer :subscribe_id
      t.boolean :block, default: false

      t.timestamps
    end
    add_reference :subscribes, :user, index: true, foreign_key: {on_delete: :cascade}
  end
end
