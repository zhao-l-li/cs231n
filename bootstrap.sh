#!/bin/sh

### define functions
check_for_containers(){
  local notebook_up=1 #assument container is not up yet

  docker-compose port notebook 8888
  chat_up=$?

  if [ $notebook_up -eq 0 ]; then
    return 0
  else
    return 1
  fi
}

wait_for_containers(){
  local containers_up=1 #assume all containers are not up yet
  until [ $containers_up -eq 0 ]
    do
      check_for_containers
      containers_up=$?
    done
}

abracadabra(){
  wait_for_containers
  xdg-open http://localhost:$(docker-compose port notebook 8888 | cut -d: -f2) > /dev/null 2>&1
}
### define functions:end

### start script
echo "downloading assignment files"
git submodule init
git submodule update
echo "finished downloading assignment files"

echo "downloading assignment1 dataset"
cd assignment1/cs231n/datasets/
./get_datasets.sh
cd ../../..
echo "assignment1 dataset downloaded"

echo "bringing up notebook"
docker-compose up
abracadabra
echo "notebook ready at:"
echo "http://localhost:$(docker-compose port notebook 8888 | cut -d: -f2)"
echo "trying to open the notebook in your browser"
echo "thank you; come again"
### start script:end

