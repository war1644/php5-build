#!/usr/bin/env bash
# 先构建好build镜像，自动化编译扩展
# author duanxuqiang@ucse.net

docker run -d -it --name php-builder ucse/build
# Build redis
# Download from pear may need proxy
#docker exec -i php-builder pecl install -o -f redis <<<no
#docker exec -i php-builder pecl install -o -f memcache <<<no
#docker exec -i php-builder pecl install -o -f amqp <<<""
#docker exec -i php-builder pecl install -o -f swoole <<(echo -e "no\nyes\nyes\nyes\nyes\nyes")

# Build with module
MODULE="memcache redis amqp swoole"
for i in $MODULE; do docker cp php-builder:/usr/lib/php5/modules/$i.so ../modules/; done;
#rm modules/extra.ini
for i in $MODULE; do echo "extension=$i.so" >> ../modules/extra.ini; done;

# Cleanup
docker stop php-builder
# No need to remove if will build other module later
docker rm -f php-builder
