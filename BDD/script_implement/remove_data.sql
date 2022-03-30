CREATE EXTENSION IF NOT EXISTS plpython3u;

CREATE OR REPLACE FUNCTION test(tablename char, id int)
  RETURNS bool
AS $$
	if tablename == 'georefs':
		plpy.execute('DELETE FROM ' + tablename + ' WHERE id_'+ tablename + ' = ' + str(id))
		return True
	if tablename == 'points_appuis':
		plpy.execute('DELETE FROM ' + tablename + ' WHERE id_'+ tablename + ' = ' + str(id))
		return True
	if tablename == 'images':
		plpy.execute('DELETE FROM points_appuis WHERE id_'+ tablename + ' = ' + str(id))
		plpy.execute('DELETE FROM ' + tablename + ' WHERE id_'+ tablename + ' = ' + str(id))
		return True
	if tablename == 'interne':
		plpy.execute('DELETE FROM georefs WHERE id_'+ tablename + ' = ' + str(id))
		plpy.execute('DELETE FROM ' + tablename + ' WHERE id_'+ tablename + ' = ' + str(id))
		return True
	if tablename == 'externe':
		plpy.execute('DELETE FROM georefs WHERE id_'+ tablename + ' = ' + str(id))
		plpy.execute('DELETE FROM ' + tablename + ' WHERE id_'+ tablename + ' = ' + str(id))
		return True
	if tablename == 'transfo2d':
		plpy.execute('DELETE FROM georefs WHERE id_'+ tablename + ' = ' + str(id))
		plpy.execute('DELETE FROM ' + tablename + ' WHERE id_'+ tablename + ' = ' + str(id))
		return True
	if tablename == 'transfo3d':
		plpy.execute('DELETE FROM georefs WHERE id_'+ tablename + ' = ' + str(id))
		plpy.execute('DELETE FROM ' + tablename + ' WHERE id_'+ tablename + ' = ' + str(id))
		return True
	if tablename == 'masks':
		plpy.execute('DELETE FROM ' + tablename + ' WHERE id_'+ tablename + ' = ' + str(id))
		return True
	if tablename == 'sources':
		plpy.execute('DELETE FROM ' + tablename + ' WHERE id_'+ tablename + ' = ' + str(id))
		return True
	return False
$$ LANGUAGE plpython3u;
