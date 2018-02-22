{% for key, value in registerEnv.iteritems() %}
export {{key}}={{value}}
{% endfor %}
