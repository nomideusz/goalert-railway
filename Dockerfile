FROM goalert/goalert:latest

# --chmod avoids a RUN layer (and any USER juggling) on the upstream image.
COPY --chmod=0755 railway-entrypoint.sh /railway-entrypoint.sh

ENTRYPOINT ["/railway-entrypoint.sh"]
