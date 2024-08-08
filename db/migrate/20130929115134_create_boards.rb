class CreateBoards < ActiveRecord::Migration[4.2]
  def change
    create_table :boards do |t|
      t.string :name
      t.text :description
      t.integer :user_id

      t.timestamps
    end
  end
end
