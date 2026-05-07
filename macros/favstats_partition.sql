{% macro favstats_partition(tbl, val_col, group_cols=[]) %}

{%- set prefix = group_cols | join('_') ~ '_' -%}
{%- set partition_by = group_cols | join(', ') -%}

select
    *,
    min({{ val_col }}) over
        (partition by {{ partition_by }})           as {{ prefix }}min,
    percentile_cont(0.25) within group
        (order by {{ val_col }}) over
        (partition by {{ partition_by }})           as {{ prefix }}q1,
    percentile_cont(0.50) within group
        (order by {{ val_col }}) over
        (partition by {{ partition_by }})           as {{ prefix }}median,
    percentile_cont(0.75) within group
        (order by {{ val_col }}) over
        (partition by {{ partition_by }})           as {{ prefix }}q3,
    max({{ val_col }}) over
        (partition by {{ partition_by }})           as {{ prefix }}max,
    round(avg({{ val_col }}) over
        (partition by {{ partition_by }}), 2)       as {{ prefix }}mean,
    round(stddev_samp({{ val_col }}) over
        (partition by {{ partition_by }}), 2)       as {{ prefix }}sd,
    count({{ val_col }}) over
        (partition by {{ partition_by }})           as {{ prefix }}n,
    count(*) over
        (partition by {{ partition_by }})
    - count({{ val_col }}) over
        (partition by {{ partition_by }})           as {{ prefix }}missing
from {{ tbl }}

{% endmacro %}