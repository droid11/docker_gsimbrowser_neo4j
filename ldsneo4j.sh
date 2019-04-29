#!/usr/bin/env bash

rm -rf gsim-raml-schema
git clone git@github.com:statisticsnorway/gsim-raml-schema.git
docker run -v "$(pwd)/gsim-raml-schema:/raml-project" statisticsnorway/raml-to-jsonschema:latest

echo Creating conf folder
mkdir -p conf
printf "namespace.default=data\n" > conf/application.properties

ENV_FILE='ldsneo4j-compose.env'
if [ -f $ENV_FILE ]; then
    source $ENV_FILE
fi

#echo "Cleaning existing associated volumes and data"
#docker-compose -f ldsneo4j-compose.yml down
#docker volume rm $(docker volume ls -q -f "name=ldsneo4j")

LDS_NETWORK=$(docker network ls -f name=ldsneo4jstandalonetest -q)
if [ "$LDS_NETWORK" == "" ]; then
    echo Create network
    docker network create ldsneo4jstandalonetest
fi

echo Starting LDS neo4j
docker-compose -f ldsneo4j-compose.yml up -d --force-recreate
#docker-compose -f ldsneo4j-compose.yml up -d
