:Hope /* a.Fname() */
  select a.Fname()
    from generate_series(1, 10)
  :Pass
  :Rows=10
:Done

:Hope /* a.Name() */
  select a.Name()
    from generate_series(1, 10)
  :Pass
  :Rows=10
:Done
