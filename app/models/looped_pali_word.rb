class LoopedPaliWord < ApplicationRecord
  include Nameable
  include LoopIngestable
  has_many :translations, class_name: 'LoopedPaliWordTranslation', dependent: :destroy

  def self.ingest_all
    conf[:languages].each do |lang|
      ingest(conf[:filemask].gsub("%s", lang), lang)
    end
  end

  def self.validate_ingest!
    LoopedPaliWord.all.each do |lpw|
      ts = lpw.translations
      diff = {actual: ts, expected: conf[:languages]}
      raise "TXT translation count did not match!\n\n#{diff}" if ts.count != conf[:languages].count
    end
  end

  def self.publish_daily!
    puts "Running #{human_name} 'publish_daily!' @ #{Time.now}"
    count = LoopedPaliWord.all.count
    if count > 0
      publish_nth(count)
    else
      logger.info "#### Zero #{name} found."
    end
  end

  def self.publish_nth(count)
    now = DateTime.now.utc
    pub_time = now.change(publish_at_time).to_formatted_s(:kosa)
    #         idx (which-card pub-time cc)
    index = which_card(pub_time, count)
    #         card (-> (looped-find pub idx)
    #                  first
    #                  (types/dup (type pub)))
    card = LoopedPaliWord.where(index: index).sole.transcribe(pub_time)
    #         existing (entity-find pub card)
    existing = PaliWord.where(pali: card.pali).order(:published_at, :desc)
    #         published-at (published-at-key pub)
    #         save-fn (partial save! pub)]
    puts "index is: #{index}"
    logger.info "#### Today's #{human_name} is: #{card.main_key}"
    if existing.empty? || days_between(existing.first.published_at, pub_time) > 2
      card.save!
    else
      logger.info "#### Ignoring. '#{card.main_key}' already exists within a 2-day window."
    end
  end

  def self.days_between(big, small)
    (big.to_date - small.to_date)
      .then {|day_fraction| day_fraction.to_i.abs }
  end

  def self.which_card(now, count)
    # ;; (def looped-card-count 220)
    # ;; (def days-since-epoch (t/days (t/between (t/epoch) (t/now))))
    # ;; (def days-since-perl (- days-since-epoch 12902))
    # ;; (def todays-word (mod days-since-perl looped-card-count))
    # (defn which-card [today card-count]
    #   ;; "perl epoch":
    #   ;; (t/>> (t/epoch)
    #   ;;       (t/new-duration 12902 :days))
    #   ;; => #time/instant "2005-04-29T00:00:00Z"
    #   (mod (time/days-between "2005-04-29T00:00:00Z" today)
    #        card-count))
    days_between(Date.parse(PERL_EPOCH), now)
      .then {|day_offset| day_offset % count }
  end

  def self.publish_at_time
    # 08:11:02am PST +08:00 from UTC = 16:11:02
    { hour: 16, min: 11, sec: 2 }
  end

  def self.parse(line)
    line.split('—').map(&:strip)
  end

  def self.insert(lang, pair)
    lpw = LoopedPaliWord.find_or_create_by!(pali: pair.first, original_pali: pair.first)
    lpw.safe_set_index!
    lpw.translations.find_or_create_by!(language: lang, text: pair.second)
    lpw
  end

  def self.conf
    Rails.application.config_for(:looped_cards)[:txt_feeds][:pali_word]
  end

  def transcribe(pub_time)
    pw = PaliWord.new(pali: self.pali, original_pali: self.original_pali, original_url: self.original_url, published_at: pub_time)
    translations.each do |t|
      pw.translations.build(language: t.language, text: t.text)
    end
    pw
  end

end
