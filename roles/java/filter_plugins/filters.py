#!/usr/bin/env python
from os.path import join
from os.path import abspath


def _join(path, *other):
    return join(path, *other)


def _win_escape(path):
    return path.replace('\\', '\\\\')


class FilterModule(object):
    def filters(self):
        return {
            'join': _join,
            'win_escape': _win_escape,
        }