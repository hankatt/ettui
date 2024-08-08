class Subscriptions < ActiveRecord::Migration[4.2]
  def change
    create_table :subscriptions, :id => false do |t|
      t.belongs_to :board
      t.belongs_to :user
    end
  end
end
