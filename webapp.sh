# read common variables (between installation, training, and serving)
source env.sh

# define new variables
CLIENT_IMAGE=${DOCKER_HUB}/${DOCKER_USERNAME}/${DOCKER_IMAGE}
MNIST_SERVING_IP=`kubectl -n ${NAMESPACE} get svc/mnist --output=jsonpath={.spec.clusterIP}`

# docker authorization
if [ "${DOCKER_HUB}" = "docker.io" ]
then
    sudo docker login
fi

# move to webapp folder
cd ${WEBAPP_FOLDER}

# build an image passing correct IP and port
sudo docker build . --no-cache  -f Dockerfile -t ${CLIENT_IMAGE}
sudo docker push ${CLIENT_IMAGE}

# move to ksonnet project
cd ../${APP_NAME}

ks generate tf-mnist-client tf-mnist-client --mnist_serving_ip=${MNIST_SERVING_IP} --image=${CLIENT_IMAGE}

ks apply ${KS_ENV} -c tf-mnist-client

# ensure that all pods are running in the namespace set in variables.bash.
kubectl get pods -n ${NAMESPACE}

# get IP address
kubectl get svc/tf-mnist-client -n ${NAMESPACE} -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
