require 'json'

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
    json = @user.get_full_video_list
    dump_latest_json(json)
    json
  end

  def self.dump_latest_json(h)
    File.open(Rails.root.join('tmp', 'vimeo_latest.json'), 'w') do |f|
      f.print(h.to_json)
      f.flush
    end
  end

  def self.sync_vimeo_json!(json)
    updated = 0
    created = 0
    videos = json_to_videos(json)
    videos.each do |video|
      existing = Video.where(uri: video.uri).first
      if existing
        existing.update!(video.attributes.except('id').except('created_at').except('updated_at'))
        updated += 1
      else
        video.save!
        created += 1
      end
    end
    puts "Updated #{updated} existing videos (blindly)"
    puts "Created #{created} new videos"
  end

  def self.json_to_videos(json)
    json['data'].map {|h| to_video(h) }
  end

  def self.to_video(h)
    v = Video.new(
      uri:               h['uri'],
      name:              h['name'],
      description:       h['description'],
      link:              h['link'],
      player_embed_url:  h['player_embed_url'],
      embed_html:        h['embed_html'],
      width:             h['width'],
      height:            h['height'],
      language:          h['language'],
      duration:          h['duration'],
      created_time:      h['created_time'],
      modified_time:     h['modified_time'],
      release_time:      h['release_time'],
      privacy_view:      h['privacy']['view'],
      privacy_embed:     h['privacy']['embed'],
      privacy_download:  h['privacy']['download'],
      picture_base_link: h['pictures']['base_link'],
      tags:              h['tags'].map { |t| t['name'] }, #.join(','),
      play_stats:        h['stats']['plays'],
      status:            h['status']
    )
    v.validate!
    v
  end
end
