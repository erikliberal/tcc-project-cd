FROM erikliberal/gocd-server

MAINTAINER "Erik Liberal" <erik.liberal@gmail.com>

ARG user=go

RUN chown -R ${user} /var/lib/go-server /etc/go /var/log/go-server /usr/share/go-server /etc/default/go-server

USER ${user}

RUN ssh-keygen -q -f "${HOME}/.ssh/id_rsa" -N "" && cat "${HOME}/.ssh/id_rsa.pub"

USER root

ADD entrypoint.sh /usr/local/sbin/entrypoint

RUN chmod 0755 /usr/local/sbin/entrypoint

ENTRYPOINT ["/usr/local/sbin/entrypoint"]
