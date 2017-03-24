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
  $ ansible-playbook -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory all.yml


Vaults
-------

Some values should not be visible to the public. For these ansible allows for encrypted files (and single values).

In this repository, a `script <bin/open_the_vault.sh>`_ and a `gpg-rencrypted passphrase <vault_passphrase.gpg>`_ is used.

  **As the script is called via a variable in the `ansible.cfg <ansible.cfg>`_, all ansible commands need to be run from the top of this git repository!**

Decrypting vaults
~~~~~~~~~~~~~~~~~

If during developement one needs to change (or look at) vault files this command can be used::

  ansible-vault decrypt path/to/vaultfile

Similarly the file can be reencrypted after a change::

  ansible-vault encrypt path/to/vaultfile

Please note that reencryption will change the encrypted file,
even if nothing changed in the decrypted version.
If no change was made it is better to checkout the original again::

  git checkout path/to/vaultfile

Provisioning
------------

Use the ``bin/deploy.sh``-script or execute

::

  ansible-playbook all.yml

**Note**: Ansible uses the local user as default. Use ``-u <USER>`` to override


Known Issues
------------

User does not exist
~~~~~~~~~~~~~~~~~~~
On a fresh installed server, the user in the inventory might not yet exist.
One can run the playbook and use the following command to provision the missing server::

  $ ansible-playbook --limit @all.retry -u root all.yml

If the inventory defines a user, one cannot use ``-u`` to override the user. Use ``-e "ansible_ssh_user=root"`` instead.
