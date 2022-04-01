-- If the extension does not exist, we create it
CREATE EXTENSION IF NOT EXISTS plpython3u;

/*
    Parameters for the remove_data function
    ...

    Attributes
    ----------
    tablename : char
        name of the table to remove
    id : int
        id of the data to remove

    Methods
    -------
    A data is removed from the database, as well as its dependencies if necessary
	The type of treatment will depend on the table to be deleted
*/
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
		return 'The transfo2d table and its dependencies (georefs) have been deleted'
	if tablename == 'masks':
		plpy.execute('UPDATE images SET id_' + tablename + ' = NULL WHERE id_'+ tablename + ' = ' + str(id))
		plpy.execute('DELETE FROM ' + tablename + ' WHERE id_'+ tablename + ' = ' + str(id))
		return 'The masks table has been removed'
	if tablename == 'sources':
		return 'The sources table has a dedicated batch delete function'
	return 'The table does not exist in the database'
$$ LANGUAGE plpython3u;
