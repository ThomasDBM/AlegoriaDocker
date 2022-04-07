""" Script to adding data in the BDD """

#--- Librairies -------------------------------------#

from optparse import Values
from urllib import request
from xml.dom.minidom import Element
import psycopg2
from tkinter import *
from tkinter import filedialog
import xml.etree.ElementTree as ET

#--- Functions --------------------------------------#

def nameOfBaliseImages():
    """
        Ask to the names of the xml balise 
        :return: list of the balise name
        :type: list
    """
    
    rep = 'yes'

    while rep == 'yes':
        print('Please provide the balise name of : ')

        date = input('date ?')
        image_name = input('name ?')
        origine = input('origine ?')
        qualite = input('qualite ?')
        resolution_moy = input('resolution_moy ?')
        resolution_max = input('resolution_max ?')
        resolution_min = input('resolution_min ?')

        print('Is it correct ?')
        print('\n date : ', date, '\n image_name : ',image_name, '\n origine : ', origine, '\n qualite : ', qualite, 
            '\n resolution_moy : ', resolution_moy, '\n resolution_max : ', resolution_max, '\n resolution_min : ', resolution_min)

        rep = input('\n (yes/no)?')

    balises = [date,image_name,origine,qualite,resolution_moy,resolution_max,resolution_min]

    return balises

def insertToImages(files, balisesImages):
    """
        function to inset data in Images table
        :files: metadata files to parse and adding
        :type: string
        :balisesImages: list of the balises
        :type: list
    """

    try:
        element = []
        for file in files :
            tree = ET.parse(file)
            root = tree.getroot()

            for balise in balisesImages:
                element += [elem.text for elem in root.iter(balise)]
            cur = conn.cursor()
            for i in range (len(element[0])):
                values = (str(int(element[0][i])), str(int(element[1][i])), element[2][i], element[3][i], element[4][i], element[5][i], element[6][i],element[7][i])
                request = """INSERT into images(t0,t1,image,origine,qualite,resolution_moy,resolution_min,resolution_max VALUES {}""".format(values)
                cur.execute(request)
            conn.commit()

    except ET.ParseError as err:
        print(err)

    

def addDataset(conn,fichiers):
    """
        function for adding a Dataset to the data base
        :conn: connexion to the database
        :type: conn
        :fichiers: files to adding to the dataset
        :type: list
        :return: an error message or 200
    """
    #--- updates the data source ---#

    rep = 'yes'

    while rep == 'yes' :

        name = input('provides the name source : ')
        credits  = input('provides the credits format : ')
        home = input('provides the home url : ')
        url = input('provides the url format : ')
        viewer = input('provides the viwer format : ')
        thumbnail = input('provides the thimbnail format : ')
        lowres = input('provides the lowres format : ')
        highres = input('provides the higres format : ')

        print('Is it what you wanting to add ?')
        print('\n name : ',name,'\n credits : ',credits,'\n home : ', home, '\n url :',url,'\n viewer',viewer,
                '\n thimbnail',thumbnail,'\n lowres', lowres, '\n highres : ', highres)

        rep = input('\n (yes/no)?')
    balisesImages = nameOfBaliseImages()
    for f in fichiers:
        insertToImages(f,balisesImages)

    

    return

def completeData(conn,source,fichiers):
    """
        function to complete adding a data to a dataset
        :conn: connexion to the database
        :type: conn
        :fichiers: fiels to adding to the database
        :source: source to complete
        :type: string
        :return: en error message or 200
    """
    
    return


#--- Main -------------------------------------------#

if __name__=="__main__":

    # # On récupère les identifiants de connexion
    # host = input("Quel est l'host ? ")
    # identifiant = input('Quel est votre identifiant ? ')
    # password = input('Quel est votre mot de passe ? ')
    # bddNAme = input('Quel est le nom de la BDD ?)

    host = "localhost"
    user = "postgres"
    password = "2309"
    dbName = "Alegoria"

    conn =  psycopg2.connect(host=host, user=user, password=password, dbname=dbName)

    print("Do you want adding a dataset or complet a dataset ?")
    rep = input("(dataset/complete)?")
    if (rep == "dataset"):

        print('Choose files to adding to the dataset :')

        # Carefull a window will open
        root = Tk()
        fichiers = filedialog.askopenfilenames()
        root.withdraw()
        root.destroy()

        addDataset(conn,fichiers)
    else:
        print("which source do you want to complete ?")
        source = input("(gives the name source) ?")

        print('Choose files to adding to the dataset :')

        # Carefull a window will open
        root = Tk()
        fichiers = filedialog.askopenfilenames()
        root.withdraw()
        root.destroy()
        completeData(conn,source,fichiers)

    conn.close()

    