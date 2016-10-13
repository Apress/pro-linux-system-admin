<VirtualHost *>
    ServerName cacti.example.com
    ServerAdmin webmaster@example.com
    DocumentRoot /srv/www/cacti.example.com/html
    <Directory /srv/www/cacti.example.com/html>
        Options Indexes FollowSymLinks Includes IncludesNOEXEC SymLinksIfOwnerMatch
        AllowOverride All
    </Directory>
</VirtualHost>
