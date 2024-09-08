
###################################################
# Docker image of an Apache httpd 2.4 installation
# for use in the WebSec course lab.
#
# This image is not intended for production use!
#
# Christoph Ludwig, 2015
#
FROM httpd:2.4.12

#
# Install man2html and copy the man.sh script into the image
#
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
                 man2html-base \
                 manpages \
                 manpages-dev \
    && rm -r /var/lib/apt/lists/* 

#
# copy statically served files & CGI scripts into the image
#
ENV HTDOCS_PREFIX /var/www/
ENV CGI_PREFIX /usr/lib/cgi-bin/
#
RUN rm -rf "$HTDOCS_PREFIX" "$CGI_PREFIX" \
    && mkdir -p "$HTDOCS_PREFIX" "$CGI_PREFIX"
COPY ./htdocs/ "$HTDOCS_PREFIX"
COPY ./cgi-bin/ "$CGI_PREFIX"
RUN chown -R www-data:www-data "$HTDOCS_PREFIX" "$CGI_PREFIX"

#
# make sure /var/log/apache2/ exists and is empty
#
ENV HTTPD_LOG_DIR /var/log/apache2
RUN rm -rf $HTTPD_LOG_DIR \
    && mkdir -p $HTTPD_LOG_DIR \
    && chown root:root $HTTPD_LOG_DIR

#
# copy httpd configuration into the image
#
WORKDIR $HTTPD_PREFIX
RUN rm -rf conf/*
COPY ./conf/ conf/

EXPOSE 80 443
