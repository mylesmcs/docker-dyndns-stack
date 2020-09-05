from flask import Flask
from flask_sqlalchemy import SQLAlchemy

# App Init
app = Flask(__name__)

# Db Init
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:////tmp/test.db'
#mysql://scott:tiger@localhost/mydatabase
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

from application import views

