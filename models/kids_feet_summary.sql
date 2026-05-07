-- models/kids_feet_summary.sql
select
    sex,
    avg(length) as avg_length,
    avg(width) as avg_width,
    count(*) as count
from {{ ref('kids_feet') }}
group by sex



