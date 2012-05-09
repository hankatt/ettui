class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.text :text
      t.source :text
      t.integer :user_id
      t.timestamps
    end
  end
end
