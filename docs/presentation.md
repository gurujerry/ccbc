```bash
salt '*' grains.get os_family
salt '*' state.show_sls newkernel
```
# States Versus Modules (Commands)

## 530+ Modules
- file (manages files)
  - file.chown
  - file.remove
- mount (mount a filesystem)
  - mount.mount
  - mount.remount
- pkg (perform Linux, Windows, Mac, etc software package functions)
  - pkg.install
  - pkg.remove
- user (perform user account tasks)
  - user.add
  - user.delete
  - user.list_groups
  - user.list_users
## 350+ States
- file
  - file.managed
- service
  - service.disabled
  - service.enabled
  - service.running

# Grains
`top.sls` apply states to minions based on grains attributes
```yaml
base:
  'S@10.0.0.0/24 and G@kernel:Linux': # Linux VMs
    - match: compound
    - state.linux_software
    - state.ntp
  'S@10.0.0.0/24 and G@kernel:Windows': # Windows VMs
    - match: compound
    - state.windows_software
  'web-*': # Web Server VMs
    - state.firewall_on
```

# Nginx State
```yaml
install_nginx:
  pkg.installed:
    - name: nginx

setup_index:
  file.managed:
    - name: /var/www/html/index.html
    - contents: |
        <html>
        Hello World
        </html>
    - require:
      - pkg: install_nginx

nginx_service:
  service.running:
    - name: nginx
    - enable: True
    - require:
      - pkg: install_nginx
```

# Advanced: JINJA
