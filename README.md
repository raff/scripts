# scripts
A collection of useful scripts

## runvpn

A script to run OpenVPN with NordVPN configuration files
(but should work with other vpn services with a similar configuration)

Used to create a VPN connection on a Raspberry Pi.

usage:

    runvpn            # start a vpn picking a random configuration for for "us"
    runvpn 'country'  # start a vpn picking a random configuration for the specified country
    runvpn stop       # stop current vpn connection

you can also use the --tcp or --udp option to run vpn over tcp or udp protocol
