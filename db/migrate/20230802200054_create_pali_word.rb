class CreatePaliWord < ActiveRecord::Migration[7.0]
  def change
    create_table :pali_words, id: :uuid do |t|
      t.bigint :index
      t.string :original_pali
      t.string :original_url
      t.string :pali

      t.date :published_date
      t.datetime :published_at
      t.timestamps
    end
  end
end
