---
layout: page
title: 'PostgreSQL. Love affair.'
draft: true
toc: true

---

mockaroo.com – random data generator

## My History with PostgreSQL

## PostgreSQL is Innovating

### Amazing new Features

#### Array Data Type

#### Range Data Type

#### Geometry / 2D Space

#### XML/XPath

#### JSON

```sql
select data->>'first_name' from friend where data->>'last_name' = 'Boo';
select (data->>'ip_addresss')::inet <<= '127.0.0.0/8'::cidr
```

#### JSONB

Values are native javacript, data types, text number boolea null, subobject

create table friend2 (id serial, data jsonb);

insert into rined2 select * fro fri3nd;
-- jsonb_path_ops indexes are smaller and faster`\
create index friened2_idx on frind2 using GIN (data)

#### ROw types

```sql
create type drivers_licsense as
(state char(2), id integer, valid_unti date);

create table truck_driver
(id SERIAL, name TEXT, license DRIVERS_LICENSE);

INSERT INTO truck_driver
VALUES (DEFAULT, 'Jimbo Baggings', ('PA', 12314', '2017-03-12'));
```


## INDEXES

### B-Tree

Simple datatypes

### GIST

Geometric data types

### GIN
Better solution for read/write loads.

Complex JSONB or XML fields
