{
  fileSystems."/mnt/nas" = {
    device = "10.20.0.3:/srv/storage/tank";
    fsType = "nfs";
  };
  # optional, but ensures rpc-statsd is running for on demand mounting
  boot.supportedFilesystems = [ "nfs" ];
}