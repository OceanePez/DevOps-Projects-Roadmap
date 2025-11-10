# Static-Site-Server

# Installation

    Register and setup a remote linux server on any provider e.g. a simple droplet on DigitalOcean which gives you $200 in free credits with the link. Alternatively, use AWS or any other provider.

    Make sure that you can connect to your server using SSH.

    Install and configure nginx to serve a static site.

    Create a simple webpage with basic HTML, CSS and image files.

    Use rsync to update a remote server with a local static site.

    If you have a domain name, point it to your server and serve your static site from there. Alternatively, set up your nginx server to serve the static site from the server's IP address.

You can write a script deploy.sh which when you run will use rsync to sync your static site to the server.

Once you have completed the project, you should have a basic understanding of how to setup a web server using a basic static site served using Nginx. You should also have a basic understanding of how to use rsync to deploy your changes to the server.

### Commandes

sudo apt update
sudo apt install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx

Set up your static site directory
sudo mkdir -p /var/www/mysite
sudo chown -R ubuntu:ubuntu /var/www/mysite

rsync -avz -e "ssh -i ~/path/to/your-key.pem" --delete ~/my-static-site/ ubuntu@<your-ec2-ip>:/var/www/mysite/

### Notes

chmod 400 static-server.pem
