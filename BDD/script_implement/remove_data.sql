CREATE EXTENSION IF NOT EXISTS plpython3u;

CREATE OR REPLACE FUNCTION remove_data(tablename char, id int)
  RETURNS char
AS $$
	if tablename == 'georefs':
		plpy.execute('DELETE FROM ' + tablename + ' WHERE id_'+ tablename + ' = ' + str(id))
		return 'The georefs table has been removed'
	if tablename == 'points_appuis':
		plpy.execute('DELETE FROM ' + tablename + ' WHERE id_'+ tablename + ' = ' + str(id))
		return 'The points_appuis table has been removed'
	if tablename == 'images':
		plpy.execute('DELETE FROM points_appuis WHERE id_'+ tablename + ' = ' + str(id))
		plpy.execute('DELETE FROM georefs WHERE id_'+ tablename + ' = ' + str(id))
		plpy.execute('DELETE FROM ' + tablename + ' WHERE id_'+ tablename + ' = ' + str(id))
		return 'The images table and its dependencies (georefs, points_appuis) have been deleted'
	if tablename == 'interne':
		plpy.execute('DELETE FROM georefs WHERE id_'+ tablename + ' = ' + str(id))
		plpy.execute('DELETE FROM ' + tablename + ' WHERE id_'+ tablename + ' = ' + str(id))
		return 'The interne table and its dependencies (georefs) have been deleted'
	if tablename == 'externe':
		plpy.execute('DELETE FROM georefs WHERE id_'+ tablename + ' = ' + str(id))
		plpy.execute('DELETE FROM ' + tablename + ' WHERE id_'+ tablename + ' = ' + str(id))
		return 'The externe table and its dependencies (georefs) have been deleted'
	if tablename == 'transfo2d':
		plpy.execute('DELETE FROM georefs WHERE id_'+ tablename + ' = ' + str(id))
		plpy.execute('DELETE FROM ' + tablename + ' WHERE id_'+ tablename + ' = ' + str(id))
		return 'The georefs table and its dependencies (georefs) have been deleted'
	if tablename == 'masks':
		return 'To be reviewed'
	if tablename == 'sources':
		return 'The source table has a dedicated batch delete function'
	return False
$$ LANGUAGE plpython3u;
