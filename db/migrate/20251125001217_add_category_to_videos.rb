class AddCategoryToVideos < ActiveRecord::Migration[7.1]
  def change
    add_column :videos, :category, :string
  end
end
