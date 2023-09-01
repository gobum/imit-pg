-- a.Series(ge, lt)
create or replace function a.Series(ge int, lt int) returns setof int
  return generate_series(ge, lt-1);

-- a.Series(le)
create or replace function a.Series(lt int) returns setof int
  return generate_series(0, lt-1);

-- a.Random(int)
create or replace function a.Random(lt int) returns int
  return (random()*(lt-1))::int;

-- a.Id 根据时间和编号产生 ID
create or replace function a.Id(at timestamp with time zone, no int) returns varchar(16) as $$
declare
  CHARS constant char(32) = '0123456789ACDEFGHJKLMNPQRTUVWXYZ';
  zeroTick constant bigint = 406274400000000; --round(extract(epoch from '2021-07-01'::timestamp)*250000);
  tick bigint = extract(epoch from at)*250000 - zeroTick;
  id varchar = '';
begin
  for i in 1..6 loop
    id = substr(CHARS, (no&31) + 1, 1) || id;
    no = no >> 5;
  end loop;

  no = tick & 1073741823;    -- 0x3FFFFFFF
  tick = tick >> 30;
  for i in 1..6 loop
    id = substr(CHARS, (no&31) + 1, 1) || id;
    no = no >> 5;
  end loop;
  
  no = tick;
  for i in 1..3 loop
    id = substr(CHARS, (no&31) + 1, 1) || id;
    no = no >> 5;
  end loop;

  return substr(CHARS, no%22 + 11, 1) || id;
end;
$$ language 'plpgsql';

-- a.Id() 易变版，产生 ID （一个 16 字符的全球唯一标识符）
create or replace function a.Id() returns varchar(16)
  return a.Id(clock_timestamp(), (random()*1073741824)::int);

-- a.Id(no) SQL确定版，产生 ID （一个 16 字符的全球唯一标识符）
create or replace function a.Id(no int) returns varchar(16)
  return a.Id(statement_timestamp(), no);

-- a.Int(ge, lt) 产生一个指定范围的整数
create or replace function a.Int(ge int, lt int) returns int 
  return ge + (random()*(lt-ge-1))::int;

-- a.Int(lt) 产生一个指定范围的整数
create or replace function a.Int(lt int) returns int
  return a.Int(0, lt);

-- a.Numeric(ge, lt) 产生一个指定范围的小数
create or replace function a.Int(ge numeric, lt numeric) returns numeric 
  return ge + random()*(lt-ge-1);

-- a.Numeric(ge, lt, s) 产生一个指定范围的小数
create or replace function a.Numeric(ge numeric, lt numeric, s int) returns numeric 
  return trunc(ge + random()::numeric*(lt-ge), s);

-- a.Numeric(lt, s) 产生一个指定范围的小数
create or replace function a.Numeric(lt numeric, s int) returns numeric 
  return a.Numeric(0.0, lt, s);

-- a.Numeric(lt) 产生一个指定范围的小数
create or replace function a.Numeric(lt numeric) returns numeric 
  return a.Numeric(0.0, lt, 2);

-- a.Date(ge, lt) 产生一个指定范围内的日期
create or replace function a.Date(ge date, lt date) returns date
  return ge + (random()*(lt-ge-1))::int;

-- a.Date8No(day, no, len) 产生指定日期序号和长度的编号 
create or replace function a.Date8No(day date, no int, len int) returns varchar
  return to_char(day, 'YYYYMMDD') || ltrim(to_char(no, repeat('0', len)));

-- a.Date6No(day, no, len) 产生指定日期序号和长度的编号 
create or replace function a.Date6No(day date, no int, len int) returns varchar
  return to_char(day, 'YYMMDD') || ltrim(to_char(no, repeat('0', len)));
