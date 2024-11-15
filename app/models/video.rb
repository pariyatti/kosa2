# == Schema Information
#
# Table name: videos
#
#  id                :uuid             not null, primary key
#  created_time      :datetime
#  description       :text
#  duration          :integer
#  embed_html        :string
#  height            :integer
#  language          :string
#  link              :string
#  modified_time     :datetime
#  name              :string
#  picture_base_link :string
#  play_stats        :integer
#  player_embed_url  :string
#  privacy_download  :boolean
#  privacy_embed     :string
#  privacy_view      :string
#  release_time      :datetime
#  status            :string
#  tags              :text
#  uri               :string
#  width             :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Video < ApplicationRecord
end
