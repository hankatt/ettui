class CreateSources < ActiveRecord::Migration[4.2]
  def change
    create_table :sources do |t|
      t.string :hostname
      t.string :favicon

      t.timestamps
    end
  end
end
