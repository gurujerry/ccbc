# This is the high state. If a minion matches the grains, the state(s) will be ran
base:
  'S@172.0.0.0/8 and G@kernel:Linux': # Linux VMs
    - match: compound
    - linux_software
  'S@172.0.0.0/8 and G@kernel:Windows': # Windows VMs
    - match: compound
    - win_update
  #'web-*': # All Web Server VMs
  #  - nginx
