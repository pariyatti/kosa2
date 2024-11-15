class CreateVideos < ActiveRecord::Migration[7.1]
  def change
    create_table :videos, id: :uuid do |t|
      t.string :uri
      t.string :name
      t.text :description
      t.string :link
      t.string :player_embed_url
      t.integer :duration
      t.integer :width
      t.integer :height
      t.string :language
      t.string :embed_html
      t.timestamp :created_time
      t.timestamp :modified_time
      t.timestamp :release_time
      t.string :privacy_view
      t.string :privacy_embed
      t.boolean :privacy_download
      t.string :picture_base_link
      t.text :tags
      t.integer :play_stats
      t.string :status

      t.timestamps
    end
  end
end
