FROM bitnami/kubectl:1.13
LABEL maintainer "Josip Radic <josip.radic@gmail.com>"

ENV PATH="/opt/jradic/kubectl/bin:$PATH"
USER root

# adding support for envsubst
RUN apt-get update && apt-get install -y gettext -qq > /dev/null
COPY kubectl-init kubectl /opt/jradic/kubectl/bin/

ENTRYPOINT ["kubectl"]
CMD ["--help"]
