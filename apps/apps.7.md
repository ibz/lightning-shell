% apps(7)
% Ioan Bizău <lightningshell@ibz.me>
% 2022-02-06

# NAME

apps - A list of apps available in the Lightning Shell

# DESCRIPTION

{% for app in apps %}
 * {{ app.name }} ({{ app.url }})

   {{ app.description }}
{% endfor %}
