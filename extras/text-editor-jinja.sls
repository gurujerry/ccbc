# A state using JINJA logic to install a text editor
install-text-editor:
  pkg.installed:
    - pkgs:
{% if grains['kernel'] == 'Linux'%}
      - vim
{% elif grains['kernel'] == 'Windows' %}
      - notepad++
{% endif %}
