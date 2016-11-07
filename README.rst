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

Decrypting vaults
~~~~~~~~~~~~~~~~~

If during developement one needs to change (or look at) vault files this command can be used::

  ansible-vault decrypt --vault-password-file=password.txt path/to/vaultfile

Similarly the file can be reencrypted after a change::

  ansible-vault decrypt --vault-password-file=password.txt path/to/vaultfile

Please note that reencryption will change the encrypted file,
even if nothing changed in the decrypted version.
If no change was made it is better to checkout the original again::

  git checkout path/to/vaultfile

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
