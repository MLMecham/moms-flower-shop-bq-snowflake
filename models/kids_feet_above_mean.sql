with mean_length as (
    select
        sex,
        avg(length) as avg_length
    from {{ ref('kids_feet') }}
    group by sex
),

filtered as (
    select
        k.*,
        m.avg_length
    from {{ ref('kids_feet') }} k
    join mean_length m
        on k.sex = m.sex
    where k.length > m.avg_length
)

select * from filtered