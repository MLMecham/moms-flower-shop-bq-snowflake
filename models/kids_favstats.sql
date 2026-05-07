-- models/kids_favstats.sql

{{ favstats(
    tbl        = 'kids_feet',
    val_col    = 'length',
    group_cols = ['domhand', 'sex']
) }}