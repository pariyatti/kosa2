require 'json'
using RefinedVimeoMe2User

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
  include Upsertable

  def self.sync_all!
    json = Video.download_vimeo_json
    Video.sync_json_to_db!(json)
  end

  def self.force_all_public_embeds
    json = download_vimeo_json
    videos = json['data']
    videos.each do |video|
      print "."
      if video['privacy']['embed'] != 'public'
        puts "Found non-embed video. Forcing public..."
        puts video['uri']
        puts video['name']
        force_public_embed(video['uri'].sub(/^\/videos\//, ''))
      end
    end
  end

  def self.dump_latest_spreadsheet!
    json = download_vimeo_json
    sliced = json['data']
      .map {|v| v.slice('link', 'name', 'description', 'tags')}
      .map do |v|
        tags = v['tags'].map {|t| t['tag'] }
        v['category'] = tags.select {|t| t.include?('category:')}.first || ""
        v['tags'] = tags.join(",")
        v
      end
    Axlsx::Package.new do |p|
      p.workbook.add_worksheet(:name => "Videos") do |sheet|
        sheet.add_row %w[Link Title Description Tags Category]
        sliced.each do |v|
          sheet.add_row [v['link'], v['name'], v['description'], v['tags'], v['category']]
        end
      end
      puts "Serializing data to XLSX..."
      p.serialize(Rails.root.join('tmp', 'vimeo_latest.xlsx'))
    end
  end

  def self.force_public_embed(video_id)
    token = Rails.application.credentials.vimeo_authenticated_token || ENV['VIMEO_API_TOKEN']
    v = VimeoMe2::Video.new(token, video_id)
    v.privacy = {"embed" => "public"}
    v.update
  end

  def self.download_vimeo_json
    token = Rails.application.credentials.vimeo_authenticated_token || ENV['VIMEO_API_TOKEN']
    @user = VimeoMe2::User.new(token, 'pariyatti')
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

  def self.sync_json_to_db!(json)
    created = 0
    updated = 0
    videos = json_to_videos(json)
    videos.each do |video|
      _, c, u = Video.create_or_update!(:uri, video)
      created += c
      updated += u
    end
    puts "Created #{created} new videos"
    puts "Updated #{updated} existing videos (blindly)"
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
