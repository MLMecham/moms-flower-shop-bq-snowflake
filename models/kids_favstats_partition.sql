-- models/kids_favstats_partition.sql

{{ favstats_partition(
    tbl        = ref('kids_feet'),
    val_col    = 'length',
    group_cols = ['domhand', 'sex']
) }}