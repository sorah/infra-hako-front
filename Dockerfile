FROM nginx:mainline

RUN apt-get update
  && apt-get install --no-install-recommends -y ruby ca-certificates
  && gem install --no-document aws-sdk-s3
  && apt-get remove --purge --auto-remove -y
  && rm -rf /var/lib/apt/lists/*

RUN rm /etc/nginx/conf.d/default.conf

COPY run-nginx.rb /usr/local/bin/run-nginx.rb
RUN chmod 755 /usr/local/bin/run-nginx.rb

COPY nginx.conf /etc/nginx/nginx.conf
CMD ["/usr/local/bin/run-nginx.rb"]
