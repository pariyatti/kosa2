class CreateLoopedPaliWordTranslations < ActiveRecord::Migration[7.0]
  def change
    create_table :looped_pali_word_translations, id: :uuid do |t|
      t.string :language
      t.text :translation
      t.references :looped_pali_word, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
