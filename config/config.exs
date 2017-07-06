# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Customize the firmware. Uncomment all or parts of the following
# to add files to the root filesystem or modify the firmware
# archive.

# config :nerves, :firmware,
#   rootfs_additions: "config/rootfs_additions",
#   fwup_conf: "config/fwup.conf"

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.Project.config[:target]}.exs"

key_mgmt = System.get_env("NERVES_NETWORK_KEY_MGMT") ||
           "WPA-PSK"

ssh_pub_key =  System.get_env("NERVES_SSH_PUB_KEY") ||
               File.read!(Path.expand("~/.ssh/id_rsa.pub"))

ssh_port = System.get_env("NERVES_SSH_PORT") || 8989

config :bootloader,
  init: [:nerves_runtime, :nerves_network, :nerves_firmware_ssh],
  app: :hardware_test

config :nerves_firmware_ssh,
  authorized_keys: [
    ssh_pub_key
  ],
  port: ssh_port

config :nerves_network, :default,
  wlan0: [
    ssid: System.get_env("NERVES_NETWORK_SSID"),
    psk: System.get_env("NERVES_NETWORK_PSK"),
    key_mgmt: String.to_atom(key_mgmt)
  ]
