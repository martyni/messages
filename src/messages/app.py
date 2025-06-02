'''Message flask app'''
import uuid
from datetime import datetime
from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///messages.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)
GOOD_DATA = {
    "user": "<username>",
    "message": "<message>",
    "url": "<url(optional)>",
}


class Message(db.Model):  # pylint: disable=too-few-public-methods
    '''Message class to hold message data'''
    id = db.Column(db.String(36), primary_key=True,
                   default=lambda: str(uuid.uuid4()))
    user = db.Column(db.String(100), nullable=False)
    message = db.Column(db.Text, nullable=False)
    date = db.Column(db.DateTime, default=datetime.utcnow)
    url = db.Column(db.Text, nullable=True)

    def to_dict(self):
        '''Return sql data as dict'''
        return {
            "id": self.id,
            "user": self.user,
            "message": self.message,
            "date": self.date.isoformat(),
            "url": self.url
        }


@app.route('/messages', methods=['GET'])
def get_paginated_messages():
    '''Return paginated messages based on page and per_page values'''
    page = int(request.args.get('page')) if request.args.get('page') else 1
    per_page = int(request.args.get('per_page')
                   ) if request.args.get('per_page') else 5
    messages = Message.query.order_by(Message.date.desc()) \
        .paginate(page=page,
                  per_page=per_page,
                  error_out=False)
    return jsonify({
        "messages": [msg.to_dict() for msg in messages.items],
        "total": messages.total,
        "page": messages.page,
        "pages": messages.pages,
        "next_page": f'/messages?page={ page + 1 }&per_page={ per_page }'
    }), 200


@app.route('/message', methods=['POST'])
def receive_message():
    '''URL for recieving messages'''
    data = request.get_json()
    print(data)

    if not data or 'user' not in data or 'message' not in data:
        return jsonify({
            'error': 'Invalid input',
            'recieved': f'{data}',
            'expected': f'{GOOD_DATA}'}), 400

    new_msg = Message(user=data['user'],
                      message=data['message'], url=data.get('url'))
    db.session.add(new_msg)
    db.session.commit()

    return jsonify(new_msg.to_dict()), 201


def main():
    '''Entry point for test container'''
    with app.app_context():
        db.create_all()
    app.run(host='0.0.0.0', debug=True)


if __name__ == '__main__':
    main()
