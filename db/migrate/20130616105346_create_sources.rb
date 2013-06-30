class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :hostname
      t.string :favicon

      t.timestamps
    end
  end
end
