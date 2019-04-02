Role Name
=========

This role gathers facts, extensively. It insures that each node in inventory has bidirectional execution time awareness of facts about other nodes (when this role runs)

Requirements
------------

Role Variables
--------------

Dependencies
------------

Example Playbook
----------------

    - hosts: servers
      roles:
         - { role: facts }
         - { role: networking_role_or_something }

License
-------

BSD

Author Information
------------------
