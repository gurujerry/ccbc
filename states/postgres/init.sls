# A state that installs and starts postgres

install_postgres:
  pkg.installed:
    - name: postgresql

#postgres_service:
#  service.running:
#    - name: postgresql
#    - enable: True
#    - require:
#      - pkg: install_postgres
