#!/usr/bin/env python
from os.path import join
from os.path import abspath
import re
ipv4_regex = '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'


def cradlepoint_clients(text):
    # Connection Type: all
    # Hostname             IP                        MAC
    # -No Host Name-       fe80::1c2d:3b5f:de0b:b6cd a8:66:7f:86:6d:ca
    # b17byq1              fe80::a11a:b88b:f1a9:87b8 78:2b:cb:b1:d7:00
    # Jeralds-iPad         fe80::470:4fe9:eca2:22b   2c:f0:ee:4b:0e:58
    # SAMSUNG-SM-G920A     fe80::ae5f:3eff:fe14:654e ac:5f:3e:14:65:4e
    # Jeralds-iPad         fe80::1025:346a:7aa8:d1aa 2c:f0:ee:4b:0e:58
    parsed = {}

    for line in text.splitlines():
        # Test line for valid ipv4 addresses
        if re.search(ipv4_regex, line):
            (hostname, mac, ipv4) = line.split()
            parsed += [{'hostname': hostname, 'mac': mac, 'ip_address': ipv4}]

        return list(set(parsed))


def zyxel_clients(text):
    #      No.  Interface       IP Address      MAC Address       Reserved Host Name                     Expiration Time
    #                Description
    # ===============================================================================
    # 1    lan1            172.20.24.116   6c:3b:e5:06:f9:7e no       "NPI06F97E"                    2018-03-22 02:21:17
    #
    # 2    lan1            172.20.24.140   a0:04:60:75:fc:61 no       "R7000"                        2018-03-22 02:44:40
    #
    # 3    lan1            172.20.24.119   08:00:0f:67:fa:18 no       none                         2018-03-22 04:22:13 \
    parsed = []

    for line in text.splitlines():
        if re.search(ipv4_regex, line):
            (hostname, mac, ipv4) = line.split()[2:4]
            parsed += [{'hostname': hostname, 'mac': mac, 'ipv4': ipv4}]

    return list(set(parsed))


class FilterModule(object):
    def filters(self):
        return {
            'parse_zyxel_client_list': zyxel_clients,
            'parse_cradlepoint_client_list': cradlepoint_clients,
        }