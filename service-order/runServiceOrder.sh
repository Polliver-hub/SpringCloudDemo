#!/bin/bash

# Сборка проекта
../gradlew :service-order:build

# Загрузка Docker образа
docker load --input build/jib-image.tar

# Остановка старых контейнеров, если они запущены
docker stop service-order-1
docker stop service-order-2

# Запуск первого контейнера на порту 8091
docker run --rm -d --name service-order-1 \
--memory=256m \
--cpus 1 \
-p 8091:8091 \
-e JAVA_TOOL_OPTIONS="-XX:InitialRAMPercentage=80 -XX:MaxRAMPercentage=80" \
-e SPRING_APPLICATION_INSTANCE_ID="i1" \
-e SERVER_PORT=8091 \
localrun/service-order:latest

# Запуск второго контейнера на порту 8092
docker run --rm -d --name service-order-2 \
--memory=256m \
--cpus 1 \
-p 8092:8092 \
-e JAVA_TOOL_OPTIONS="-XX:InitialRAMPercentage=80 -XX:MaxRAMPercentage=80" \
-e SPRING_APPLICATION_INSTANCE_ID="i2" \
-e SERVER_PORT=8092 \
localrun/service-order:latest