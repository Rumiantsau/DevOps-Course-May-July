#import json
import emoji
from flask import Flask, request, jsonify
from marshmallow import Schema, fields, ValidationError

#TODO: make config file for service
sign = 'Made with ❤️ by MikalaiRumiantsau\n'

def findEmoji(text):
    r = emoji.emojize(':' + text + ':')
    return(r.replace(':',''))

class BaseSchema(Schema):
      animal = fields.String(required=True)
      sound = fields.String(required=True)
      count = fields.Integer(required=True)

app = Flask(__name__)