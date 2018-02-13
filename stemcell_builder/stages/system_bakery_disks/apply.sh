#!/usr/bin/env bash

set -e

base_dir=$(readlink -nf $(dirname $0)/../..)
source $base_dir/lib/prelude_apply.bash

echo "Installing open-iscsi NFS mount hack script"
cp $assets_dir/open_iscsi $chroot/etc/init.d/open_iscsi

echo "Add open-iscsi to startup"
run_in_chroot $chroot "chkconfig --level 345 open-iscsi"

echo "Add open-iscsi script to crontab"
run_in_chroot $chroot "
cat <<TAB >> /var/spool/cron/crontabs/root
* * * * * /etc/init.d/open-iscsi
* * * * * ( sleep 20; /etc/init.d/open-iscsi )
* * * * * ( sleep 40; /etc/init.d/open-iscsi )
TAB
"
