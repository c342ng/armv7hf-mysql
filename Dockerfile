from armhf/debian
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
COPY ./sources.list /etc/apt/
RUN apt-get update
RUN apt-get install -y wget build-essential libncurses5-dev cmake bison

WORKDIR /tmp/
RUN wget -q http://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-boost-5.7.12.tar.gz \
	&& tar -xzf mysql-boost-5.7.12.tar.gz \
	&& rm -rf mysql-boost-5.7.12.tar.gz

RUN groupadd mysql && useradd -r -g mysql -s /bin/false mysql
RUN rm -rf /opt/mysql && mkdir /opt/mysql 
VOLUME /var/lib/mysql

WORKDIR /tmp/mysql-5.7.12 

RUN cmake . -DCMAKE_INSTALL_PREFIX=/opt/mysql \
-DMYSQL_DATADIR=/data/mysql \
-DDOWNLOAD_BOOST=1 \ 
-DWITH_BOOST=./boost \
-DSYSCONFDIR=/etc \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 \
-DWITH_FEDERATED_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DENABLED_LOCAL_INFILE=1 \
-DENABLE_DTRACE=0 \
-DDEFAULT_CHARSET=utf8mb4 \
-DDEFAULT_COLLATION=utf8mb4_general_ci \
-DWITH_EMBEDDED_SERVER=1
RUN make && make install
