#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /kosa/tmp/pids/server.pid

bin/rails db:prepare

if [[ "$RUN_INGESTION" == "yes" ]]; then
    TXT_FILES_DIR=/kosa/txt
    FILECOUNT=$(find $TXT_FILES_DIR -type f | wc -l)
    if [ "$FILECOUNT" -lt 10 ]; then
        echo "Warning: the txt directory doesn't have enough files, if you would like to ingest looped cards to local pg db run rake kosa:txt:clone"
    else
        echo "Running kosa:txt:ingest"
        rake kosa:txt:ingest
    fi
fi
# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"