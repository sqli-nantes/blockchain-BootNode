FROM httpd:2.4

ENV HOME /home
ENV GETH_DIR $HOME/geth
ENV GETH_BIN $GETH_DIR/geth-1.4.5-stable-a269a71-linux-amd64
ENV HTTPD_DIR /usr/local/apache2/htdocs
ENV BUILD_FILE build.sh 
ENV NAMES_DIR $HOME/NamesJSON

RUN mkdir $GETH_DIR
RUN mkdir $NAMES_DIR

COPY geth-1.4.5-stable-a269a71-linux-amd64 $GETH_DIR
COPY genesis.json $GETH_DIR
COPY current.json $HTTPD_DIR
COPY $BUILD_FILE $BUILD_FILE
RUN chmod +x $BUILD_FILE

RUN echo "nameserver 10.33.44.43" >> /etc/resolv.conf && echo "nameserver 10.234.1.79" >> /etc/resolv.conf && ./$BUILD_FILE
RUN rm ./$BUILD_FILE

COPY sendMoney.js $GETH_DIR
COPY MineOnlyWhenTx.js $GETH_DIR

COPY start.sh $HOME
RUN chmod +x $HOME/start.sh

COPY NamesJSON $NAMES_DIR

EXPOSE 30303
EXPOSE 8547
EXPOSE 8081

CMD $HOME/start.sh
