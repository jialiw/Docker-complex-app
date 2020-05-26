docker build -t jialiw/multi-react-client:latest -t jialiw/multi-react-client:$GIT_SHA -f ./react-client/Dockerfile ./client
docker build -t jialiw/multi-server:latest -t jialiw/multi-server:$GIT_SHA -f ./server/Dockerfile ./server
docker build -t jialiw/multi-worker:latest -t jialiw/multi-worker:$GIT_SHA -f ./worker/Dockerfile ./worker
# because we have logged into docker  - echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin 
# no need to log in again --> directly push new image to dockerhub
docker push jialiw/multi-react-client:latest
docker push jialiw/multi-server:latest
docker push jialiw/multi-worker:latest

docker push jialiw/multi-react-client:$GIT_SHA
docker push jialiw/multi-server:lat$GIT_SHA
docker push jialiw/multi-worker:$GIT_SHA

kubectl apply -f k8s # apply all configs in k8s/ folder 

# imperatively set latest images on each deployment

# however, this command will not fetch latest image
# each time running the following command, it will attach `latest` tag after multi-server
# k8s will not try to fetch new code until there is a new tag coming in
kubectl set image deployments/server-deployment server=jialiw/multi-server:$GIT_SHA
kubectl set image deployments/client-deployment client=jialiw/multi-react-client:$GIT_SHA
kubectl set image deployment/worker-deployment worker=jialiw/multi-worker:$GIT_SHA 