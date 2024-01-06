# Kosa2

Spiking Kosa in (vanilla) Rails.

## Dependencies

* `rbenv`
* Ruby 3.2.2
* Postgres 14
* Rails 7.1.2
* `gem install pg -- --with-pg-config=/usr/local/bin/pg_config`

## Access TXT Files

If you intend to use the "looped cards" (Pali Word a Day, Daily Words
of the Buddha, or Daily Dohas), you will need access to the private
repository containing the input files (<https://github.com/pariyatti/Daily_emails_RSS>)
before you can run `make txt-clone`, as explained below. Speak to Pariyatti Staff to
obtain access. If you do not have access to these files, Kosa will still run
without them.

## Build / Run Kosa

* install [`rbenv`](https://github.com/rbenv/rbenv)

```shell
git clone git@github.com:pariyatti/kosa2.git
cd kosa2

rake kosa:txt:clean                     # Remove TXT files
rake kosa:txt:clone                     # Clone TXT files from GitHub
rake kosa:txt:ingest                    # Ingest TXT files
rails s -b 0.0.0.0                      # needed for IP access from mobile app
```

## Deploy

```sh 
bundle exec rails db:migrate
```

If retroactive looped cards are required, they can be generated/published with:

```sh 
MONTHS=6 rake kosa:looped:publish
```

## Development

* *Date/Time/DateTime:* Everywhere in Kosa, we will use the Ruby `Date` and `DateTime` classes exclusively.
  Although `Time` is capable of representing BCE dates, Kosa does _not_ care about timezones or leap seconds,
  since every time value is stored in UTC. Timezones are only used in clients. 
  `DateTime` provides a saner approach to calendars than seconds from epoch.
  See [SO discussion](https://stackoverflow.com/questions/1261329/difference-between-datetime-and-time-in-ruby).

## TODOs

*Required Ops*

* [ ] way to load db backup
* [ ] create deploy GitHub Action
* [x] configure EFS volume mount?
* [x] setup initial AWS deploy infra (PR #1)

*Required App Changes*

* [ ] Limit Infinite Scroll: https://github.com/pariyatti/mobile-app/issues/126
* [ ] Show Cards in Local Timezone: https://github.com/pariyatti/mobile-app/issues/129

*Required Kosa Changes*

* [x] test non-CDN audio URLs from mobile app
* [x] deal with failed downloads (below)
* [x] add CI: GitHub Actions w smoke tests
* [x] populate /today cards back in time?
    * [x] large refactor of publishing
    * [x] ability to publish for a specific date
* [x] ActiveStorage to S3 instead of local
    * [x] Ops for S3 Access Key - not required (we use IAM)
    * [x] configure production.rb, staging.rb
* [x] expose / test self-reference URLs
    * [x] dynamic host (trickery for per-environment routing)
    * [x] expose in controllers
* [x] DB audits w paper_trail

*Optional / Future*

* standardrb
* ViewComponent
* pagination / limit
* OAuth (Devise)
