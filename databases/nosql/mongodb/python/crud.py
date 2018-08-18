import pymongo
import datetime

client = pymongo.MongoClient(host=['mongodb:27017'])
db = client['olx']
collection = db['cars']

car = {'title': 'Gol Completo', 'ports': 4, 'year': '2015', 'date': datetime.datetime.now()}
collection.insert(car)

result = collection.find_one({'title': 'Gol Completo'})

print(result)
