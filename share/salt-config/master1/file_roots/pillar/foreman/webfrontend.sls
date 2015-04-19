foreman:
  lookup:
    webfrontend:
      user:
        optional_groups:
          - foreman
          - foreman-proxy
          - ssl-cert
      config:
        manage:
          - database_yaml
          - settings_yaml
        database_yaml:
          content: |
            production:
              host: 127.0.0.1
              adapter: postgresql
              database: foreman
              username: foreman
              password: 4mH05J-iSFdNcYIDCOzr7zuaF81K9pva

        settings_yaml:
          content: |
            unattended: true
            puppetconfdir: /etc/puppet/puppet.conf
            login: true
            require_ssl: false
            locations_enabled: false
            organizations_enabled: false

            # The following values are used for providing default settings during db migrate
            oauth_active: true
            oauth_map_users: true
            oauth_consumer_key: foo
            oauth_consumer_secret: bar
#    plugins:
#      manage:
#        - salt



httpd:
  lookup:
    ssl_include:
      - crypto.x509
    mods:
      modules:
        passenger:
          manage: True
        headers:
          manage: True
        rewrite:
          manage: True
        ssl:
          manage: True
          config:
            contents: |
              SSLRandomSeed startup builtin
              SSLRandomSeed startup file:/dev/urandom 512
              SSLRandomSeed connect builtin
              SSLRandomSeed connect file:/dev/urandom 512

              AddType application/x-x509-ca-cert .crt
              AddType application/x-pkcs7-crl    .crl

              SSLPassPhraseDialog builtin

              SSLSessionCache shmcb:${APACHE_RUN_DIR}/ssl_scache(512000)
              SSLSessionCacheTimeout  300

              SSLMutex file:${APACHE_RUN_DIR}/ssl_mutex

              SSLHonorCipherOrder On
              SSLCipherSuite ECDHE-RSA-AES128-SHA256:AES128-GCM-SHA256:HIGH:!MD5:!aNULL:!EDH:!RC4

              SSLProtocol all -SSLv2 -SSLv3
        userdir:
          manage: True
          enable: False
        status:
          manage: True
          enable: False
        autoindex:
          manage: True
          enable: False
        proxy:
          manage: True
        proxy_http:
          manage: True
  configs_absent:
    - /etc/apache2/conf.d/charset
    - /etc/apache2/conf.d/localized-error-pages
    - /etc/apache2/conf.d/other-vhosts-access-log
    - /etc/apache2/conf.d/security
  vhosts:
    default:
      ensure: absent
      linkname: 000-default
    default_ssl:
      name: default-ssl
      ensure: absent
    foreman:
      contents: |
        <VirtualHost *:80>
          ServerName master1.foreman.local.arnoldbechtoldt.com
          ServerAlias foreman

          #RewriteEngine On
          #RewriteCond %{HTTPS} !=on
          #RewriteRule ^/?(.*) https://%{SERVER_NAME}/$1 [R,L]

          DocumentRoot /usr/share/foreman/public

          PassengerAppRoot /usr/share/foreman
          AddDefaultCharset UTF-8

          <Directory /usr/share/foreman/>
            Options SymLinksIfOwnerMatch
            AllowOverride None
            Order allow,deny
            Allow from all
          </Directory>

          <Directory /usr/share/foreman/public/assets>
            # Use standard http expire header for assets instead of ETag
            <IfModule mod_expires.c>
              Header unset ETag
              FileETag None
              ExpiresActive On
              ExpiresDefault "access plus 1 year"
            </IfModule>

            # Return compressed assets if they are precompiled
            <IfModule mod_rewrite.c>
              RewriteEngine on
              # Make sure the browser supports gzip encoding and file with .gz added
              # does exist on disc before we rewrite with the extension
              RewriteCond %{HTTP:Accept-Encoding} \b(x-)?gzip\b
              RewriteCond %{REQUEST_FILENAME}.gz -s
              RewriteRule ^(.+) $1.gz [L]
              # Set headers for all possible assets which are compressed
              <FilesMatch \.css\.gz$>
                ForceType text/css
                Header set Content-Encoding gzip
                SetEnv no-gzip
              </FilesMatch>
              <FilesMatch \.js\.gz$>
                ForceType text/javascript
                Header set Content-Encoding gzip
                SetEnv no-gzip
              </FilesMatch>
            </IfModule>
          </Directory>

          ErrorLog /var/log/apache2/master1.foreman.local.arnoldbechtoldt.com_error.log
          CustomLog /var/log/apache2/master1.foreman.local.arnoldbechtoldt.com_access.log combined
        </VirtualHost>
    foreman_ssl:
      contents: |
        <VirtualHost *:443>
          ServerName master1.foreman.local.arnoldbechtoldt.com
          ServerAlias foreman

          DocumentRoot /usr/share/foreman/public

          PassengerAppRoot /usr/share/foreman
          AddDefaultCharset UTF-8

          ## SSL
          SSLEngine on
          SSLCertificateFile      /etc/ssl/certs/master1.foreman.local.arnoldbechtoldt.com.crt.pem
          SSLCertificateKeyFile   /etc/ssl/private/master1.foreman.local.arnoldbechtoldt.com.key.pem
          SSLCertificateChainFile /etc/ssl/certs/master1.foreman.local.arnoldbechtoldt.com.ca.pem
          SSLCACertificatePath    /etc/ssl/certs
          SSLCACertificateFile    /etc/ssl/certs/master1.foreman.local.arnoldbechtoldt.com.ca.pem
          SSLVerifyClient         optional
          SSLVerifyDepth          3
          SSLOptions +StdEnvVars

          Header always set Strict-Transport-Security "max-age=31556926;includeSubdomains"

          <Directory /usr/share/foreman/>
            Options SymLinksIfOwnerMatch
            AllowOverride None
            Order allow,deny
            Allow from all
          </Directory>

          #<Directory /usr/share/foreman/public>
          #  Options SymLinksIfOwnerMatch
          #  AllowOverride None
          #  Order allow,deny
          #  Allow from all
          #</Directory>

          <Directory /usr/share/foreman/public/assets>
            # Use standard http expire header for assets instead of ETag
            <IfModule mod_expires.c>
              Header unset ETag
              FileETag None
              ExpiresActive On
              ExpiresDefault "access plus 1 year"
            </IfModule>

            # Return compressed assets if they are precompiled
            <IfModule mod_rewrite.c>
              RewriteEngine on
              # Make sure the browser supports gzip encoding and file with .gz added
              # does exist on disc before we rewrite with the extension
              RewriteCond %{HTTP:Accept-Encoding} \b(x-)?gzip\b
              RewriteCond %{REQUEST_FILENAME}.gz -s
              RewriteRule ^(.+) $1.gz [L]
              # Set headers for all possible assets which are compressed
              <FilesMatch \.css\.gz$>
                ForceType text/css
                Header set Content-Encoding gzip
                SetEnv no-gzip
              </FilesMatch>
              <FilesMatch \.js\.gz$>
                ForceType text/javascript
                Header set Content-Encoding gzip
                SetEnv no-gzip
              </FilesMatch>
            </IfModule>
          </Directory>

          ErrorLog /var/log/apache2/master1.foreman.local.arnoldbechtoldt.com_error.log
          CustomLog /var/log/apache2/master1.foreman.local.arnoldbechtoldt.com_access.log combined
        </VirtualHost>
