#!/usr/bin/env bash

set -e

base_dir=$(readlink -nf $(dirname $0)/../..)
source $base_dir/lib/prelude_apply.bash

echo "Installing open-iscsi NFS mount hack script"
cp $assets_dir/open-iscsi $chroot/etc/init.d/open-iscsi

echo "Add open-iscsi to startup"
ln -s ../init.d/open-iscsi $chroot/etc/rc2.d/S10open-iscsi
ln -s ../init.d/open-iscsi $chroot/etc/rc3.d/S10open-iscsi
ln -s ../init.d/open-iscsi $chroot/etc/rc4.d/S10open-iscsi
ln -s ../init.d/open-iscsi $chroot/etc/rc5.d/S10open-iscsi

echo "Add open-iscsi script to crontab"
run_in_chroot $chroot "
cat <<TAB >> /var/spool/cron/crontabs/root
* * * * * /etc/init.d/open-iscsi
* * * * * ( sleep 20; /etc/init.d/open-iscsi )
* * * * * ( sleep 40; /etc/init.d/open-iscsi )
TAB
"
