#! /usr/bin/env python
# -*- coding: utf-8 -*-
import urllib
import uuid
import time
import json
import os
from functools import wraps
from datetime import datetime

from alipay import AliPay
from werkzeug.security import generate_password_hash, check_password_hash

from app import db
from app.home.forms import RegisterForm, LoginForm, UserForm, PwdForm, CommentForm, UserRecommedFrom
from app.models import User, Userlog, Preview, Tag, Movie, Comment, Moviecol, UserRecommend
from . import home
from flask import render_template, redirect, url_for, flash, session, request, Response


def cache_key():
    args = request.args
    key = request.path + '?' + urllib.parse.urlencode([
        (k, v) for k in sorted(args) for v in sorted(args.getlist(k))
    ])
    return key


# 用户登陆装饰器
def user_login_check(func):
    @wraps(func)
    def check(*args, **kwargs):
        if "user" not in session:
            return redirect(url_for("home.login", next=request.url))
        return func(*args, **kwargs)

    return check


@home.route("/login/", methods=["GET", "POST"])
def login():
    '''
    用户登陆
    '''
    form = LoginForm()
    if form.validate_on_submit():
        data = form.data
        name = data["name"]
        user = User.query.filter_by(name=name).first()
        if user:
            if check_password_hash(user.pwd, form.pwd.data):
                # 记录登陆信息
                session["user"] = user.name
                session["user_id"] = user.id

                # 用户登陆日志
                userlog = Userlog(
                    user_id=user.id,
                    # ip=request.headers['X-Real-IP']
                    ip=request.remote_addr
                )
                db.session.add(userlog)
                db.session.commit()

                return redirect(url_for("home.index", page=1))
            else:
                flash("密码错误请重试", "success")
                return redirect(url_for("home.login"))
        else:
            flash("用户未注册，请先进行注册", "success")
            time.sleep(5)
            return redirect(url_for("home.register"))
    return render_template("home/login2.html", form=form)


@home.route("/logout/")
@user_login_check
def logout():
    '''
    用户退出登陆
    '''
    session.pop("user")
    session.pop("user_id")
    return redirect(url_for("home.login"))


@home.route("/register/", methods=["GET", "POST"])
def register():
    '''
    注册
    '''
    form = RegisterForm(request.form)
    tt = form.name.data
    count = User.query.filter_by(name=tt).count()
    if count == 0 and form.validate_on_submit():
        data = form.data
        user = User(
            name=data["name"],
            email=data["email"],
            phone=data["phone"],
            pwd=generate_password_hash(data["pwd"]),
            uuid=uuid.uuid4().hex
        )
        db.session.add(user)
        db.session.commit()
        # flash("注册成功！", "ok")
        return redirect(url_for("home.login"))
    # flash("用户名已存在，请重新注册新的用户名")
    return render_template("home/register1.html", form=form)


@home.route("/user/", methods=["GET", "POST"])
@user_login_check
def user():
    '''
    用户信息
    '''
    user = User.query.filter_by(id=session["user_id"]).first()
    form = UserForm()
    if request.method == "GET":
        form.name.data = user.name
        form.email.data = user.email
        form.phone.data = user.phone
        form.info.data = user.info

    if form.validate_on_submit():
        new_name = form.name.data
        if User.query.filter_by(name=new_name).first():
            flash("用户名已存在", "success")
            return redirect(url_for("home.user"))

        user.name = new_name
        user.email = form.email.data
        user.phone = form.phone.data
        user.info = form.info.data

        db.session.add(user)
        db.session.commit()
        flash("用户信息已修改", "success")
    return render_template("home/user.html", form=form, user=user)


@home.route("/pwd/", methods=["GET", "POST"])
@user_login_check
def pwd():
    '''
    修改密码
    '''
    user = User.query.filter_by(id=session["user_id"]).first()
    form = PwdForm()
    if form.validate_on_submit():
        old_pwd = form.old_pwd.data
        if check_password_hash(user.pwd, old_pwd):
            user.pwd = generate_password_hash(form.new_pwd.data)
            db.session.add(user)
            db.session.commit()
            flash("密码已修改,请重新登陆", "success")
            return redirect(url_for("home.login"))
        else:
            flash("原密码错误，请输入正确的密码", "fail")
            return redirect(url_for("home.pwd"))
    return render_template("home/pwd.html", form=form)


@home.route("/comments/", methods=["GET"])
@user_login_check
def comments():
    '''
    用户评论
    '''
    comment_list = Comment.query.filter_by(user_id=session["user_id"]).order_by(Comment.addtime.desc()).limit(7)
    return render_template("home/comments.html", comment_list=comment_list)


@home.route("/loginlog/", methods=["GET"])
@user_login_check
def loginlog():
    # 查询用户登陆日志 且只显示最近的五次登陆
    user_log = Userlog.query.filter_by(user_id=session["user_id"]).order_by(Userlog.addtime.desc()).limit(5)
    return render_template("home/loginlog.html", user_log=user_log)


@home.route("/moviecol/add/", methods=["GET", 'POST'])
@user_login_check
def moviecol_add():
    '''
    用户电影收藏
    :return:
    '''
    movie_id = request.args.get("mid", "")
    user_id = request.args.get("uid", "")
    movie_col = Moviecol.query.filter_by(movie_id=movie_id, user_id=user_id).first()
    if movie_col:
        # 已收藏
        data = json.dumps(dict(status=0))
        return data
    else:
        moviecol = Moviecol(
            movie_id=movie_id,
            user_id=user_id,
        )
        db.session.add(moviecol)
        db.session.commit()

        data = json.dumps(dict(status=1))
        return data


@home.route("/moviecol/<int:page>", methods=['GET'])
@user_login_check
def moviecol(page):
    '''
    电影收藏
    '''
    if page is None:
        page = 1
    user_collection = Moviecol.query.join(User).filter(User.id == session["user_id"]).order_by(
        Moviecol.addtime.desc()).paginate(page=page, per_page=5)
    # count = Moviecol.query.join(User).filter(User.id == session["user_id"]).order_by(
    #     Moviecol.addtime.desc()).count()
    return render_template("home/moviecol.html", user_collection=user_collection)


@home.route("/moviecol/del/<int:movie_id>", methods=['GET'])
@user_login_check
def moviecol_del(movie_id):
    '''
    电影收藏删除
    '''
    movie_col = Moviecol.query.filter_by(movie_id=movie_id).first()
    db.session.delete(movie_col)
    db.session.commit()
    flash("收藏已删除", "success")
    return redirect(url_for("home.moviecol", page=1))


@home.route("/index/<int:page>", methods=["GET"])
def index(page):
    '''
    首页
    '''
    tags = Tag.query.all()
    page_data = Movie.query
    # print(page_data)
    # 标签
    tid = request.args.get("tid", '')
    if tid:
        page_data = page_data.filter_by(tag_id=tid)
    # 星级
    star = request.args.get("star", 0)
    if int(star) != 0:
        page_data = page_data.filter_by(star=int(star))
        # print('='*30)
        # for i in page_data:
        #     print(i)
        #     print(i.tag_id)
    # 时间
    time = request.args.get("time", 0)
    if int(time) != 0:
        if int(time) == 1:
            page_data = page_data.order_by(
                Movie.addtime.desc()
            )
        else:
            page_data = page_data.order_by(
                Movie.addtime.asc()
            )
    # 播放量
    pm = request.args.get("pm", 0)
    if int(pm) != 0:
        if int(pm) == 1:
            page_data = page_data.order_by(
                Movie.playnum.desc()
            )
        else:
            page_data = page_data.order_by(
                Movie.playnum.asc()
            )
    # 评论量
    cm = request.args.get("cm", 0)
    if int(cm) != 0:
        if int(cm) == 1:
            page_data = page_data.order_by(
                Movie.commentnum.desc()
            )
        else:
            page_data = page_data.order_by(
                Movie.commentnum.asc()
            )
    if page is None:
        page = 1
    page_data = page_data.paginate(page=page, per_page=8)
    p = dict(
        tid=tid,
        star=star,
        time=time,
        pm=pm,
        cm=cm,
    )

    # 对电影表进行查询 选出符合条件的热门电影 2-11的电影
    movie_list = Movie.query.order_by(Movie.playnum.desc()).offset(1).limit(10).all()
    movie_special = Movie.query.order_by(Movie.playnum.desc()).first()
    movie_top = Movie.query.order_by(Movie.commentnum.desc()).limit(8)

    return render_template("home/index.html", tags=tags, p=p, page_data=page_data, movie_list=movie_list,
                           movie_top=movie_top, movie_special=movie_special)


@home.route("/", methods=["GET"])
def index1():
    return redirect(url_for("home.index", page=1))


@home.route("/search_click/", methods=['GET'])
def click_search():
    '''
    多条件筛选
    '''
    return redirect(url_for('home.search_show', page=1))


@home.route("/search_show/<int:page>", methods=['GET', 'POST'])
def search_show(page):
    '''
    多条件筛选
    '''
    tags = Tag.query.all()
    page_data = Movie.query
    # print(page_data)
    # 标签
    tid = request.args.get("tid", '')
    if tid:
        page_data = page_data.filter_by(tag_id=tid)
    # 星级
    star = request.args.get("star", 0)
    if int(star) != 0:
        page_data = page_data.filter_by(star=int(star))
        # print('='*30)
        # for i in page_data:
        #     print(i)
        #     print(i.tag_id)
    # 时间
    time = request.args.get("time", 0)
    if int(time) != 0:
        if int(time) == 1:
            page_data = page_data.order_by(
                Movie.addtime.desc()
            )
        else:
            page_data = page_data.order_by(
                Movie.addtime.asc()
            )
    # 播放量
    pm = request.args.get("pm", 0)
    if int(pm) != 0:
        if int(pm) == 1:
            page_data = page_data.order_by(
                Movie.playnum.desc()
            )
        else:
            page_data = page_data.order_by(
                Movie.playnum.asc()
            )
    # 评论量
    cm = request.args.get("cm", 0)
    if int(cm) != 0:
        if int(cm) == 1:
            page_data = page_data.order_by(
                Movie.commentnum.desc()
            )
        else:
            page_data = page_data.order_by(
                Movie.commentnum.asc()
            )
    if page is None:
        page = 1
    page_data = page_data.paginate(page=page, per_page=8)
    p = dict(
        tid=tid,
        star=star,
        time=time,
        pm=pm,
        cm=cm,
    )
    return render_template('home/search_list.html', tags=tags, p=p, page_data=page_data)


@home.route("/animation/", methods=["GET"])
def animation():
    '''
    轮播图
    '''
    data = Preview.query.all()
    return render_template("home/slider-layui.html", data=data)


@home.route("/search/<int:page>", methods=['GET', "POST"])
def search(page):
    '''
    搜索框
    '''
    form = UserRecommedFrom()
    if page is None:
        page = 1
    key = request.args.get("key", "")
    count = Movie.query.filter(Movie.title.contains(key)).count()

    if count == 0:
        # flash("此电影不存在，请填写电影添加信息", "search_fail")
        return redirect(url_for("home.user_recommend"))

    page_data = Movie.query.filter(Movie.title.like('%' + key + '%')).order_by(Movie.addtime.desc()).paginate(page=page,
                                                                                                              per_page=2)
    # aa = Movie.query.filter(Movie.title.like('%' + key + '%')).order_by(Movie.addtime.desc())
    # print(type(aa))
    return render_template("home/search.html", page=1, page_data=page_data, key=key, count=count)


@home.route("/user/recommend/", methods=["GET", "POST"])
# @user_login_check
def user_recommend():
    '''
    用户推荐
    '''
    form = UserRecommedFrom()
    if request.method == 'GET':
        return render_template("home/user_recommend.html", form=form)

    if form.validate_on_submit():
        if "user" in session:
            count = UserRecommend.query.filter_by(title=form.title.data).count()
            if count == 0:
                recommend = UserRecommend(
                    title=form.title.data,
                    protagonist=form.protagonist.data,
                    info=form.info.data,
                    release_time=form.release_time.data,
                    area=form.area.data,
                    addtime=datetime.now(),
                    user_id=session["user_id"]
                )
                db.session.add(recommend)
                db.session.commit()

                # flash("推荐成功", "success")
                return redirect(url_for("home.index", page=1))
        else:
            # time.sleep(3)
            return redirect(url_for("home.login"))
    else:
        return redirect(url_for("home.user_recommend"))


@home.route("/show_recommend_list/<int:page>", methods=["GET"])
def show_recommend(page):
    '''
    推荐展示
    '''
    if page is None:
        page = 1
    rr = UserRecommend.query.filter().paginate(page=1, per_page=8)
    print(type(rr))
    data = UserRecommend.query.filter().paginate(page=page, per_page=2)
    return render_template("home/recommend_show.html", data=data)


@home.route("/play/<int:movie_id>", methods=["GET", "POST"])
def play(movie_id):
    '''
    电影播放
    '''
    movie = Movie.query.get(movie_id)
    form = CommentForm()
    comment_list = Comment.query.filter_by(movie_id=movie_id).order_by(Comment.addtime.desc()).limit(3)
    movie.playnum = movie.playnum + 1
    db.session.add(movie)
    db.session.commit()
    if request.method == "GET":
        return render_template("home/play.html", movie=movie, form=form, comment_list=comment_list)

    if request.method == "POST":
        # 判断是否登陆
        if "user" in session:
            if form.validate_on_submit():
                comments = Comment(
                    content=form.content.data,
                    movie_id=movie.id,
                    user_id=session["user_id"],
                )
                db.session.add(comments)
                db.session.commit()
                flash("评论成功", "success")

                movie.commentnum = movie.commentnum + 1
                db.session.add(movie)
                db.session.commit()

                return render_template("home/play.html", movie=movie, form=form, comment_list=comment_list)
        else:
            flash("用户未登录，请先行登陆", "fail")
            return redirect(url_for("home.login", next=request.url))


@home.route("/pay/", methods=["GET", "POST"])
def pay():
    if request.method == "GET":
        return render_template("home/pay.html")

    # 支付接口测试
    alipay = AliPay(
        appid='2016092500589816',
        app_notify_url=None,  # 默认回调url
        sign_type="RSA2",
        alipay_public_key_path=os.path.join(os.path.dirname(__file__), "alipay_public_2048.txt"),  # 这里换成你的路径
        app_private_key_path=os.path.join(os.path.dirname(__file__), "app_private_2048.txt"),  # 这里换成你的路径
        debug=True
    )

    # 电脑网站支付，需要跳转到https://openapi.alipaydev.com/gateway.do? + order_string
    order_string = alipay.api_alipay_trade_page_pay(
        out_trade_no="20181231",
        total_amount=0.01,
        subject="支付宝测试数据",
        return_url=None,
        notify_url=None  # 可选, 不填则使用默认notify url
    )

    re_url = "https://openapi.alipaydev.com/gateway.do?" + order_string
    return redirect(re_url)


@home.route("/test/", methods=["GET", "POST"])
def advertise():
    return render_template("home/advertise.html")


@home.route("/show_list/", methods=["GET"])
@user_login_check
def my_recommend():
    return render_template("home/my_recommend_list.html")
