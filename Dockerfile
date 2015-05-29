FROM boggart/alpine-apk-static-32bit:latest
RUN ["/sbin/apk.static", "add", "--update", "alpine-base", "alpine-sdk"]
RUN adduser -G abuild -g "Alpine Package Builder" -s /bin/sh -D builder \
  && echo "builder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER builder

ENTRYPOINT ["abuild", "-r"]

WORKDIR /package

ENV PACKAGER_PRIVKEY /package/abuild.rsa
ENV REPODEST /packages
ENV PACKAGER Boggart <github.com/boggart>

ONBUILD RUN abuild-apk update
ONBUILD COPY . /package
ONBUILD RUN sudo mv *.rsa.pub /etc/apk/keys/ \
  && sudo mkdir /packages \
  && sudo chown -R builder /package /packages
