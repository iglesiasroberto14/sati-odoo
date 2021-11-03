FROM odoo:14
USER root
# common y tz
RUN apt-get update && apt-get install -y tzdata iproute2 iputils-ping procps

ENV TZ=America/Buenos_Aires

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# git
RUN apt-get update && apt-get install -y git build-essential swig python3-dev python3-openssl #python-m2crypto

RUN pip3 install wheel
 
# config para afip
RUN sed -i '1iopenssl_conf = default_conf' /etc/ssl/openssl.cnf
COPY openssl.cnf /tmp/openssl.cnf
RUN cat /tmp/openssl.cnf >> /etc/ssl/openssl.cnf
RUN git clone https://www.github.com/pyar/pyafipws.git -b py3k --single-branch /tmp/pyafipws
WORKDIR /tmp/pyafipws
RUN pip3 install -r requirements.txt
RUN python3 setup.py install
RUN mkdir -p /usr/local/lib/python$(python3 --version | grep -Eo '3..')/dist-packages/pyafipws/cache
COPY odoo.conf /etc/odoo/odoo.conf

ENTRYPOINT ["/usr/bin/odoo", "-c", "/etc/odoo/odoo.conf"]
