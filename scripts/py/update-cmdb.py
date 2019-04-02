#!/usr/bin/env python
import os
from subprocess import call


def cmdb(filename):
    (head, tail) = os.path.split(filename)
    (directory, hub) = os.path.split(head)
    call(["ansible", "-i", filename, "-m", "setup", "--tree", "CMDB/{}-cmdb/".format(hub), "all"])

    with open("CMDB/{}.html".format(hub), "w+") as output:
        call(["ansible-cmdb", "{}-cmdb/".format(hub)],
             stdout=output, cwd="CMDB")


def main():
    for (root, directories, filenames) in os.walk("inventory/production/"):
        for filename in filenames:
            abs_filename = os.path.join(root, filename)

            if filename == "hosts.yml":
                cmdb(abs_filename)


if __name__ == "__main__":
    main()
