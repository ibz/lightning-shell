% apps(7)
% Ioan Bizău <lightningshell@ibz.me>
% 2022-02-06

# NAME

apps - A list of apps available in the Lightning Shell

# DESCRIPTION

{% for cat in categories %}
## {{ cat.name }} tools
  {% for app in apps %}
    {% if app.category == cat.id %}
  * {{ app.name }} - {{ app.url }}

    {{ app.description }}
    {% endif %}
  {% endfor %}
{% endfor %}