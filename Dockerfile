# 编译php扩展镜像
# author dxq1994@gmail.com
FROM registry.cn-beijing.aliyuncs.com/dxq_docker/php
# tools
RUN apk --no-cache add alpine-sdk
# common dependency
RUN apk --no-cache add libressl-dev zlib-dev php5-dev autoconf
# bug fix
RUN \
    # 高版本alpine建立软链很重要，有些程序默认跑去找php(php7)
    if [ ! -e /usr/bin/php ]; then \
        ln -s /usr/bin/php5 /usr/bin/php; \
    fi; \
    # 感觉这像是个php官方bug（https://serverfault.com/questions/589877/pecl-command-produces-long-list-of-errors）
    sed -i "s|\-n||g" /usr/bin/pecl && \
    pecl update-channels && \
    rm -rf /tmp/pear ~/.pearrc
# 编译amqp swoole需要
RUN apk --no-cache add rabbitmq-c-dev nghttp2-dev hiredis-dev
ENTRYPOINT ["sh"]
