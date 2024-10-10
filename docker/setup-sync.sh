#!/bin/sh

if [ -e "/taskrc" ]; then
    echo "already completed setup, continuing..."
    exit 1
fi

echo "creating taskrc..."

touch /taskrc

task config sync.server.url "$URL" <<EOF
y
EOF

task config sync.encryption_secret "$ENCRYPTION_SECRET" <<EOF
y
EOF

task config sync.server.client_id "$CLIENT_ID" <<EOF
y
EOF

task sync
