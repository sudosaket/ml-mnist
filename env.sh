## Namespace to be used in k8s cluster for your application
NAMESPACE=kubeflow

## Ksonnet app name
APP_NAME=mnist

## Ksonnet environment name
KS_ENV=nativek8s

## Name of the NFS Persistent Volume
NFS_PVC_NAME=nfsmw

## Used in training.bash
# Enviroment variables for mnist training job (See mnist_model.py)
TF_DATA_DIR=/mnt/data
TF_MODEL_DIR=/mnt/model
NFS_MODEL_PATH=/mnt/export
TF_EXPORT_DIR=${NFS_MODEL_PATH}

# DOCKER_BASE_URL and IMAGE below.
DOCKER_BASE_URL=gcr.io/cpsg-ai-demo
IMAGE=${DOCKER_BASE_URL}/tf-mnist-demo:v1

# Web app info
WEBAPP_FOLDER=webapp

# Docker Hub info
DOCKER_HUB=docker.io
DOCKER_USERNAME=saketmehta
DOCKER_IMAGE=ml-mnist-client