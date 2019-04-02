#!/usr/bin/env python
from collections import namedtuple
from os import chdir
from subprocess import Popen
from subprocess import PIPE

from ansible.executor.task_queue_manager import TaskQueueManager
from ansible.inventory.manager import InventoryManager
from ansible.parsing.dataloader import DataLoader
from ansible.playbook import Play
from ansible.vars.manager import VariableManager


def main():
    p = Popen(["ls inventory/production"], stdin=PIPE, stdout=PIPE, shell=True)
    (out, err) = p.communicate()
    offices = out.decode("utf-8").split()

    for office in offices:
        loader = DataLoader()
        inventory = InventoryManager(
            loader=loader, sources='inventory/production/{}'.format(office)
        )
        inventory.subset("windows_workstation")
        variables = VariableManager(loader=loader, inventory=inventory)
        play_source = {
            "name": "Bootstrap Remoting",
            "hosts": "all",
            "gather_facts": "false",
            "tasks": [{
                "action": {
                    "module": "debug",
                    "msg": "Hello World!"
                }
            }]
        }

        play = Play().load(play_source, variable_manager=variables, loader=loader)
        Options = namedtuple('Options',
                             ['connection', 'module_path', 'forks', 'become', 'become_method', 'become_user', 'check',
                              'diff'])
        options = Options(connection='local', module_path=None, forks=10, become=None, become_method=None,
                          become_user=None, check=False, diff=False)
        tqm = None

        try:
            tqm = TaskQueueManager(
                inventory=inventory,
                variable_manager=variables,
                loader=loader,
                run_tree=False,
                passwords=None,
                options=options
            )
            result = tqm.run(play)
            print(result)
        finally:
            if tqm is not None:
                tqm.cleanup()


if __name__ == "__main__":
    workdir = "/home/cacampbell/PycharmProjects/ansible"
    chdir(workdir)
    main()
