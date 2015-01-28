# odoo-vagrant

Use Odoo inside a virtual machine, which is preconfigured with all the needed dependencies such as
PostgreSQL, python, git, ...

The goal is to be able to buildout an Odoo project (with the recipe from anybox for zc.buildout) that is shared
between the developper's machine and the virtual machine.  
The developer can then modify the code with the IDE of his choice on his local machine, and buildout and run Odoo
in the virtual machine.

At Taktik, we do it with the Vagrant support inside PyCharm that enables us to define a python remote interpreter
and creating run configurations using this interpreter to be able to launch a buildout or Odoo inside the virtual machine
from the local machine.

The default Odoo port (8069) is forwarded to the local machine to 8888.
The default PostgreSQL port (5432) is forwarded to 5454.

## Dependencies

You will need to install Vagrant: https://www.vagrantup.com  
and VirtualBox: https://www.virtualbox.org/

## Shared folders

In order to access the Odoo buildout inside the virtual machine, you can add a synced folder in the Vagrantfile, e.g.:

    config.vm.synced_folder "/Users/myself/projects/my_buildout", "/my_buildout", type: "nfs"

## SSH keys

If you need a specific SSH key inside the virtual machine, simply drop it in the templates folder
(templates/id_rsa and templates/id_rsa.pub).

## Git configuration

If you need git, you can add these two lines at the end of the provisionning script, vagrant_bootstrap.sh:

    sudo -Hu vagrant git config --global user.email "user@mail.com"
    sudo -Hu vagrant git config --global user.name "User Name"

