-- macros/favstats.sql

{% macro favstats(tbl, val_col, group_cols=[]) %}

with base as (
    select
        {% for col in group_cols %}
        {{ col }},
        {% endfor %}
        {{ val_col }} as _val
    from {{ tbl }}
)
select
    {% for col in group_cols %}
    {{ col }},
    {% endfor %}
    min(_val)                                           as min,
    percentile_cont(0.25) within group
        (order by _val)                                 as q1,
    percentile_cont(0.50) within group
        (order by _val)                                 as median,
    percentile_cont(0.75) within group
        (order by _val)                                 as q3,
    max(_val)                                           as max,
    round(avg(_val), 2)                                 as mean,
    round(stddev_samp(_val), 2)                         as sd,
    count(_val)                                         as n,
    count(*) - count(_val)                              as missing
from base
{% if group_cols %}
group by {% for col in group_cols %}{{ col }}{{ ", " if not loop.last }}{% endfor %}
order by {% for col in group_cols %}{{ col }}{{ ", " if not loop.last }}{% endfor %}
{% endif %}

{% endmacro %}