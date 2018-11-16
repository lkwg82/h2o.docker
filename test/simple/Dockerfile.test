FROM test-h2o

ADD h2o.conf .
RUN mkdir -p html \
    && echo "welcome" > index.html \
    && ls -asl \
    && pwd
