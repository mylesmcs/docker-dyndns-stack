from application import db

class User (db.Model):
    id = db.Column(db.Integer,primary_key=True)
    email = db.Column(db.String(120), unique=True, nullable=False)
    records = db.relationship('Records', backref='user', lazy=True)

    def __repr__(self):
        return f'(User({self.email},{self.records}))'

class Records (db.Model):
    id = db.Column(db.Integer,primary_key=True)
    value = db.Column(db.String(40), nullable=False)
    
    user_id = db.Column(db.String(20), db.ForeignKey('user.id') ,nullable=False)

    def __repr__(self):
        return f'(Records({self.user_id}.{self.value}))'