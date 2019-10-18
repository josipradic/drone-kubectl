# Drone kubectl with envsubst support
[![Build Status](https://img.shields.io/docker/stars/josipradic/drone-kubectl)](https://hub.docker.com/r/josipradic/drone-kubectl) [![Build Status](https://img.shields.io/docker/pulls/josipradic/drone-kubectl)](https://hub.docker.com/r/josipradic/drone-kubectl) [![Build Status](https://img.shields.io/docker/cloud/automated/josipradic/jenkins-jnlp-cicd)](https://hub.docker.com/r/josipradic/drone-kubectl) [![Build Status](https://img.shields.io/docker/cloud/build/josipradic/jenkins-jnlp-cicd)](https://hub.docker.com/r/josipradic/drone-kubectl) [![Build Status](https://img.shields.io/github/v/tag/josipradic/drone-kubectl)](https://github.com/josipradic/drone-kubectl/releases)

This [Drone](https://drone.io/) plugin allows you to use `kubectl` without messing around with the authentication

## Changes

This fork is installing `gettext` so the [`envsubst`](https://linux.die.net/man/1/envsubst) command is available for substituting env vars in `.yaml` template files. It also includes a fix that is preventing to throw the `kubectl` messages in `stdout` when context, namespace and default user are set for the first time.

## Usage

```yaml
# drone 1.0 syntax
kind: pipeline
type: docker
name: deploy

steps:
  - name: deploy
    image: josipradic/drone-kubectl
    settings:
      kubernetes_server:
        from_secret: k8s_server
      kubernetes_cert:
        from_secret: k8s_cert
      kubernetes_token:
        from_secret: k8s_token
    commands:
      - kubectl create -f job_foo.yaml
      - kubectl wait --for=condition=complete -f job_foo.yaml

```

## How to get the credentials

First, you need to have a service account with **proper privileges** and **service-account-token**:
```bash
kubectl create sa --namespace kube-system deploy
kubectl create clusterrolebinding deploy --clusterrole cluster-admin --serviceaccount=kube-system:deploy
```

You can find out your server URL which looks like `https://xxx.xxx.xxx.xxx` by the command:
```bash
kubectl config view -o jsonpath='{range .clusters[*]}{.name}{"\t"}{.cluster.server}{"\n"}{end}'
```

If the service account is `deploy`, you would have a secret named `deploy-token-xxxx` (xxxx is some random characters).
You can get your token and certificate by the following commands:

cert:
```bash
kubectl get secret deploy-token-xxxx -o jsonpath='{.data.ca\.crt}' && echo
```
token:
```bash
kubectl get secret deploy-token-xxxx -o jsonpath='{.data.token}' | base64 --decode && echo
```

You can build this container using `docker build` or `docker-compose`, just be sure to provide all needed env vars to build command, or create `.env` file from `.env.example`.

```bash
# from root of the directory
docker build --rm -t kubectl .
docker run --rm -e <env-vars> -e <env-vars> ... kubectl config view

# by docker-compose
docker-compose run --rm kubectl cluster-info
docker-compose run --rm kubectl config view
```

### Special thanks

Inspired by:
- [drone-kubernetes](https://github.com/honestbee/drone-kubernetes)
- [drone-kubectl](https://github.com/sinlead/drone-kubectl)
