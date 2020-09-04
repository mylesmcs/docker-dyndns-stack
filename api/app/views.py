from app import app
from flask import jsonify, request
import subprocess
import os

# curl -d '{"ip":"10.0.0.1","hostname":"test"}' -H "Content-Type: application/json" -X POST -i http://localhost:5000/dyn/api/update
#178.79.150.36

SERVER = 'bind'

os.chdir(os.path.dirname(os.path.abspath(__file__)))

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
    ip = data['ip']
    zone = data['zone']
    # action to be performed
    action = f'server {SERVER}\n' \
    f'update add {zone} 3600 A {ip}\n' \
    'send\n'
    # run above action
    run_cmd(action)
    return ('OK')

def run_cmd(action):
    command = f"nsupdate -k ./ddns-key << EOF\n{action}\nEOF\n"
    process = subprocess.run(command, shell=True, check=True, stdout=subprocess.PIPE, universal_newlines=True)
    return process.stdout

