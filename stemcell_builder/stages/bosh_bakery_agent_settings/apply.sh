#!/usr/bin/env bash

base_dir=$(readlink -nf $(dirname $0)/../..)
source $base_dir/lib/prelude_apply.bash
source $base_dir/lib/prelude_agent.bash

cat > $chroot/var/vcap/bosh/agent.json <<JSON
{
  "Platform": {
    "Linux": {
      "CreatePartitionIfNoEphemeralDisk": false,
      "DevicePathResolutionType": "virtio"
    }
  },
  "Infrastructure": {
    "NetworkingType": "dynamic",
    "Settings": {
      "Sources": [
        {
          "Type": "File",
          "SettingsPath": "/piConfig/settings.json"
        }
      ],
      "UseServerName": true,
      "UseRegistry": false
    }
  }
}
JSON
