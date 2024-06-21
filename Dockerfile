FROM debian:stable
MAINTAINER DarkNoon [darkcity.fr]

# Steps done in one RUN layer:
# - Install packages
# - OpenSSH needs /var/run/sshd to run
# - Remove generic host keys, entrypoint generates unique keys
RUN apt-get update && \
    apt-get -y install openssh-server && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/sshd && \
    rm -f /etc/ssh/ssh_host_*key*

COPY files/sshd_config /etc/ssh/sshd_config
COPY files/ssh_host_ed25519_key /etc/ssh/ssh_host_ed25519_key
COPY files/ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key
RUN chmod 400 /etc/ssh/ssh_host_ed25519_key
RUN chmod 400 /etc/ssh/ssh_host_rsa_key

COPY files/create-sftp-user /usr/local/bin/
COPY files/entrypoint /

EXPOSE 22

ENTRYPOINT ["/entrypoint"]
