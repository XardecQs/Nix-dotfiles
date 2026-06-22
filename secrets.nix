let
  neoReaper = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJfPyQDmThtZEjxLNEaG6V7XiJVLfbKMl8AEbl6HZp9z xavierdelpiero@proton.me";
in
{
  "secrets/root-password.age".publicKeys = [ neoReaper ];
  "secrets/primaryUser-password.age".publicKeys = [ neoReaper ];
  "secrets/cloudreve-aria2.age".publicKeys = [ neoReaper ];
}
