Server config
=============
Configure all our servers with ansible.

Dependencies
------------

* ``Vagrant`` (for testing)
* ``ansible`` > 2.0
* the password for the vault in the file ``password.txt``

Testing
-------

One can test the configuration with vagrant.

::

  # To start testing:
  $ vagrant up

  # provision after changes:
  $ vagrant provision

  # finish testing:
  $ vagrant destroy -f

  # Test using ansible directly:
  $ ansible-playbook -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory all.yml  --vault-password-file=./password.txt

Provisioning
------------

Use the ``deploy.sh``-script or execute

::

  ansible-playbook all.yml --vault-password-file ./password.txt

**Note**: Ansible uses the local user as default. Use ``-u <USER>`` to override


Known Issues
------------

User does not exist
~~~~~~~~~~~~~~~~~~~
On a fresh installed server, the user in the inventory might not yet exist.
One can run the playbook and use the following command to provision the missing server::

  $ ansible-playbook --vault-password-file=./password.txt --limit @all.retry -u root all.yml

If the inventory defines a user, one cannot use ``-u`` to override the user. Use ``-e "ansible_ssh_user=root"`` instead.
