# Kosa2

The Kosa service for [the Pariyatti mobile app](https://pariyatti.app).

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

*Required App Changes*

* [x] Limit Infinite Scroll: https://github.com/pariyatti/mobile-app/issues/126
* [ ] Show Cards in Local Timezone: https://github.com/pariyatti/mobile-app/issues/129

*Optional / Future*

* standardrb
* ViewComponent
* pagination / limit
    * `geared_pagination` vs `pagy` 
* OAuth (Devise)
