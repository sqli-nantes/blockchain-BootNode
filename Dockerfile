FROM httpd:2.4

ENV HOME /home
ENV DAG_DIR $HOME/.ethash
ENV GETH_DIR $HOME/geth
ENV HTTPD_DIR /usr/local/apache2/htdocs
ENV BUILD_FILE build.sh 

RUN mkdir $GETH_DIR

COPY genesis.json $GETH_DIR
COPY current.json $HTTPD_DIR
COPY $BUILD_FILE $BUILD_FILE
RUN chmod +x $BUILD_FILE

RUN ./$BUILD_FILE
RUN rm ./$BUILD_FILE


COPY start.sh $HOME

RUN chmod +x $HOME/start.sh

EXPOSE 30303
EXPOSE 8545

CMD $HOME/start.sh