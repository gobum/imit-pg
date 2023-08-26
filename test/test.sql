\ir ../inc/hope.sql

:Hope /* Test clock_timestamp() */
  select clock_timestamp() t
    from generate_series(0, 10)
    group by t
  :Rows > 1
:Done

:Hope /* Test statement_timestamp() */
  select statement_timestamp() t
    from generate_series(0, 10)
    group by t
  :Rows = 1
:Done
