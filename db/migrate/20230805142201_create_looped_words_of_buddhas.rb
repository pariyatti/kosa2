class CreateLoopedWordsOfBuddhas < ActiveRecord::Migration[7.0]
  def change
    create_table :looped_words_of_buddhas, id: :uuid do |t|
      t.bigint :index
      t.text :words
      t.string :citepali
      t.string :citepali_url
      t.string :citebook
      t.string :citebook_url
      t.text :original_words
      t.string :original_url
      t.string :original_audio_url
      t.datetime :published_at

      t.timestamps
    end
  end
end
