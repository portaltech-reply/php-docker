#!/bin/bash
add_extension () {
    case $1 in

        mysql)
            add_extension pdo
            php_extensions+="mysqli pdo_mysql "
            build_deps+="mariadb-connector-c-dev "
            run_deps+="mariadb-connector-c "
            ;;
        pgsql|postgres)
            add_extension pdo
            php_extensions+="pdo_pgsql "
            build_deps+="postgresql-dev "
            run_deps+="postgresql-libs "
            ;;
        xml|simplexml|soap)
            php_extensions+="$1 "
            build_deps+="libxml2-dev "
            run_deps+="libxml2 "
            ;;
        intl)
            php_extensions+="intl "
            build_deps+="icu-dev "
            run_deps+="libintl icu-libs "
            ;;
        gettext)
            php_extensions+="gettext "
            build_deps+="gettext-dev "
            run_deps+="gettext-libs "
            ;;
        gmp)
            php_extensions+="gmp "
            build_deps+="gmp-dev "
            run_deps+="gmp "
            ;;
        ldap)
            php_extensions+="ldap "
            build_deps+="openldap-dev "
            run_deps+="libldap "
            ;;
        imagick)
            pecl_extensions+="imagick "
            run_deps+="imagemagick imagemagick-libs libmagic "
            build_deps+="imagemagick-dev "
            ;;
        gd)
            php_extensions+="gd "
            run_deps+="libgd freetype libwebp libpng zlib libxpm libjpeg-turbo "
            build_deps+="freetype-dev libwebp-dev libpng-dev zlib-dev libxpm-dev libjpeg-turbo-dev "
            ;;
        zip)
            php_extensions+="zip "
            build_deps+="zlib-dev libzip-dev "
            run_deps+="libzip "
            ;;
        mcrypt)
            pecl_extensions+="mcrypt "
            run_deps+="libmcrypt "
            build_deps+="libmcrypt-dev "
            ;;
        sockets|pcntl|bcmath|soap|exif|iconv|hash)
            php_extensions+="$1 "
            ;;
        redis|apcu|mongodb)
            pecl_extensions+="$1 "
            ;;
        curl|openssl|mhash|mbstring|tokenizer|pdo|json|mysqlnd|sodium|libedit|zlib|ftp|ctype|crypt|filter) # already included in php-alpine
            ;;
        opcache) # in Dockerfile.base
            ;;
        *)
            echo "Unknown extension $1"
            ;;
    esac
}

declare -A php_versions
php_versions=(["7.1"]="7.1-fpm-alpine3.9"
              ["7.2"]="7.2-fpm-alpine3.9"
              ["7.3"]="7.3-fpm-alpine3.9")

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for framework in $(cat frameworks)
do
    pecl_extensions=""
    php_extensions=""
    build_deps=""
    run_deps="bash git openssh-client su-exec "
    for ext in $(cat ${DIR}/${framework}/deps)
    do
        add_extension $ext
    done

    # remove duplicates
    pecl_extensions=$(echo -e "${pecl_extensions// /\\n}" | sort -u | grep -v '^$' | tr '\n' ' ' | sed -e 's/[[:space:]]*$//')
    php_extensions=$(echo -e "${php_extensions// /\\n}" | sort -u | grep -v '^$' | tr '\n' ' ' | sed -e 's/[[:space:]]*$//')
    build_deps=$(echo -e "${build_deps// /\\n}" | sort -u | grep -v '^$' | tr '\n' ' ' | sed -e 's/[[:space:]]*$//')
    run_deps=$(echo -e "${run_deps// /\\n}" | sort -u | grep -v '^$' | tr '\n' ' ' | sed -e 's/[[:space:]]*$//')

    for subdir in ${DIR}/${framework}/*/
    do
        version=$(basename $subdir)
        file="${subdir}Dockerfile"

        echo "FROM php:${php_versions[$version]}" > $file
        echo "MAINTAINER Linus Lotz<l.lotz@reply.de>" >> $file
        echo "ENV RUN_DEPS=\"${run_deps}\" \\" >> $file
        echo "    BUILD_DEPS=\"\${PHPIZE_DEPS} ${build_deps}\" \\" >> $file
        echo "    PECL_EXTS=\"${pecl_extensions}\" \\" >> $file
        echo "    PHP_EXTS=\"${php_extensions}\"" >> $file
        cat $DIR/Dockerfile.base >> $file
    done
done


