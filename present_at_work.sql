WITH
x AS
	( SELECT *, LAG(present) OVER (PARTITION BY id ORDER BY id,date) AS lag FROM present),

y AS
	( SELECT *,(CASE WHEN present=1 AND lag=1 THEN 0 ELSE 1 end) AS identified_group FROM x),

z AS
	( SELECT *, SUM(identified_group) OVER (ORDER BY id,date) AS run_tot FROM y),
	
final AS
	( SELECT id,run_tot, count(run_tot) AS consecutive_days FROM z GROUP BY id,run_tot)

SELECT id, MAX(consecutive_days) AS number FROM final WHERE id IS NOT NULL GROUP BY id;