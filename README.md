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

* TODO

## TODOs

*Required*

* TXT file hash check before ingest
* ActiveStorage to S3 instead of local
* expose / test self-reference URLs (with dynamic host)
* test non-CDN audio URLs from mobile app
* https://github.com/collectiveidea/audited
    * uuids
    * jsonb columns?
    * ops: be aware of upgrade path

*Optional / Future*

* standardrb
* ViewComponent
* pagination / limit
* OAuth (Devise)
