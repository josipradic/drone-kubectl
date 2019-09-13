FROM bitnami/kubectl:1.13
LABEL maintainer "Josip Radic <josip.radic@gmail.com>"

ENV PATH="/opt/sinlead/kubectl/bin:$PATH"
USER root

# adding support for envsubst
RUN apt-get update && apt-get install -y gettext
COPY init-kubectl kubectl /opt/sinlead/kubectl/bin/

ENTRYPOINT ["kubectl"]
CMD ["--help"]
