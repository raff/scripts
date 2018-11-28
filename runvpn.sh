#!/bin/bash
#
# A script to run OpenVPN with NordVPN configuration files
# (but should work with other vpn services with a similar configuration)
#
# usage:
#  runvpn            # start a vpn picking a random configuration for for "us"
#  runvpn 'country'  # start a vpn picking a random configuration for the specified country
#  runvpn stop       # stop current vpn connection
#
# you can also use the --tcp or --udp option to run vpn over tcp or udp protocol
#
# credentials (username and password) should be stored in /etc/openvpn/creds
#

creds=/etc/openvpn/creds
pidfile=/tmp/openvpn.pid
proto=ovpn_udp

if [[ "$1" = "--tcp" ]]; then
  proto=ovpn_tcp
  shift
elif [[ "$1" = "--udp" ]]; then
  proto=ovpn_udp
  shift
fi

prefix=$1
if [[ "$prefix" = "" ]]; then
  prefix="us"
fi

if [[ "$prefix" = "stop" ]]; then
  if [[ -e $pidfile ]]; then
     echo "stopping vpn..."
     pid=`cat $pidfile`
     sudo rm -rf $pidfile
     sudo kill $pid
     exit $?
  else
     echo "nothing to stop"
     exit 1
  fi
fi

l=(`ls /etc/openvpn/$proto/${prefix}*`)
n=${#l[@]}

conf=${l[`expr $RANDOM % $n`]}
echo "starting vpn with $conf"
grep -v auth-user-pass $conf > /tmp/openvpn.conf
sudo openvpn --daemon --auth-user-pass $creds --config /tmp/openvpn.conf --writepid /tmp/openvpn.pid
sleep 1
tail -50 /var/log/daemon.log | grep "Peer Connection Initiated with"
