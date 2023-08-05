class CreateLoopedWordsOfBuddhaTranslations < ActiveRecord::Migration[7.0]
  def change
    create_table :looped_words_of_buddha_translations, id: :uuid do |t|
      t.string :language
      t.text :translation
      t.references :looped_words_of_buddha,
                   # to stay under the 63-character index name limit:
                   index: {name: 'index_looped_wob_translations_on_looped_wob_id'},
                   null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
