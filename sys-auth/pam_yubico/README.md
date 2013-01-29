install
=======
#required by pam_yubico (argument)
=sys-auth/pam_yubico-2.12 ~amd64
#required by sys-auth/ykpers-1.11.3, required by sys-auth/pam_yubico-2.12, required by pam_yubico (argument)
=sys-auth/libyubikey-1.9 ~amd64
#required by sys-auth/pam_yubico-2.12, required by pam_yubico (argument)
=sys-auth/ykclient-2.9 ~amd64
#required by sys-auth/pam_yubico-2.12, required by pam_yubico (argument)
=sys-auth/ykpers-1.11.3 ~amd64

emerge -atv pam_yubico ykclient


read sshd.example for options. Havn't tested with local console
