class CreateLoopedDohas < ActiveRecord::Migration[7.0]
  def change
    create_table :looped_dohas, id: :uuid do |t|
      t.text :doha
      t.text :original_doha
      t.string :original_url
      t.string :original_audio_url

      t.timestamps
    end
  end
end
