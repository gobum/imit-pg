-- anId() 易变版，产生 ID （一个 16 字符的全球唯一标识符）
create or replace function newid() returns varchar(16) as $$
declare
  CHARS constant char(32) = '0123456789ACDEFGHJKLMNPQRTUVWXYZ';
  zeroTick constant bigint = 336506400000000; --round(extract(epoch from '2021-07-01'::timestamp)*250000);
  rem int = round(random()*1073741824);  -- 30位随机数，0x40000000
  tick bigint = extract(epoch from clock_timestamp())*250000 - zeroTick;
  id varchar = '';
begin
  for i in 1..6 loop
    id = substr(CHARS, (rem&31) + 1, 1) || id;
    rem = rem >> 5;
  end loop;

  rem = tick & 1073741823;    -- 0x3FFFFFFF
  tick = tick >> 30;
  for i in 1..6 loop
    id = substr(CHARS, (rem&31) + 1, 1) || id;
    rem = rem >> 5;
  end loop;
  
  rem = tick;
  for i in 1..3 loop
    id = substr(CHARS, (rem&31) + 1, 1) || id;
    rem = rem >> 5;
  end loop;

  return substr(CHARS, rem%22 + 11, 1) || id;
end;
$$ language 'plpgsql';

-- anId(ms) SQL确定版，产生 ID （一个 16 字符的全球唯一标识符）
create or replace function anId(rem int) returns varchar(16) as $$
declare
  CHARS constant char(32) = '0123456789ACDEFGHJKLMNPQRTUVWXYZ';
  zeroTick constant bigint = 336506400000000; --round(extract(epoch from '2021-07-01'::timestamp)*250000);
  tick bigint = extract(epoch from statement_timestamp())*250000 - zeroTick;
  id varchar = '';
begin
  for i in 1..6 loop
    id = substr(CHARS, (rem&31) + 1, 1) || id;
    rem = rem >> 5;
  end loop;

  rem = tick & 1073741823;    -- 0x3FFFFFFF
  tick = tick >> 30;
  for i in 1..6 loop
    id = substr(CHARS, (rem&31) + 1, 1) || id;
    rem = rem >> 5;
  end loop;
  
  rem = tick;
  for i in 1..3 loop
    id = substr(CHARS, (rem&31) + 1, 1) || id;
    rem = rem >> 5;
  end loop;

  return substr(CHARS, rem%22 + 11, 1) || id;
end;
$$ language 'plpgsql';


-- anInt(min, max) 产生一个指定范围的整数
create or replace function anInt(min int, max int) returns int 
  -- return min + round(random()*(max-min))::int;
  return min + random()*(max-min)::int;
