FROM swipl/swipl:latest
MAINTAINER Ilan Pillemer @ilanpillemer

ADD ./target /application/

COPY ./startup.sh /application/startup.sh
RUN chmod +x /application/startup.sh
RUN chmod +x /application/application.pl

EXPOSE 9090

CMD ["/application/startup.sh"]
