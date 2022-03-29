CREATE EXTENSION IF NOT EXISTS plpython3u;

CREATE OR REPLACE FUNCTION test(tablename char, id int)
  RETURNS bool
AS $$
	if tablename == 'points_appuis':
		plpy.execute('DELETE FROM ' + tablename + ' WHERE id_'+ tablename + ' = ' + str(id))
		return True
	if tablename == 'images':
		plpy.execute('DELETE FROM points_appuis WHERE id_'+ tablename + ' = ' + str(id))
		plpy.execute('DELETE FROM ' + tablename + ' WHERE id_'+ tablename + ' = ' + str(id))
		return True
	return False
$$ LANGUAGE plpython3u;
