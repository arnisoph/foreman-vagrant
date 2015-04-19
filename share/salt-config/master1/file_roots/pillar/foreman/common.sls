repos:
  lookup:
    repos:
      foreman:
        url: http://deb.theforeman.org/
        keyurl: http://deb.theforeman.org/foreman.asc
        dist: wheezy
        comps:
          - nightly
      foreman_plugins:
        url: http://deb.theforeman.org/
        keyurl: http://deb.theforeman.org/foreman.asc
        dist: plugins
        comps:
          - nightly
