import emoji
from flask import Flask, request, jsonify
from marshmallow import Schema, fields, ValidationError
#we import waitress here.
from waitress import serve

#TODO: make config file for service
sign = 'Made with LOVE by MikalaiRumiantsau\n'

def findEmoji(text):
    r = emoji.emojize(':' + text + ':')
    return(r.replace(':',''))

class BaseSchema(Schema):
      animal = fields.String(required=True)
      sound = fields.String(required=True)
      count = fields.Integer(required=True)

app = Flask(__name__)
app.debug = True
@app.route('/', methods=['GET', 'POST'])
def index():
    #TODO: make somethink to work with GET
    if request.method == "GET":
        return 'Your method is GET\n'
    #TODO: make somethink to work with POST
    if request.method == "POST":
        data = request.get_json(force=True)
        schema = BaseSchema()
        try:
            #TODO: validation of entered data
            result = schema.load(data)
            if int(data['count']) < 0:
                return (sign)
        except ValidationError as err:
            return jsonify(err.messages),400
        # TODO: formation and output of the received data
        str = ''
        n=int(data['count'])
        emoji = findEmoji(data['animal'])
        if emoji == data['animal']:
            return '\n The emoji for input animal does not exist \n'
        for i in range (0, n):
          str += '{animal} says {sound}\n'.format(animal=findEmoji(data['animal']), sound=data['sound'])
    return (str+sign),200

if __name__ == "__main__":
   server(app, host='0.0.0.0', port=5000, url_scheme='https')
