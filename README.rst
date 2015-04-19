===============
foreman-vagrant
===============

.. image:: http://img.shields.io/github/tag/bechtoldt/foreman-vagrant.svg
    :target: https://github.com/bechtoldt/foreman-vagrant/tags

.. image:: http://issuestats.com/github/bechtoldt/foreman-vagrant/badge/issue
    :target: http://issuestats.com/github/bechtoldt/foreman-vagrant

.. image:: https://api.flattr.com/button/flattr-badge-large.png
    :target: https://flattr.com/submit/auto?user_id=bechtoldt&url=https%3A%2F%2Fgithub.com%2Fbechtoldt%2Fforeman-vagrant

A Vagrant VM that uses SaltStack to setup a Foreman instance

.. contents::
    :backlinks: none
    :local:


Requirements
------------

You need:

* basic vagrant knowledge (RFTM skills are sufficient)
* Vagrant >= 1.6.5 (``$ vagrant -v``)


Workflows
---------

* salt-call state.sls tools,repos,crypto,users,postgresql.client,postgresql.server,foreman.proxy,foreman.webfrontend,httpd test=False
* set ssl paths /etc/ssl/certs/master1.foreman.local.arnoldbechtoldt.com.crt.pem
* visudo
* chmod 666 /etc/salt/autosign.conf
* add smart proxy (https://master1.foreman.local.arnoldbechtoldt.com:8443)

Additional resources
--------------------

Please see https://github.com/bechtoldt/vagrant-devenv for some more bits of information about the vagrant VM. You can use it to build the Vagrant box mention above (``DEV_Debian_78_salt_arbe_git-virtualbox-CURRENT.box``), too.


TODO
----

None
