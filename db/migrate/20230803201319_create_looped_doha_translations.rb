class CreateLoopedDohaTranslations < ActiveRecord::Migration[7.0]
  def change
    create_table :looped_doha_translations, id: :uuid do |t|
      t.string :language
      t.text :translation
      t.references :looped_doha, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
