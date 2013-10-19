class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.text :text
      t.string :url
      t.integer :user_id
      t.integer :source_id
      
      t.timestamps
    end
  end
end
