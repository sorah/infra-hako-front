FROM nginx:latest
RUN apt-get update && \
  apt-get install -y ruby && \
  gem install --no-document aws-sdk-s3

RUN rm /etc/nginx/conf.d/default.conf

COPY run-nginx.rb /usr/local/bin/run-nginx.rb
RUN chmod 755 /usr/local/bin/run-nginx.rb

COPY nginx.conf /etc/nginx/nginx.conf
CMD ["/usr/local/bin/run-nginx.rb"]
