# https-nginx-tomcat
Showcase Docker build and compose project for Nginx https reverse load balancer for Apache Tomcat

# Warning
Do not use this project for productive usage. The code, the configuration and the SSL certificates are spread to the public. This is a showcase project which helps to understand the blog post on [our web site](https://www.n0r1sk.com/index.php/2017/07/07/nginx-reverse-proxy-with-ssl-offloading-and-apache-tomcat-backends/)!

# General information

It seems that a lot of people out there have problems to connect a Nginx load balancer in SSL mode with an Apache Tomcat as backend service. Therefore we decide to share our experiences.

# Nginx information

# Apache Tomcat information

# Web application information

Since we are not web developers (we are Ops), we took the web application code from [this site](https://pubs.vmware.com/vfabric52/index.jsp#com.vmware.vfabric.tc-server.2.8/getting-started/tutwebapp-creating-deploying.html). We made slight modifications to the ```web.xml``` file and to the ```Hello.java``` to fit our needs for this showcase project.

## Build

To build the web application you will need **Java** and **Ant**!
