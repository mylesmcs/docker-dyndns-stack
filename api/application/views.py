from application import app, db
from flask import jsonify, request
from app.model import User
import subprocess
import os

# curl -d '{"token":"123456","ip":"10.0.0.1","zone":"test.dyn.example.com"}' -H "Content-Type: application/json" -X POST -i http://localhost:5000/dyn/api/update
#178.79.150.36

SERVER = 'bind'

#os.chdir(os.path.dirname(os.path.abspath(__file__)))

@app.route("/")
def index():

    # Use os.getenv("key") to get environment variables
    app_name = os.getenv("APP_NAME")

    if app_name:
        return f"Hello from {app_name} running in a Docker container behind Nginx!"

    return "Hello from Flask"


@app.route('/dyn/api/update', methods=['POST'])
def get_test():
    #get params from POST request
    data = request.get_json()
    try:
        token = data['token']
        ip = data['ip']
        zone = data['zone']
    except:
        return 'Not all params have been supplied'
    # action to be performed
    action = f'server {SERVER}\n' \
    f'update add {zone} 60 A {ip}\n' \
    'send\n'
    # run above action
    run_cmd(action)
    user_update(token, zone, ip)
    return ('OK')

def run_cmd(action):
    command = f"nsupdate -k {os.path.dirname(os.path.abspath(__file__))}/ddns-key << EOF\n{action}\nEOF\n"
    process = subprocess.run(command, shell=True, check=True, stdout=subprocess.PIPE, universal_newlines=True)
    return process.stdout

def user_update(token, zone, ip):
    print(f'{token} -- {zone} -- {ip}')
