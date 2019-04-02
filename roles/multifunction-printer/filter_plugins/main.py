#!/usr/bin/env python3
from difflib import get_close_matches


def int_pub_name(output):
    stdout_lines = output['stdout_lines']

    for line in stdout_lines:
        if line.strip().startswith("Published"):
            return line.split(":")[-1].strip()

    return ""


def driver_name(stdout, printer_make, printer_model, idkey):
    stdout = "\n".join(stdout)
    linesep = "\n"

    printer_name = "{}{}".format(
        printer_make.replace(" ", "_"),
        printer_model.replace(" ", "_"))

    separator = "{}{}".format(linesep, linesep)
    chunks = stdout.split(separator)
    profiles = []

    for chunk in chunks:
        d = {}

        try:
            for line in chunk.split(linesep):
                if ":" in line:
                    (key, value) = line.split(":")
                    d[key.strip()] = value.strip()
        except Exception:
            pass

        profiles += [d]

    ids = [d[idkey] for d in profiles if idkey in d.keys()]
    matches = get_close_matches(printer_name, ids, n=1, cutoff=0.8)
    match = ""

    if len(matches) > 0:
        match = matches[0]

    for profile in profiles:
        if idkey in profile.keys():
            if match in profile[idkey]:
                return profile['Description']

    return match


class FilterModule(object):
    def filters(self):
        return {
            'int_pub_name': int_pub_name,
            'driver_name': driver_name
        }
