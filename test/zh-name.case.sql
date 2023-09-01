:Hope /* a.ZhFname() */
  select a.ZhFname()
    from generate_series(1, 10)
  :Pass
  :Rows=10
:Done

:Hope /* a.ZhName() */
  select a.ZhName()
    from generate_series(1, 10)
  :Pass
  :Rows=10
:Done
