#! /usr/bin/env python
# -*- coding: utf-8 -*-
import os
from datetime import timedelta

from flask import render_template
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_cache import Cache

app = Flask(__name__)

app.config["SQLALCHEMY_DATABASE_URI"] = "mysql+mysqlconnector://root:123456@127.0.0.1:3306/bishe"
# app.config["SQLALCHEMY_DATABASE_URI"] = "mysql+pymysql://root:root@127.0.0.1:3306/bishe"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config['SEND_FILE_MAX_AGE_DEFAULT '] = timedelta(seconds=1)
app.config["UP_DIR"] = os.path.join(os.path.abspath(os.path.dirname(__file__)), "static/uploads/")
app.config["SECRET_KEY"] = '8d23c4f58b874ce3b0095140dfbe5965'
# app.config["REDIS_URL"] = "redis://127.0.0.1:6379/0"

app.debug = False
db = SQLAlchemy(app)
filesystem = {
    'CACHE_TYPE': 'filesystem',
    'CACHE_DIR': './flask_cache',
    'CACHE_DEFAULT_TIMEOUT': 922337203685477580,
    'CACHE_THRESHOLD': 922337203685477580
}
# cache = Cache(app, config=filesystem)
# cache.init_app(app)

from app.home import home as home_blueprint
from app.admin import admin as admin_blueprint

app.register_blueprint(home_blueprint)
app.register_blueprint(admin_blueprint, url_prefix="/admin")


@app.errorhandler(404)
def page_not_found(error):
    return render_template("home/404.html"), 404
