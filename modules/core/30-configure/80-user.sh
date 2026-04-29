user_create() {
  chroot "$INSTALL_MOUNTPOINT"            \
    useradd                               \
      --create-home                       \
      --shell /bin/bash                   \
      --groups sudo                       \
      --password "$ADMIN_PASSWORD_HASH"   \
      -- "$ADMIN_USERNAME" || return 1
}


user_install() {
  apt_install "$INSTALL_MOUNTPOINT" \
    bash                            \
    openssh-server                  \
    sudo || return 1
}


user_authorized_keys_configure() {
  mkdir --parents -- \
    "$INSTALL_MOUNTPOINT/home/$ADMIN_USERNAME/.ssh" || return 1

  cp --               \
    "$ADMIN_SSH_PUB"  \
    "$INSTALL_MOUNTPOINT/home/$ADMIN_USERNAME/.ssh/authorized_keys" || return 1

  chroot "$INSTALL_MOUNTPOINT"                  \
    chown -R "$ADMIN_USERNAME:$ADMIN_USERNAME"  \
      "/home/$ADMIN_USERNAME/.ssh" || return 1
}