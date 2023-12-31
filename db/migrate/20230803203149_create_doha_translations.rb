class CreateDohaTranslations < ActiveRecord::Migration[7.0]
  def change
    create_table :doha_translations, id: :uuid do |t|
      t.string :language
      t.text :translation
      t.references :doha, null: false, foreign_key: true, type: :uuid

      t.datetime :published_at
      t.timestamps
    end
  end
end
