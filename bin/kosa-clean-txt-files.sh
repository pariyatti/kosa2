#!/usr/bin/env bash
set -e

(
    KOSA=$(dirname "$0")/..
    if [ "$KOSA" != "./bin/.." ]; then
        printf "####\n"
        printf "'copy-txt-files.sh' must be run from Kosa root. Exiting.\n"
        exit 1
    fi

    rm -rf txt/pali   && mkdir -p txt/pali   && touch txt/pali/.keep
    rm -rf txt/buddha && mkdir -p txt/buddha && touch txt/buddha/.keep
    rm -rf txt/dohas  && mkdir -p txt/dohas  && touch txt/dohas/.keep
    rm -rf /tmp/daily_emails_rss_auto
)
