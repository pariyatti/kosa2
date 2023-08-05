class CreateWordsOfBuddhaTranslations < ActiveRecord::Migration[7.0]
  def change
    create_table :words_of_buddha_translations, id: :uuid do |t|
      t.string :language
      t.text :translation
      t.references :words_of_buddha,
                   # to match LoopedWordsOfBuddhaTranslations:
                   index: {name: 'index_wob_translations_on_wob_id'},
                   null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
