# A state that installs nginx, creates index.html, and starts nginx

install_nginx:
  pkg.installed:
    - name: nginx

setup_index:
  file.managed:
    - name: /var/www/html/index.html
    - contents: |
        <html>
        Hello CCBC!
        </html>
    - require:
      - pkg: install_nginx

nginx_service:
  service.running:
    - name: nginx
    - enable: True
    - require:
      - pkg: install_nginx
