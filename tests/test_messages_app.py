'''
   Default test for Boilerplate App
'''
import random
import string
from messages.app import app

C = app.test_client()


def __random_string(length=32):
    '''Generates random string'''
    letters = string.ascii_lowercase
    return ''.join(random.choice(letters) for i in range(length))


def test_request_example(client=C):
    '''Checks message field in response data'''
    response = client.get("/messages")
    assert b"message" in response.data


def test_request_json(client=C):
    '''Checks json formatting of message'''
    response = client.get("/messages")
    assert response.json["messages"]


def test_json_returned(client=C):
    '''Sends random message data and ensures it is returned'''
    rnd_str = __random_string()
    response = client.post("/message",
                           json={
                               "message": rnd_str,
                               "user": "dave"})
    assert response.json["user"] == "dave"
    response = client.get("/messages")
    assert rnd_str in str(response.data)
