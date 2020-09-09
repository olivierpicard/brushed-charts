#!/bin/bash 

mkdir -p \
    /var/log/brushed-charts \
    /var/brushed-charts \
    /etc/brushed-charts

chmod 644 /var/log/brushed-charts/
chmod 644 /var/brushed-charts/
chmod 644 /etc/brushed-charts/

chown -R $USER /var/log/brushed-charts
chown -R $USER /var/brushed-charts
chown -R $USER /etc/brushed-charts