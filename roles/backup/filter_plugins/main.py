#!/usr/bin/env python3
import os


def join(path, other):
    return os.path.join(path, other)


class FilterModule(object):
    def filters(self):
        return {
            'join': join
        }
