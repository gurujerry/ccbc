# A state using JINJA logic to create user home
#   directories from a salt pillar list of usernames
{% for user in pillar['usernames'] %}
/home/{{ user }}:
  file.directory:
    - user: {{ user }}
    - group: {{ user }}
    - mode: 700
{% endfor %}
