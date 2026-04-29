mok_create() {
  mkdir --parents \
    "$INSTALL_MOUNTPOINT$MOK_KEY_DIR" \
    "$INSTALL_MOUNTPOINT$MOK_CERT_DIR" || return 1

  chmod 0700 -- \
    "$INSTALL_MOUNTPOINT$MOK_KEY_DIR" || return 1
  
  chmod 0755 -- \
    "$INSTALL_MOUNTPOINT$MOK_CERT_DIR" || return 1

  chroot "$INSTALL_MOUNTPOINT"                \
    openssl req                               \
      -new                                    \
      -x509                                   \
      -newkey rsa:2048                        \
      -sha256                                 \
      -nodes                                  \
      -days 3650                              \
      -subj "/CN=Local Secure Boot MOK/"      \
      -keyout "$MOK_KEY_PATH"                 \
      -out "$MOK_CERT_PATH"                   \
      -addext "basicConstraints=CA:FALSE"     \
      -addext "keyUsage=digitalSignature"     \
      -addext "extendedKeyUsage=codeSigning"  \
      -addext "subjectKeyIdentifier=hash" || return 1

  chroot "$INSTALL_MOUNTPOINT"                \
    openssl x509                              \
      -in "$MOK_CERT_PATH" \
      -out "$MOK_DER_PATH" \
      -outform DER || return 1

  chmod 0600 -- \
    "$INSTALL_MOUNTPOINT$MOK_KEY_PATH" || return 1
  
  chmod 0644 -- \
    "$INSTALL_MOUNTPOINT$MOK_CERT_PATH" \
    "$INSTALL_MOUNTPOINT$MOK_DER_PATH" || return 1
}


mok_install() {
  apt_install "$INSTALL_MOUNTPOINT" \
    mokutil                         \
    openssl || return 1
}


mok_enroll() {
  assert_file "$INSTALL_MOUNTPOINT$MOK_DER_PATH"
 
  log_status warning "You will be asked to create a temporary MOK enrollment password"

  chroot "$INSTALL_MOUNTPOINT"  \
    mokutil                     \
    --import "$MOK_DER_PATH" || return 1
}