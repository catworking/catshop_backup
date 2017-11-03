FROM drupal:8.3

RUN apt-get update && apt-get install -y \
            wget git \
             && docker-php-ext-install -j$(nproc) bcmath

COPY install-composer.sh install-composer.sh

RUN chmod 0777 "./install-composer.sh"
RUN "./install-composer.sh"

ADD . profiles/catshop

RUN composer config minimum-stability dev && \
    composer require "drupal/commerce" && \
    composer require "drush/drush" &&  \
    "./vendor/bin/drush" -y site-install catshop \
     --db-url="sqlite://sites/default/files/.ht.sqlite" \
     --account-name=admin --account-pass=123 --account-mail=164713332@qq.com \
     --site-name=测试网站 --locale=zh-hans

RUN composer config repo.packagist composer "https://packagist.phpcomposer.com"