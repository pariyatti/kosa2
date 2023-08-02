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

## Build Kosa

```shell
git clone git@github.com:pariyatti/kosa.git
cd kosa

make txt-clean     # completely reset TXT files (optional)
make txt-clone     # download TXT files for looped cards (optional)
```

## Deploy

* TODO

## TODOs

* standardrb
* annotate_models
