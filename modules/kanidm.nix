{pkgs, ...}: {

  systemd.services.kanidm-unixd = {
    serviceConfig = {
      Environment = "RUST_LOG=kanidm=debug";
    };
  };

  services.kanidm = {
    enablePam = true;
    enableClient = true;
    package = pkgs.kanidm_1_7;
    unixSettings = {
	    pam_allowed_login_groups = ["idm_all_persons"];
    };
    clientSettings = {
	    uri = "https://idm.jameskr.dev";
    };
  };

  services.openssh.authorizedKeysCommand = "/run/wrappers/bin/kanidm_wrapper_direct -D anonymous %u";
  services.openssh.authorizedKeysCommandUser = "nobody";

  security.wrappers.kanidm_wrapper_direct = {
    source = "${pkgs.kanidm_1_7}/bin/kanidm_ssh_authorizedkeys_direct";
    owner = "root";
    group = "root";
    permissions = "u+rx,g+rx,o+rx";
  };

  # security.pam.services.sshd = {
  #   text = ''
  #     # Account management
  #     account sufficient ${pkgs.kanidm_1_7}/lib/pam_kanidm.so ignore_unknown_user
  #     account required ${pkgs.pam}/lib/security/pam_deny.so
      
  #     # Authentication management
  #     auth required ${pkgs.pam}/lib/security/pam_env.so
  #     auth sufficient ${pkgs.kanidm_1_7}/lib/pam_kanidm.so ignore_unknown_user
  #     auth required ${pkgs.pam}/lib/security/pam_deny.so
      
  #     # Password management
  #     password required ${pkgs.pam}/lib/security/pam_unix.so nullok yescrypt
      
  #     # Session management
  #     session required ${pkgs.pam}/lib/security/pam_env.so conffile=/etc/pam/environment readenv=0
  #     session required ${pkgs.pam}/lib/security/pam_unix.so
  #     session required ${pkgs.pam}/lib/security/pam_loginuid.so
  #     session optional ${pkgs.kanidm_1_7}/lib/pam_kanidm.so
  #     session optional ${pkgs.systemd}/lib/security/pam_systemd.so
  #   '';
  # };
}