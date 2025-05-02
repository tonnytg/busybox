# BusyboxTg

This is my busybox with tools I need


# Tools List

- curl
- neovim
- mtr
- python3
- gcloud
- gsutil
- nvm
- screen
- tmux
- terraform
- terrascan
- tflint
- terracost
- go
- htop
- tcpdump
- nc
- postgres-client
- kubectl

# How to use


### Docker Local
Call `docker run`

```
    docker run -it --rm --name busyboxtg tonnytg/busyboxtg:latest bash
```


### Kubernetes

```
kubectl run busyboxtg \
  --image=tonnytg/busyboxtg:latest \
  --restart=Never \
  --rm -it -- bash
```
