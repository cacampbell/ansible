#!/usr/bin/env python


def merge_args(dataset_list):
    args = ""

    for dataset in dataset_list:
        name = "{}-latest.osm.sort.pbf".format(dataset.strip())
        args += " --rb {}".format(name)

    merge_count = len(dataset_list) - 1
    for i in range(1, merge_count):
        args += " --merge"

    return(args)


class FilterModule(object):
    def filters(self):
        return {
            'merge_command_arguments': merge_args
        }
