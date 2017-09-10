# https-nginx-tomcat
Showcase Docker build and compose project for Nginx https reverse load balancer for Apache Tomcat

# Warning
Do not use this project for productive usage. The code, the configuration and the SSL certificates are spread to the public. This is a showcase project which helps to understand the blog post on [our web site](https://www.n0r1sk.com/ssl-offloading-nginx-apache-tomcat-showcase/)!

# General information

It seems that a lot of people out there have problems to connect a Nginx load balancer in SSL mode with an Apache Tomcat as backend service. Therefore we decide to share our experiences.

# Startup instruction
After you have cloned this Github repository you will find a script called ```start-compose.sh``` there. This script is important because it will let you set the ip address of your local Docker host inside the ```nginx.conf``` file. This is an absolute must to get this showcase running. Why? Read on under the ```Background information``` section.

Usage:
```
# use your ip address
./start-compose.sh 192.168.0.1
```

# Background information

There are different ways on how to startup Docker images to get running containers. If it comes to services there are basically three different ways to do it. The same is true for this showcase. Each way has its benefits and traps.

## Docker compose (default for this showcase)
If you start this showcase with the ```start-compose.sh``` it will replace the placeholder in the file ```nginx/conf/nginx.conf```, called ```BACKENDIP``` with the given ip address. This is needed because if you start the Docker compose on the localhost, inside the nginx.conf you have to specify the ```BACKENDIP``` because by default, Docker uses ```NAT``` (network address translation) to connect your service to the outher world.

As you can see in the ```docker-compose.yml``` in this repository, there is specified, that the Apache Tomcat should be mapped to port ```11111``` outside to ```8080``` inside.

## net=local
You can start all containers with ```docker run --net=host ...```. In this case, the services will use your localhost ip address and will bind the conatiner ports to your host network interfaces. This means, that if you choose this way, the Nginx will use port 80 and 443 and the Apache Tomcat will run on port 8080! In this case you have to change the ```BACKENDIP``` in ```nginx/conf/nginx.conf``` to ```yourlocalip:8080``` to get this showcase up and running.

## Docker swarm
You can use Docker swarm to connect the Nginx with the Apache Tomcat backend. This means, that both containers, Nginx and Apache Tomcat, are running on the same overlay network. Only the Nginx will be connected to the outside world, the Apache Tomcat would not be reachable from the outside but from the Nginx. The problem herein is, that the Apache Tomcat container will get a new ip-address each time the Docker swarm service will be updated. Therefore you need a dynamic mapping solution. Use ```Traefik``` [link](traefik.io) or for example our border controller [link](https://github.com/n0r1sk/border-controller). This solutions will map the backend servers dynamically.

# Nginx information

**Important**: You have to make a hosts or dns entry according to your local setup. For example a ```hosts.conf``` entry:

```
127.0.0.1 https-nginx-tomcat.com
```

For Nginx it is important that you enable the following configuration inside the ```nginx.conf``` in the location section.

```
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-Server $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Real-IP $remote_addr;
```

For this showcase we use the fake domain ```https-nginx-tomcat.com```. The certificate is valid for 10 years. DO NOT USE THIS IN PRODUCTION!

# Apache Tomcat information

In the Apache Tomcat configuration you have to add the following lines to the ```server.xml``` in the connector section:

```
     scheme="https"
	   secure="true"
	   proxyPort="443"
```

# Web application information

In the web application you have to modify the ```web.xml``` according to the following example to enable the needed filters:

```
<filter>
    <filter-name>RemoteIpFilter</filter-name>
    <filter-class>org.apache.catalina.filters.RemoteIpFilter</filter-class>
    <init-param>
        <param-name>protocolHeader</param-name>
        <param-value>x-forwarded-proto</param-value>
    </init-param>
</filter>

<filter-mapping>
    <filter-name>RemoteIpFilter</filter-name>
    <url-pattern>/*</url-pattern>
    <dispatcher>REQUEST</dispatcher>
</filter-mapping>
```

# In the end, show me how it looks like

If you open your browser and point it to [http://https-nginx-tomcat.com](http://https-nginx-tomcat.com) you will be automatically redirected to https://https-nginx-tomcat.com/hello. Look inside the ```nginx.conf```. After you accept the self issued certificate you should see the following page, which shows you, that https is working and the Apache Tomcat is seeing the correct protocol header. (look at https in the text on the site)

![screenshot](https://github.com/n0r1sk/https-nginx-tomcat/raw/master/screenshot.png)
