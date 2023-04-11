import logging
import configparser
from pymongo import MongoClient
from typing import Dict, Any

configParser = configparser.RawConfigParser()   
configFilePath = r'config.ini'
configParser.read(configFilePath)

logLevel=configParser.get('logging', 'logging.level')
logging.basicConfig()
logging.getLogger().setLevel(logLevel)

db_host = configParser.get('db', 'db.url') # This is the db url
db_port = configParser.get('db', 'db.port') # this is the db port
db_user = configParser.get('db', 'db.username') # this is the username (from tf)
db_pwd = configParser.get('db', 'db.password') # this is the password (from tf)
db_name = configParser.get('db', 'db.name') # we set it up
coll_name = configParser.get('db', 'db.coll_name') # we set it up

CONNECTION_STRING = "mongodb+srv://" + db_user + ":" + db_pwd + "@"+ db_host + "/?retryWrites=true&w=majority"  
client = MongoClient(CONNECTION_STRING)
dbname = client[db_name]


def insertItems(item):
    collection_name = dbname[coll_name]
    logging.info("New Tweet : " + str(item))
    try:
        _id = collection_name.insert_one(item)
        return {'status':'success', '_id':_id, 'success': True}
    except:
        raise Exception("Couldn't insert the tweet")
