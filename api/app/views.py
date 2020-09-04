from app import app
from flask import jsonify, request
import subprocess
import os

# curl -d '{"ip":"10.0.0.1","hostname":"test"}' -H "Content-Type: application/json" -X POST -i http://localhost:5000/dyn/api/update
#178.79.150.36

SERVER = '127.0.0.1'
ZONE = 'dyn.example.com'

cmd = f'server {SERVER}\n' \
    f'zone {ZONE}\n'
    
print(cmd)

command = f"nsupdate << EOF\n{cmd}\nEOF\n"

subprocess.call(command, shell=True)


tasks = [
    {
        'id': 1,
        'title': u'Buy groceries',
        'description': u'Milk, Cheese, Pizza, Fruit, Tylenol', 
        'done': False
    },
    {
        'id': 2,
        'title': u'Learn Python',
        'description': u'Need to find a good Python tutorial on the web', 
        'done': False
    }
]

@app.route("/")
def index():

    # Use os.getenv("key") to get environment variables
    app_name = os.getenv("APP_NAME")

    if app_name:
        return f"Hello from {app_name} running in a Docker container behind Nginx!"

    return "Hello from Flask"


@app.route('/dyn/api/update', methods=['POST'])
def get_test():
    data = request.get_json()
    ipAddr = data['ip']
    hostName = data['hostname']
    print(f"{hostName} --- {ipAddr}")
    return ('OK')