#!/usr/bin/env python3
import os
import base64


def win_join(path, other):
    return os.path.join(path, other).replace("/", "\\")


def b64data(path):
    with open(path, "rb") as image:
        return str(base64.b64encode(image.read()), 'utf-8')


class FilterModule(object):
    def filters(self):
        return {
            'win_join': win_join,
            'b64data': b64data
        }
