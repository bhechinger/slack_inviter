#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from flask import Flask, render_template, request
import locale, json, requests
import evelink.api  # Raw API access
import evelink.char # Wrapped API access for the /char/ API path
import evelink.eve  # Wrapped API access for the /eve/ API path
#from flask_bootstrap import Bootstrap

locale.setlocale(locale.LC_ALL, 'en_US')
app = Flask(__name__)
#Bootstrap(app)

def send_invite(email):
    data = {"email": email}
    headers = {'content-type': 'application/json'}
    resp = requests.post('https://aba-invite.herokuapp.com/invitations', auth=('lUz5eB2tyb7eyg3teiRj', 'rYot3ik0yIf6olk0eB1Zep2hoJ6ek6'), data=json.dumps(data), headers=headers)
    print("Status: {resp}".format(resp=resp.status_code))
    return resp.status_code


@app.route('/')
def index():
    return "Nothing to see here, move along!"

@app.route('/slack')
def slack():
    return render_template('slack.html')

@app.route('/invite', methods=['POST'])
def invite():
    if request.method == 'POST':
        try:
            api = evelink.api.API(api_key=(request.form.get('api_keyid'), request.form.get('api_vcode')))
            chars = map(lambda x:(x[0], x[1]["alliance"]["id"]), evelink.account.Account(api=api).characters().result.items())
            for char in chars:
                if char[1] == 99004295:
                    send_invite(request.form.get('email'))
                    return render_template('invite.html', email=request.form.get('email'), error=None)

            return render_template('invite.html', error="Not an alliance member!")
        except Exception as e:
            return render_template('invite.html', error=e)

if __name__ == '__main__':
    app.run(debug=True)
