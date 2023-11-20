#!/usr/bin/env bash

# Configures critical settings for OpenSSH server.

exec 1>&2
set -o errexit -o nounset -o pipefail
set -x

# NOTE: in this old version of OL, gawk does not understand
# the "-i inplace" option.

gawk -f- /etc/ssh/sshd_config >/etc/ssh/sshd_config.new <<'EOF'
BEGIN { update = "PasswordAuthentication no" }
/^[#\s]*PasswordAuthentication\s*/ { $0 = update; found = 1 }
{ print }
END { if (!found) print update >> FILENAME }
EOF
mv /etc/ssh/sshd_config{.new,}

gawk -f- /etc/ssh/sshd_config >/etc/ssh/sshd_config.new <<'EOF'
BEGIN { update = "PermitRootLogin without-password" }
/^[#\s]*PermitRootLogin\s*/ { $0 = update; found = 1 }
{ print }
END { if (!found) print update >> FILENAME }
EOF
mv /etc/ssh/sshd_config{.new,}

gawk -f- /etc/ssh/sshd_config >/etc/ssh/sshd_config.new <<'EOF'
BEGIN { update = "UseDNS no" }
/^[#\s]*UseDNS\s*/ { $0 = update; found = 1 }
{ print }
END { if (!found) print update >> FILENAME }
EOF
mv /etc/ssh/sshd_config{.new,}

sync