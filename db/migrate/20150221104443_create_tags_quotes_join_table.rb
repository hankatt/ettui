class CreateTagsQuotesJoinTable < ActiveRecord::Migration
  def change

    drop_table :tags

    create_table :tags do |t|
      t.string :name, null: false, unique: true
    end

    create_table :quotes_tags, id: false do |t|
      t.references :tag, index: true
      t.references :quote, index: true
    end

  end
end
