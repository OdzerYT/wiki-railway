#!/bin/bash
set -e

echo "===== FIXING APACHE MPM ====="

rm -f /etc/apache2/mods-enabled/mpm_event.load
rm -f /etc/apache2/mods-enabled/mpm_event.conf
rm -f /etc/apache2/mods-enabled/mpm_worker.load
rm -f /etc/apache2/mods-enabled/mpm_worker.conf

a2enmod mpm_prefork rewrite

echo "===== MPM FILES ====="
ls -la /etc/apache2/mods-enabled/ | grep mpm || true

echo "===== APACHE CONFIG TEST ====="
apache2ctl -t

echo "===== STARTING APACHE ====="
exec apache2-foreground
