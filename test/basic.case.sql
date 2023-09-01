:Hope /* a.Id(at_min, no_min) */
  select a.Id('20210701', 0) = 'A000000000000000' as :Assert
:Done

:Hope /* a.Id(at_min, no_max) */
  select a.Id('20210701', 1073741824-1) = 'A000000000ZZZZZZ' as :Assert
:Done

:Hope /* a.Id(at_min, no_max) */
  select a.Id('2119-08-12 22:25:43.817', 1073741824-1) = 'ZZZZZZZZYAZZZZZZ' as :Assert
:Done

:Hope /* a.Id() != a.Id() */
  select a.Id() != a.Id() as :Assert
:Done

:Hope /* a.Id() each row */
  select a.Id() id
    from generate_series(1, 100)
    group by id
  :Rows=100
:Done

:Hope /* a.Id(123) = a.Id(123) */
  select a.Id(123) = a.Id(123) as :Assert
:Done

:Hope /* a.Id(123) save_id */
  select a.Id(123) save_id
  :Variable
:Done

:Hope /* a.Id(123) != :save_id */
  select a.Id(123) != :'save_id' as :Assert
:Done

:Hope /* a.Int(ge, lt) between min and max */
  with i as ( select a.Int(100, 1000) i from generate_series(1, 10000))
  select min(i)>= 100 and  max(i) < 1000 as :Assert
    from i
:Done

:Hope /* a.Int(lt) 0<= a.Int < lt */
  with i as ( select a.Int(1000) i from generate_series(1, 10000))
  select min(i)>= 0 and  max(i) < 1000 as :Assert
    from i
:Done

:Hope /* a.Numeric(ge, lt, s) */
  with n as ( select a.Numeric(-123.456, 123.456, 3) n from generate_series(1, 10000))
  select min(n) >=-123.456 and max(n) < 123.456 as :Assert
    from n
:Done

:Hope /* a.Numeric(lt, s) */
  with n as ( select a.Numeric(123.4567, 4) n from generate_series(1, 10000))
  select min(n) >=0 and max(n) < 123.4567 as :Assert
    from n
:Done

:Hope /* a.Numeric(lt) */
  with n as ( select a.Numeric(123.45) n from generate_series(1, 10000))
  select min(n) >=0 and max(n) < 123.45 as :Assert
    from n
:Done

:Hope /* a.Date(ge, lt) */
  with d as ( select a.Date('20230101', '20230201') d from generate_series(1, 10000))
  select min(d) >= '20230101' and max(d) < '20230201' as :Assert
    from d
:Done

:Hope /* a.Date6No(day, n, len) */
  select a.Date8No('2021-07-01', 5, 2) = '2021070105' as :Assert
:Done

:Hope /* a.Date6No(day, n, len) */
  select a.Date6No('2021-07-01', 5, 2) = '21070105' as :Assert
:Done
