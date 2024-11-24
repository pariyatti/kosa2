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
  def self.download_vimeo_json
    @user = VimeoMe2::User.new(Rails.application.credentials.vimeo_authenticated_token, 'pariyatti')
    videos = @user.get_full_video_list
    # dump_latest_json(videos)
    # videos
  end

  # These are Video objects, not json... need to delay the transformation
  # def self.dump_latest_json(videos)
  #   File.open(Rails.root.join('tmp', 'vimeo_latest.json'), 'w') do |f|
  #     f.print(videos.to_s)
  #     f.flush
  #   end
  # end

  def self.sync_vimeo_json(json)

  end
end
