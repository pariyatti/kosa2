class CreateTxtFeeds < ActiveRecord::Migration[7.0]
  def change
    create_table :txt_feeds, id: :uuid do |t|
      t.text :language
      t.text :sha1_digest
      t.text :entry

      t.timestamps
      t.index [:language, :sha1_digest], unique: true
    end
  end
end
