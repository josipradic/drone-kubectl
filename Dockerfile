FROM bitnami/kubectl:1.15.3
LABEL maintainer "Josip Radic <josip.radic@gmail.com>"

ENV PATH="/opt/jradic/kubectl/bin:$PATH"
USER root

# adding support for envsubst
RUN apt-get update && apt-get install -y gettext -qq > /dev/null
COPY kubectl-init kubectl /opt/jradic/kubectl/bin/

# solving permission issues
RUN mkdir -p $HOME/.kube
RUN cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
RUN chown -R $(id -u):$(id -g) $HOME/.kube

ENTRYPOINT ["kubectl"]
CMD ["--help"]
