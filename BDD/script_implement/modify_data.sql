-- If the extension does not exist, we create it
CREATE EXTENSION IF NOT EXISTS plpython3u;

/*
    Parameters for the 
    ...

    Attributes
    ----------
    tablename : char
        name of the table to remove
    id : int
        id of the data to remove

    Methods
    -------
    A data is modify
*/

CREATE OR REPLACE FUNCTION modify_points_appuis(id_points_appuis int DEFAULT -1, point2d char DEFAULT '', point3d char DEFAULT '', EPSG int DEFAULT 0)
  RETURNS char
AS $$
	if id_points_appuis > -1:
		return 'id of the data to change'
	else :
		return 'no id specify'
	return 'Nothing to change'
$$ LANGUAGE plpython3u;
