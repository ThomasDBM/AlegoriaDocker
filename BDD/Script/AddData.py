""" Script to adding data in the BDD """

#--- Librairies -------------------------------------#

from ast import Try
import psycopg2

#--- Functions --------------------------------------#


def addDataset(conn):
    """
        function for adding a Dataset to the data base
        :conn: connexion to the database
        :type: conn
        :return: an error message or 200
    """

    

    return

def completeData(conn,source):
    """
        function to complete adding a data to a dataset
        :conn: connexion to the database
        :type: conn
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

    conn =  psycopg2.connect(host = host, user =user, password = password, dbname = dbName)

    print("Do you want adding a dataset or complet a dataset ?")
    rep = input("(dataset/complete)?")
    if (rep == "dataset"):
        addDataset(conn)
    else:
        print("which source do you want to complete ?")
        source = input("?")
        completeData(conn,source)

    conn.close()

    