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
 1. 산의 처음 등산 성공연도가 1900년도보다 빠른산들중에 높이가 6000미터 이상인 산을 검색하시오.

 2. 산의 높이가 6,000대인 것들만 색인하고 내림차순으로 정렬하시오.

 3. 산 이름에 공백이 포함되어 있는 것들의 이름과 높이를 색인하시오.

 4. 가장 최근에 등반된 산(Cho Oyu)의 정보를 출력하시오.

 5. 가장 오래전에 등반된 산(Piz Palu)의 정보를 출력하시오.
*/



