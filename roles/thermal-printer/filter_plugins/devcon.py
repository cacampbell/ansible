#!/usr/bin/env python

def first_citizen_id(devcon_results, printer_description):
    # devcon_results:
    # USBPRINT\CITIZENCL-S521\7&1A37EE0D&1&USB001 : Citizen CL-S521  # This is a USB attached printer
    # SWD\PRINTENUM\WSD-{UUID}.0061 : HP Laserjet M1530 MFP Series PCL 6  # This is a network printer
    # ...
    # printer_description:
    # Citizen CL-S521
    #
    # return:
    # USBPRINT\CITIZENCL-S521\7&1A37EE0D&1&USB001
    #
    for line in devcon_results:
        condensed_description = "".join(printer_description.split()).upper()
        if printer_description in line or condensed_description in line:
            return(line.split(':')[0].strip().replace('\\\\', '\\'))
        elif printer_description[:8] in line:
            # Sometimes, you discover a printer with a strange name -- in the case that the printer has been flashed,
            # for instance (i.e a printer that looks like one model may actually be another)
            # Try with first 8 characters (a likely truncation length for the full name)
            return (line.split(':')[0].strip().replace('\\\\', '\\'))
    return ""


def hwid(hwid_output):
    # hwid_output:
    # Name: <name>   # ...
    # Hardware IDs:  # index
    #   <id 1>       # index + 1
    #   <id 2>
    #
    # Name: <another name>
    # Hardware IDs:
    #   <id 3>
    #   <id 4>
    #
    # X matching device(s) found
    #
    # return:
    # <id 1>
    indices = [index for index, line in enumerate(hwid_output) if 'Hardware IDs:' in line]
    index = indices[0]
    return hwid_output[index + 1].strip()


def port(hwid):
    # hwid:
    # USBPRINT\CITIZENCL-S521\7&1A37EE0D&1&USB001
    #
    # return:
    # USB001
    return hwid.split('&')[-1].strip()


class FilterModule(object):
    def filters(self):
        return {
            'first_citizen_id': first_citizen_id,
            'hwid': hwid,
            'port': port,
        }