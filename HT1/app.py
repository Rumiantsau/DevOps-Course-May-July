#import json
import emoji
from flask import Flask, request, jsonify
from marshmallow import Schema, fields, ValidationError

#TODO: make config file for service
sign = 'Made with ❤️ by MikalaiRumiantsau\n'