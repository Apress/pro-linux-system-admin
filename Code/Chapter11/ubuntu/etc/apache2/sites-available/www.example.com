<VirtualHost *>
    ServerName www.example.com
    ServerAlias example.com
    ServerAdmin webmaster@example.com
    DocumentRoot /srv/www/www.example.com/html
    <Directory /srv/www/www.example.com/html>
        Options Indexes FollowSymLinks Includes IncludesNOEXEC SymLinksIfOwnerMatch
        AllowOverride All
    </Directory>
</VirtualHost>
