FROM ruby:3.0.1

# RUN apt-get clean \
#     && apt-get update -qq  \
#     && apt-get install -y apt-utils debian-archive-keyring build-essential libpq-dev vim curl \
#     bzip2 git libssl-dev libfreetype6 libfontconfig \
#     libasound2 libpango1.0-0 libx11-xcb1 libxss1 libxtst6 fonts-liberation xdg-utils \
#     ghostscript unzip libde265-dev libopenjp2-7-dev librsvg2-dev libwebp-dev

# ENV NODE_VERSION 14.17.6
# ENV NODE_OPTIONS "--max-old-space-size=4096"

# RUN ARCH= && dpkgArch="$(dpkg --print-architecture)" \
#   && case "${dpkgArch##*-}" in \
#     amd64) ARCH='x64';; \
#     ppc64el) ARCH='ppc64le';; \
#     s390x) ARCH='s390x';; \
#     arm64) ARCH='arm64';; \
#     armhf) ARCH='armv7l';; \
#     i386) ARCH='x86';; \
#     *) echo "unsupported architecture"; exit 1 ;; \
#   esac \
#   # gpg keys listed at https://github.com/nodejs/node#release-keys
#   && set -ex \
#   && for key in \
#     4ED778F539E3634C779C87C6D7062848A1AB005C \
#     94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
#     74F12602B6F1C4E913FAA37AD3A89613643B6201 \
#     71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
#     8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
#     C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
#     C82FA3AE1CBEDC6BE46B9360C43CEC45C17AB93C \
#     DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
#     A48C2BEE680E841632CD4E44F07496B3EB3C1762 \
#     108F52B48DB57BB0CC439B2997B01419BD92F80A \
#     B9E2F5981AA6E0CD28160D9FF13993A75599653C \
#   ; do \
#     gpg --batch --keyserver hkps://keyserver.ubuntu.com --recv-keys "$key" || \
#     gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$key" ; \
#   done \
#   && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH.tar.xz" \
#   && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
#   && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
#   && grep " node-v$NODE_VERSION-linux-$ARCH.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
#   && tar -xJf "node-v$NODE_VERSION-linux-$ARCH.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
#   && rm "node-v$NODE_VERSION-linux-$ARCH.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
#   && ln -s /usr/local/bin/node /usr/local/bin/nodejs

# RUN npm install --global yarn@1.22.11 webpack && gem install bundler rubygems-bundler

# COPY docker/web/ghostscript/Resource/Font/* /usr/share/ghostscript/9.26/Resource/Font/
# COPY docker/web/ghostscript/Resource/CMap/* /usr/share/ghostscript/9.26/Resource/CMap/
# COPY docker/web/ghostscript/Resource/Init/* /usr/share/ghostscript/9.26/Resource/Init/

# RUN wget https://github.com/strukturag/libheif/releases/download/v1.6.2/libheif-1.6.2.tar.gz \
#   && tar xvzf libheif-1.6.2.tar.gz && rm libheif-1.6.2.tar.gz && cd libheif-1.6.2 \
#   && ./autogen.sh && ./configure && make && make install && cd ..

# RUN wget https://github.com/ImageMagick/ImageMagick/archive/7.0.10-55.tar.gz \
#   && tar xvzf 7.0.10-55.tar.gz && rm 7.0.10-55.tar.gz \
#   && cd ImageMagick-7.0.10-55 && ./configure --with-quantum-depth=8 --with-rsvg --with-heic=yes \
#   && make && make install && ldconfig /usr/local/lib

# RUN apt-get update && apt-get install libjemalloc2 && rm -rf /var/lib/apt/lists/*
# ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2

# COPY docker/web/ImageMagick/policy.xml /usr/local/lib/ImageMagick-7.0.10/config-Q8HDRI/

# RUN apt-get update && apt-get install -y xfonts-75dpi xfonts-base \
#   && wget "https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.buster_$(dpkg --print-architecture).deb" \
#   && dpkg -i "wkhtmltox_0.12.6-1.buster_$(dpkg --print-architecture).deb" && rm "wkhtmltox_0.12.6-1.buster_$(dpkg --print-architecture).deb"
ENV RAILS_ENV development

RUN mkdir -p /app

WORKDIR /app

COPY . .

RUN bundle install

EXPOSE 3000

CMD ./bin/rails s -b '0.0.0.0' -p 3000
