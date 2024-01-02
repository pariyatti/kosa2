# Kosa2

Spiking Kosa in (vanilla) Rails.

## Dependencies

* `rbenv`
* Ruby 3.0.2
* Postgres 14
* Rails 7.0.6
* `gem install pg -- --with-pg-config=/usr/local/bin/pg_config`

## Access TXT Files

If you intend to use the "looped cards" (Pali Word a Day, Daily Words
of the Buddha, or Daily Dohas), you will need access to the private
repository containing the input files (<https://github.com/pariyatti/Daily_emails_RSS>)
before you can run `make txt-clone`, as explained below. Speak to Pariyatti Staff to
obtain access. If you do not have access to these files, Kosa will still run
without them.

## Build / Run Kosa

```shell
git clone git@github.com:pariyatti/kosa.git
cd kosa

rake kosa:txt:clean                     # Remove TXT files
rake kosa:txt:clone                     # Clone TXT files from GitHub
rake kosa:txt:ingest                    # Ingest TXT files
rails s -b 0.0.0.0                      # needed for IP access from mobile app
```

## Deploy

NOTE: The [the `paper_trail` install generator](https://github.com/paper-trail-gem/paper_trail#1b-installation) 
generates migrations out-of-band, so it's a development-time step, not a deployment step.

```sh 
bundle exec rails db:migrate
```

## TODOs

*Required Ops*

* Caddy Setup
* Postgres Data Backup
* [ ] `~/.kosa/secrets` ?

*Required App Changes*

* [ ] Limit Infinite Scroll: https://github.com/pariyatti/mobile-app/issues/126
* [ ] Show Cards in Local Timezone: https://github.com/pariyatti/mobile-app/issues/129

*Required Kosa Changes*

* [ ] ActiveStorage to S3 instead of local
    * [ ] Ops for S3 Access Key
    * [ ] configure production.rb, staging.rb
* [x] expose / test self-reference URLs
    * [x] dynamic host
    * [x] expose in controllers
* [ ] test non-CDN audio URLs from mobile app

*Optional / Future*

* standardrb
* ViewComponent
* pagination / limit
* OAuth (Devise)
