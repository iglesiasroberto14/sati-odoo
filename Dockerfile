FROM ubuntu

RUN apt-get update && apt-get install -y tzdata iproute2 iputils-ping procps

ENV TZ=America/Buenos_Aires

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y python3 python3-pip postgresql-common git

RUN apt-get install -y python3-pypdf2 python3-dateutil python3-feedparser \
python3-ldap python3-lxml python3-mako python3-openid \
python3-psycopg2 python3-babel python3-pydot python3-pyparsing \
python3-reportlab python3-simplejson python3-tz python3-vatnumber python3-vobject \
python3-webdav python3-werkzeug python3-xlwt python3-yaml \
python3-docutils python3-psutil python3-mock python3-unittest2 python3-jinja2 \
python3-decorator python3-requests python3-passlib python3-pil

RUN apt-get install -y libpq-dev python3-dev libssl-dev libsasl2-dev libldap2-dev

RUN pip3 install PyPDF2 Werkzeug==0.11.15 python-dateutil reportlab \
psycopg2-binary

RUN apt install -y npm

RUN ln -s /usr/bin/nodejs /usr/bin/node || echo Ok

RUN npm install -g less less-plugin-clean-css

RUN apt-get install -y node-less

RUN adduser --system --home=/opt/odoo --group odoo

RUN git clone https://www.github.com/odoo/odoo --depth 1 --branch 14.0 --single-branch /opt/odoo

WORKDIR /opt/odoo

RUN  pip3 install -r requirements.txt

ENTRYPOINT ["/opt/odoo/odoo-bin"]
