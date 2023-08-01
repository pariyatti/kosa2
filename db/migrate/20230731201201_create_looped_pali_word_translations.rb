class CreateLoopedPaliWordTranslations < ActiveRecord::Migration[7.0]
  def change
    create_table :looped_pali_word_translations do |t|
      t.string :language
      t.text :text
      t.references :looped_pali_word, null: false, foreign_key: true

      t.timestamps
    end
  end
end
