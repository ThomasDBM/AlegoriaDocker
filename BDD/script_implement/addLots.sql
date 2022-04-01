-- If the extension does not exist, we create it
CREATE EXTENSION IF NOT EXISTS plpython3u;

/*
    Parameters for the addLots function
    ...

    Attributes
    ----------
    files : char[]
        liste of the xml files to add
    attributesSources : char[]
        listes of the attributes to the new sources to add
    balisesName : char []
        Name of the balises to uses to add data

    Methods
    -------
*/

CREATE OR REPLACE FUNCTION addLots(files char[], attributesSources char[], balisesName char[] )
    RETURNS char
AS $$
    attributesSourceValue = ()
    for i in attributesSources:
        attributesSourceValue += i
    request = 'INSERT into sources(credit, home, url, viewer, thumbnail, lowres, highres, iip VALUES'.format(attributesSources)
	sourcesAdd = plpy.execute(request)
    plpy.notice(sourcesAdd__str__())
$$ LANGUAGE plpython3u;
