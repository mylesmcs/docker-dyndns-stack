from application import app, db
from flask import jsonify, request
from application.model import User, Records
import subprocess
import os

db.create_all()
# curl -d '{"token":"123456","ip":"10.0.0.1","zone":"test.dyn.example.com"}' -H "Content-Type: application/json" -X POST -i http://localhost:5000/dyn/api/update
# 178.79.150.36

SERVER = 'bind'

#os.chdir(os.path.dirname(os.path.abspath(__file__)))

@app.route("/")
def index():

    # Use os.getenv("key") to get environment variables
    #app_name = os.getenv("APP_NAME")


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
    user_update(zone, ip)
    return ('OK')

def run_cmd(action):
    command = f"nsupdate -k {os.path.dirname(os.path.abspath(__file__))}/ddns.key << EOF\n{action}\nEOF\n"
    process = subprocess.run(command, shell=True, check=True, stdout=subprocess.PIPE, universal_newlines=True)
    return process.stdout

def user_update(zone, ip):
    print(f'{zone} -- {ip}')
    db.session.add(Records(value=zone, user_id='1'))
    db.session.commit()
    