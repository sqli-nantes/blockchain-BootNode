FROM httpd:2.4

ENV HOME /home
ENV GETH_DIR $HOME/geth
ENV GETH_BIN $GETH_DIR/geth-1.4.5-stable-a269a71-linux-amd64
ENV HTTPD_DIR /usr/local/apache2/htdocs
ENV NAMES_DIR $HOME/NamesJSON

RUN mkdir $GETH_DIR
RUN mkdir $NAMES_DIR

COPY geth-1.4.5-stable-a269a71-linux-amd64 $GETH_DIR
COPY current.json $HTTPD_DIR

RUN apt-get update \
  && apt-get install -y software-properties-common net-tools git curl build-essential \
  && curl -sL https://deb.nodesource.com/setup_4.x | bash \
  && apt-get update -y \
  && apt-get install -y nodejs \
  && node -v \
  && npm -v \
  && mkdir -p /root/.ethash 

RUN $GETH_BIN makedag 0 /root/.ethash 
RUN bash -c "$GETH_BIN --datadir $GETH_DIR --networkid 100 js <(echo 'console.log(admin.nodeInfo.enode)') > enode"

RUN sed -i -- 's#ETHEREUM_ENODE#'$( cat enode )'#g' $HTTPD_DIR/current.json 
RUN rm enode

COPY sendMoney.js $GETH_DIR
COPY MineOnlyWhenTx.js $GETH_DIR

COPY start.sh $HOME
RUN chmod +x $HOME/start.sh

COPY NamesJSON $NAMES_DIR
RUN cd $NAMES_DIR && npm install

EXPOSE 30303
EXPOSE 8547
EXPOSE 8081

CMD $HOME/start.sh
