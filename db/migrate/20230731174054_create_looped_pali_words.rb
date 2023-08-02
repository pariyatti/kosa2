class CreateLoopedPaliWords < ActiveRecord::Migration[7.0]
  def change
    create_table :looped_pali_words do |t|
      t.bigint :index
      t.string :original_pali
      t.string :original_url
      t.string :pali

      t.timestamps
    end
  end
end
