class CreatePaliWordTranslation < ActiveRecord::Migration[7.0]
  def change
    create_table :pali_word_translations, id: :uuid do |t|
      t.string :language
      t.text :translation
      t.references :pali_word, type: :uuid, null: false, foreign_key: true

      t.datetime :published_at
      t.timestamps
    end
  end
end
