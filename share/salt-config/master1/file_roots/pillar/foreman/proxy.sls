foreman:
  lookup:
    proxy:
      sls_include:
        - crypto.x509
      sls_extend:
        crypto-x509-key-master1.foreman.local.arnoldbechtoldt.com_key:
          file:
            - require:
              - group: foreman_proxy_user
      pkgs:
        - foreman-proxy
        #- ruby-smart-proxy-salt
      user:
        optional_groups:
          - foreman-proxy
          - ssl-cert
      config:
        settings_yaml:
          contents: |
            :daemon_pid: /var/run/foreman-proxy/foreman-proxy.pid
            :daemon: true
            :log_file: /var/log/foreman-proxy/foreman-proxy.log
            :log_level: DEBUG
            :https_port: 8443
            :ssl_certificate: /etc/ssl/certs/master1.foreman.local.arnoldbechtoldt.com.crt.pem
            :ssl_ca_file: /etc/ssl/certs/master1.foreman.local.arnoldbechtoldt.com.ca.pem
            :ssl_private_key: /etc/ssl/private/master1.foreman.local.arnoldbechtoldt.com.key.pem
            :settings_directory: /etc/foreman-proxy/settings.d
        dhcp_yaml:
          contents: |
            :enabled: false
            :dhcp_vendor: isc
            :dhcp_config: /etc/dhcp/dhcpd.conf
            :dhcp_leases: /var/lib/dhcp/dhcpd.leases
        dns_yaml:
          contents: |
            :enabled: false
        tftp_yaml:
          contents: |
            :enabled: false
            :tftproot: /srv/tftp
            :tftp_servername: master1.foreman.local.arnoldbechtoldt.com
        puppet_yaml:
          contents: |
            :enabled: false
        puppetca_yaml:
          contents: |
            :enabled: false
        bmc_yaml:
          contents: |
            :enabled: false
        salt_yaml:
          contents: |
            :enabled: true
            :autosign_file: /etc/salt/autosign.conf
            :salt_command_user: root
