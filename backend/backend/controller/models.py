from datetime import datetime
import base64
from controller import *
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy_serializer import SerializerMixin

db = SQLAlchemy(app)


#################################
# HELPER FUNCTIONS
#################################

def remove_user_binary(user):
    user.image = base64.b64encode(user.image)
    json_data = user.to_dict()
    del json_data['image']
    return json_data


#################################
# FUNCTIONS
#################################

# USER

def add_user(location_id, name, image, embedding):
    image_bytes = base64.b64decode(image)
    user = User(location_id=location_id, name=name, image=image_bytes, embedding=embedding)
    #user = User(location_id=location_id, name=name, image=image, embedding=embedding)
    db.session.add(user)
    db.session.commit()


def login_user(name):
    user = User.query.filter_by(name=name).first()
    if user:
        return user.as_dict()
    return ''


def get_user(user_id):
    user = User.query.filter_by(id=user_id).first()
    if user:
        return user.as_dict()
    return ''


def delete_user(user_id):
    user = User.query.filter_by(id=user_id).first()
    db.session.delete(user)
    db.session.commit()


def get_users():
    users = []
    for user in User.query.order_by(User.id).all():
        users.append(user.as_dict())
    return users


# ROBO

def add_robo(name, ip):
    robo = Robo(name=name, ip=ip)
    db.session.add(robo)
    db.session.commit()
    return robo.to_dict()


def delete_robo(robo_id):
    robo = Robo.query.filter_by(id=robo_id).first()
    db.session.delete(robo)
    db.session.commit()


def get_robos():
    robos = []
    for i in Robo.query.order_by(Robo.id).all():
        robos.append(i.to_dict())
    return robos


# ROOM

def add_room(robo_id, name):
    room = Room(robo_id=robo_id, name=name)
    db.session.add(room)
    db.session.commit()


def get_room(name):
    room = Room.query.filter_by(name=name).first()
    if room:
        return room.to_dict()
    return ''


def delete_room(room_id):
    room = Room.query.filter_by(id=room_id).first()
    db.session.delete(room)
    db.session.commit()


def update_robo(robo_id, room_id):
    room = Room.query.filter_by(id=room_id).first()
    room.robo_id = robo_id
    db.session.commit()


def get_rooms():
    rooms = []
    for i in Room.query.order_by(Room.id).all():
        rooms.append(i.to_dict())
    return rooms


# LOCATION

def add_location(room_id, name, x, y):
    location = Location(room_id=room_id, name=name, x=x, y=y)
    db.session.add(location)
    db.session.commit()
    return location.to_dict()


def get_location(location_id):
    location = Location.query.filter_by(id=location_id).first()
    if location:
        return location.to_dict()
    return ''


def delete_location(location_id):
    location = Location.query.filter_by(id=location_id).first()
    db.session.delete(location)
    db.session.commit()


def update_location(user_id, location_id):
    user = User.query.filter_by(id=user_id).first()
    user.location_id = location_id
    db.session.commit()


def get_locations():
    locations = []
    for i in Location.query.order_by(Location.id).all():
        locations.append(i.to_dict())
    return locations


# MESSAGE

def send_message(from_user, to_user, subject, message):
    message = Message(from_user=from_user, to_user=to_user, subject=subject, message=message)
    db.session.add(message)
    db.session.commit()

    user = User.query.filter_by(id=to_user).first()
    location = Location.query.filter_by(id=user.location_id).first()
    room = Room.query.filter_by(id=location.room_id).first()
    robo = Room.query.filter_by(id=room.robo_id).first()

    data = {"user": [user.name, user.embedding], "x":location.x, "y":location.y}
    return data


#################################
# MODELS
#################################


class Location(db.Model, SerializerMixin):
    __tablename__ = 'location'
    id = db.Column(db.Integer, primary_key=True)
    room_id = db.Column(db.Integer, db.ForeignKey('room.id', ondelete='CASCADE'), nullable=False)
    name = db.Column(db.String(80), nullable=False)
    x = db.Column(db.FLOAT, nullable=False)
    y = db.Column(db.FLOAT, nullable=False)

    def __repr__(self):
        return '<Location %r>' % self.name


class Robo(db.Model, SerializerMixin):
    __tablename__ = 'robo'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), nullable=False)
    ip = db.Column(db.String(80), nullable=False)

    def __repr__(self):
        return '<Robo %r>' % self.name


class Room(db.Model, SerializerMixin):
    __tablename__ = 'room'
    id = db.Column(db.Integer, primary_key=True)
    robo_id = db.Column(db.Integer, db.ForeignKey('robo.id', ondelete='SET NULL'), nullable=True)
    name = db.Column(db.String(80), nullable=False)
    pgm = db.Column(db.Binary, nullable=True)
    yaml = db.Column(db.Text, nullable=True)
    scanned = db.Column(db.Boolean, default=False, nullable=True)

    def __repr__(self):
        return '<Room %r>' % self.name


class User(db.Model, SerializerMixin):
    __tablename__ = 'user'
    id = db.Column(db.Integer, primary_key=True)
    location_id = db.Column(db.Integer, db.ForeignKey('location.id', ondelete='SET NULL'), nullable=True)
    name = db.Column(db.String(80), nullable=False)
    image = db.Column(db.Binary, nullable=True)
    embedding = db.Column(db.Text, nullable=True)

    def as_dict(self):
        return {
            "id": self.id,
            "location_id": self.location_id,
            "name": self.name,
        }

    def __repr__(self):
        return '<User %r>' % self.name


class Message(db.Model, SerializerMixin):
    __tablename__ = 'message'
    id = db.Column(db.Integer, primary_key=True)
    from_user = db.Column(db.Integer, db.ForeignKey('user.id', ondelete='CASCADE'), nullable=False)
    to_user = db.Column(db.Integer, db.ForeignKey('user.id', ondelete='CASCADE'), nullable=False)
    subject = db.Column(db.String(80), nullable=False)
    message = db.Column(db.String(255), nullable=False)
    datetime = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    received = db.Column(db.Boolean, nullable=True, default=False)

    def __repr__(self):
        return '<Message %r>' % self.to_user



