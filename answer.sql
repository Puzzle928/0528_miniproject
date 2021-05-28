.header on
.mode column

CREATE TABLE mountains (
  name TEXT,
  height_meters INTEGER,
  first_ascent DATE
);

INSERT INTO mountains VALUES
  ('Mount Everest', 8848, '1953-05-29'),
  ('Kilimanjaro', 5895, '1889-10-06'),
  ('Denali', 6190, '1913-06-07'),
  ('Chimborazo', 6263, '1880-01-04'),
  ('K2', 8611, '1954-07-31'),
  ('Piz Palü', 3900, '1835-08-12'),
  ('Cho Oyu', 8188, '1954-10-19');

.print 'average mountain height'
SELECT avg(height_meters) AS avg_height
FROM mountains;

.print
.print 'number of ascents per century'
SELECT
  strftime(
    '%Y',
    date(first_ascent)
  ) / 100 + 1 AS century,
  count(*) AS ascents
FROM mountains
GROUP BY century;

CREATE TEMP TABLE IF NOT EXISTS timeline(
  rid INTEGER PRIMARY KEY,
  uuid TEXT,
  timestamp TEXT,
  comment TEXT,
  user TEXT,
  isleaf BOOLEAN,
  bgcolor TEXT,
  etype TEXT,
  taglist TEXT,
  tagid INTEGER,
  short TEXT,
  sortby REAL
)
;
INSERT OR IGNORE INTO timeline SELECT
  blob.rid AS blobRid,
  uuid AS uuid,
  datetime(event.mtime,toLocal()) AS timestamp,
  coalesce(ecomment, comment) AS comment,
  coalesce(euser, user) AS user,
  blob.rid IN leaf AS leaf,
  bgcolor AS bgColor,
  event.type AS eventType,
  (SELECT group_concat(substr(tagname,5), ', ') FROM tag, tagxref
    WHERE tagname GLOB 'sym-*' AND tag.tagid=tagxref.tagid
      AND tagxref.rid=blob.rid AND tagxref.tagtype>0) AS tags,
  tagid AS tagid,
  brief AS brief,
  event.mtime AS mtime
 FROM event CROSS JOIN blob
WHERE blob.rid=event.objid
 AND NOT EXISTS(SELECT 1 FROM tagxref WHERE tagid=5 AND tagtype>0 AND rid=blob.rid)
 ORDER BY event.mtime DESC LIMIT 50;


select * from mountains;

 select name as 산, height_meters as 높이 from mountains where name like '%l%' and height_meters >=6000;
 
 
 select name as 산, height_meters as 높이 from mountains where name like '%l%' and height_meters >=6000 and first_ascent between 1800/01/01 and 1899/12/31 order by height_meters asc;

 /*
 1. 정답:
 select name, height_meters, first_ascent from mountains where height-meters >= 6000 and frist_ascent <= '1900/01/01;

 2. 정답:
 select * from mountains where height_meters like '6%' order by height_meters desc;

 3. 정답:
 select name, height_meters from mountains where like '% %';

 4. 정답:
 select * from mountains where first_ascent=(select max(first_ascent) from mountains);

 5. 정답:
 select * from mountains where first_ascent=(select min(first_ascent) from mountains);

*/



