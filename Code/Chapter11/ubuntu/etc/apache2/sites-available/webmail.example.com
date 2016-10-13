<IfModule mod_ssl.c>
    <VirtualHost 192.168.0.220:443>
        ServerName webmail.example.com
        ServerAdmin webmaster@example.com
        DocumentRoot /srv/www/webmail.example.com/html
        <Directory /srv/www/webmail.example.com/html>
            Options FollowSymLinks Includes IncludesNOEXEC SymLinksIfOwnerMatch
            AllowOverride All
        </Directory>
        SSLEngine on
        SSLCertificateFile /srv/www/webmail.example.com/ssl/webmail.example.com.cert
        SSLCertificateKeyFile /srv/www/webmail.example.com/ssl/webmail.example.com.key
        SSLCACertificateFile /etc/CA/cacert.pem
    </VirtualHost>
</IfModule>
