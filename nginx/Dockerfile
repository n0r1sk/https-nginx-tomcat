FROM nginx

MAINTAINER Mario Kleinsasser "mario.kleinsasser@gmail.com"
MAINTAINER Bernhard Rausch "rausch.bernhard@gmail.com"

RUN apt-get update && apt-get -y install dnsutils net-tools procps

CMD ["nginx", "-g", "daemon off;"]
