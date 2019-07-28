#! /usr/bin/env python
# -*- coding: utf-8 -*-

import uuid
from datetime import datetime
import os
from functools import wraps

import pyecharts
from django.http import HttpResponse
from example.commons import Faker
from jinja2 import Markup, Environment, FileSystemLoader
from pyecharts.globals import CurrentConfig
from werkzeug.security import check_password_hash
from werkzeug.utils import secure_filename
from app.models import Admin, Tag, Movie, Preview, User, Oplog, Adminlog, Comment, Moviecol, Userlog
from . import admin
from flask import render_template, redirect, url_for, request, flash, session
from app.admin.forms import LoginForm, TagAddForm, MovieForm, PreviewForm, PwdForm, AdminForm
from app import db, app
from ..utils.object_basic import Oss
from pyecharts.charts import Pie, Page, Bar, Geo


# 登陆装饰器
def login_check(func):
    @wraps(func)
    def decorated_function(*args, **kwargs):
        if "admin" not in session:
            return redirect(url_for("admin.login"))
        return func(*args, **kwargs)

    return decorated_function


def change_filename(filename):
    """
    修改文件名称
    """
    print(filename)
    fileinfo = os.path.splitext(filename)  # xxx.mo4 ----》 xxx mp4
    filename = datetime.now().strftime("%Y%m%d%H%M%S") + str(uuid.uuid4().hex) + fileinfo[-1]
    # print(filename)
    return filename


#  时间转换--上下文管理器
@app.context_processor
def time_transform():
    data = dict(
        online_time=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    )
    return data


@admin.route("/")
@login_check
def index():
    '''
    网站后台首页
    '''
    return render_template('admin/index.html', myechart=admin_control())


@admin.route("/aaa/")
@login_check
def pie():
    '''
    测试用例
    '''
    return render_template('admin/render.html')


@admin.route("/index1/")
@login_check
def index1():
    '''后台首页 地图'''
    return render_template('admin/index2.html', myechart=admin_controlgeo())


@admin.route("/login/", methods=["GET", "POST"])
def login():
    '''登陆'''
    form = LoginForm(request.form)
    if form.validate_on_submit():
        account = Admin.query.filter_by(name=form.account.data).first()
        if account is not None:
            # print(form.pwd.data)
            # 进行密码判断
            # if check_password_hash(account.pwd, 'account.pwd') == form.pwd.data:
            if check_password_hash(account.pwd, form.pwd.data):
                # if form.pwd.data == account.pwd:
                session["admin"] = form.account.data
                session["admin_id"] = account.id

                adminlog = Adminlog(
                    admin_id=account.id,
                    ip=request.remote_addr
                    # ip=request.['X-Real-IP']
                )
                db.session.add(adminlog)
                db.session.commit()

                return redirect(url_for("admin.index"))
            else:
                flash("密码错误请重试")
                return redirect(url_for("admin.login"))

        else:
            # flash("账户不存在，请注册账户")
            return redirect(url_for("admin.login"))

    return render_template('admin/login.html', form=form)


@admin.route("/logout/")
@login_check
def logout():
    '''登出'''
    session.pop("admin", None)
    session.pop("admin_id", None)
    return redirect(url_for("admin.login"))


@admin.route("/pwd", methods=["GET", "POST"])
@login_check
def pwd():
    '''密码修改'''
    form = PwdForm(request.form)
    from werkzeug.security import generate_password_hash
    if form.validate_on_submit():
        # 判断原密码是否正确
        old_pwd = form.old_pwd.data
        admin = Admin.query.filter_by(name=session["admin"]).first()
        # print(old_pwd)
        # print(admin.pwd)
        # # print(generate_password_hash(old_pwd))
        # print(check_password_hash(admin.pwd, old_pwd))
        # if admin.pwd == old_pwd:
        if check_password_hash(admin.pwd, old_pwd):
            new_pwd = form.new_pwd.data
            admin.pwd = generate_password_hash(new_pwd)
            # admin.pwd = new_pwd
            db.session.add(admin)
            db.session.commit()
            flash("密码已成功修改,请重新登陆", "success")
            return redirect(url_for("admin.logout"))
        flash("原密码错误，请输入正确的密码", "fail")
        return redirect(url_for("admin.pwd"))
    return render_template('admin/pwd.html', form=form)


@admin.route("/search", methods=["GET", "POST"])
@login_check
def search():
    '''
    test demo fail!!!
    '''
    key = request.args.get("key-word", "")
    if key:
        pass


@admin.route("/tag/add/", methods=["GET", "POST"])
@login_check
def tag_add():
    '''标签添加'''
    form = TagAddForm(request.form)
    if form.validate_on_submit():
        print(form.name.data)
        tag = Tag.query.filter_by(name=form.name.data).count()
        if tag == 1:
            flash("标签已存在", "error")
            return redirect(url_for("admin.tag_add"))
        else:
            tag = Tag(
                name=form.name.data
            )
            db.session.add(tag)
            db.session.commit()
            flash("标签已成功添加", "success")

            oplog = Oplog(
                admin_id=session["admin_id"],
                ip=request.remote_addr,
                reason="添加标签%s" % form.name.data
            )
            db.session.add(oplog)
            db.session.commit()

            return redirect(url_for("admin.tag_list", page=1))
    return render_template("admin/tag_add.html", form=form)


@admin.route("/tag/list/<int:page>", methods=["GET"])
@login_check
def tag_list(page=None):
    '''电影标签列表展示'''
    if page is None:
        page = 1
    page_tags = Tag.query.order_by("id").paginate(page=page, per_page=8)
    return render_template("admin/tag_list.html", page_tags=page_tags)


@admin.route("/tag/edit/<int:id>", methods=["GET", "POST"])
@login_check
def tag_edit(id=None):
    '''
    电影标签 编辑
    '''
    form = TagAddForm(request.form)
    tag = Tag.query.filter_by(id=id).first()
    if tag:
        form = TagAddForm()
        if form.validate_on_submit():
            new_value = form.name.data
            if Tag.query.filter_by(name=new_value).first():
                flash("标签已存在，请重新命名", "success")
                return redirect(url_for("admin.tag_edit", id=id))
            tag.name = new_value
            db.session.add(tag)
            db.session.commit()
            flash("已成功修改", "success")

            oplog = Oplog(
                admin_id=session["admin_id"],
                ip=request.remote_addr,
                reason="编辑标签%s" % form.name.data
            )
            db.session.add(oplog)
            db.session.commit()

            return redirect(url_for("admin.tag_list", page=1))
    return render_template("admin/tag_add.html", form=form)


@admin.route("/tag/del/<int:tag_id>", methods=["GET"])
@login_check
def tag_del(tag_id):
    '''
    标签删除
    '''
    tag = Tag.query.filter_by(id=tag_id).first_or_404()
    db.session.delete(tag)
    db.session.commit()
    flash("标签已删除", "success")

    oplog = Oplog(
        admin_id=session["admin_id"],
        ip=request.remote_addr,
        reason="删除标签%s" % tag.name
    )
    db.session.add(oplog)
    db.session.commit()
    return redirect(url_for('admin.tag_list', page=1))


@admin.route("/movie/add/", methods=["GET", "POST"])
@login_check
def movie_add():
    '''
    电影添加
    '''
    form = MovieForm()
    if form.validate_on_submit():
        print(request.files["url"].filename)
        file_url = secure_filename(request.files["url"].filename)
        file_logo = secure_filename(request.files["logo"].filename)
        if not os.path.exists(app.config["UP_DIR"]):
            os.makedirs(app.config["UP_DIR"])
            os.chmod(app.config["UP_DIR"], 'rw')
        url = change_filename(file_url)
        logo = change_filename(file_logo)
        form.url.data.save(app.config["UP_DIR"] + url)  
        form.logo.data.save(app.config["UP_DIR"] + logo)
        movie = Movie(
            title=form.title.data,
            url=url,
            info=form.info.data,
            logo=logo,
            star=int(form.star.data),
            playnum=0,
            commentnum=0,
            tag_id=int(form.tag_id.data),
            area=form.area.data,
            release_time=form.release_time.data,
            length=form.length.data,
        )
        db.session.add(movie)
        db.session.commit()

        # 将图片 视频上传到oss空间中
        oss = Oss()
        oss.putfile(url, app.config['UP_DIR'] + url)
        oss.putfile(url, app.config['UP_DIR'] + logo)
        print(url)

        flash("添加电影成功！", "ok")
        return redirect(url_for('admin.movie_list', page=1))
    return render_template("admin/movie_add.html", form=form)


@admin.route("/movie/del/<int:movieid>", methods=["GET", "POST"])
@login_check
def movie_del(movieid):
    '''
    电影删除
    :param movieid: 需要删除的电影的id
    :return:
    '''
    movie = Movie.query.filter_by(id=movieid).first_or_404()  # 需要将值从中取出 first()
    db.session.delete(movie)
    db.session.commit()
    flash("电影已删除", "success")
    return redirect(url_for("admin.movie_list", page=1))


@admin.route("/movie/edit/<int:movieid>", methods=["GET", "POST"])
@login_check
def movie_edit(movieid=None):
    '''
    电影编辑
    '''
    form = MovieForm()
    movie = Movie.query.filter_by(id=movieid).first_or_404()
    if request.method == "GET":
        return render_template("admin/movie_edit.html", movieid=movie.id, form=form, movie=movie)

    if form.validate_on_submit():
        # new_movie_count = Movie.query.filter_by(title=form.title.data).count()
        # if new_movie_count == 1:
        #     flash("电影已存在请勿重复添加", "fail")
        #     return render_template("admin/movie_edit.html", movieid=movie.id, form=form, movie=movie)
        file_url = secure_filename(request.files["url"].filename)
        file_logo = secure_filename(request.files["logo"].filename)
        url = change_filename(file_url)
        logo = change_filename(file_logo)
        form.url.data.save(app.config["UP_DIR"] + url)
        form.logo.data.save(app.config["UP_DIR"] + logo)
        movie = Movie(
            title=form.title.data,
            url=url,
            info=form.info.data,
            logo=logo,
            star=int(form.star.data),
            playnum=0,
            commentnum=0,
            tag_id=int(form.tag_id.data),
            area=form.area.data,
            release_time=form.release_time.data,
            length=form.length.data,
        )
        db.session.add(movie)
        db.session.commit()

        movie_del = Movie.query.filter_by(id=movieid).first_or_404()  # 需要将值从中取出 first()
        db.session.delete(movie_del)
        db.session.commit()

        flash("已成功修改电影信息", "success")
        return redirect(url_for("admin.movie_list", page=1))
    return render_template("admin/movie_edit.html", form=form)


@admin.route("/movie/list/<int:page>", methods=["GET"])
@login_check
def movie_list(page=None):
    if page is None:
        page = 1
    page_data = Movie.query.order_by('id').paginate(page=page, per_page=10)
    return render_template("admin/movie_list.html", page_data=page_data)


@admin.route("/preview/add/", methods=["GET", "POST"])
@login_check
def preview_add():
    '''
    添加预告
    '''
    form = PreviewForm()
    if request.method == "GET":
        return render_template("admin/preview_add.html", form=form)

    if form.validate_on_submit():
        if Preview.query.filter_by(title=form.title.data).first():
            flash("预告已存在，请勿重复添加", "fail")
            return redirect(url_for("admin.preview_add"))

        file_logo = secure_filename(request.files["logo"].filename)
        logo = change_filename(file_logo)

        if not os.path.exists(app.config["UP_DIR"]):
            os.makedirs(app.config["UP_DIR"])
            os.chmod(app.config["UP_DIR"], 'rw')
        form.logo.data.save(app.config["UP_DIR"] + logo)
        preview = Preview(
            title=form.title.data,
            logo=logo
        )
        db.session.add(preview)
        db.session.commit()
        flash("预告影片已添加", 'success')
        return redirect(url_for("admin.preview_add"))
    return render_template("admin/preview_add.html", form=form)


@admin.route("/preview/list/<int:page>")
@login_check
def preview_list(page):
    '''
    预告列表
    '''
    if page is None:
        page = 1
    page_previews = Preview.query.order_by("id").paginate(page=page, per_page=5)
    return render_template("admin/preview_list.html", page_previews=page_previews)


@admin.route("/preview/del/<int:pre_id>", methods=["GET"])
@login_check
def preview_del(pre_id):
    '''
    预告删除
    '''
    pre_view = Preview.query.filter_by(id=pre_id).first()
    db.session.delete(pre_view)
    db.session.commit()
    flash("预告已删除", "success")
    return redirect(url_for("admin.preview_list", page=1))


@admin.route("/preview/edit/<int:pre_id>", methods=["GET", "POST"])
@login_check
def preview_edit(pre_id):
    '''
    预告编辑
    '''
    form = PreviewForm()
    preview = Preview.query.filter_by(id=pre_id).first()
    if request.method == "GET":
        return render_template("admin/preview_edit.html", form=form, preview=preview)

    if form.validate_on_submit():
        if Preview.query.filter_by(title=form.title.data).first():
            flash("预告已存在，请勿重复添加", "fail")
            return redirect(url_for("admin.preview_list", page=1))

        file_logo = secure_filename(request.files["logo"].filename)
        logo = change_filename(file_logo)

        if not os.path.exists(app.config["UP_DIR"]):
            os.makedirs(app.config["UP_DIR"])
            os.chmod(app.config["UP_DIR"], "rw")

        form.logo.data.save(app.config["UP_DIR"] + logo)
        preview.title = form.title.data
        preview.logo = logo
        db.session.add(preview)
        db.session.commit()
        flash("预告已修改", "success")
        return redirect(url_for("admin.preview_list", page=1))
    return render_template("admin/preview_edit.html", pre_id=pre_id, form=form, preview=preview)


@admin.route("/comment/list/<int:page>", methods=['GET'])
@login_check
def comment_list(page):
    '''
    评论列表
    '''
    if page is None:
        page = 1
    page_data = Comment.query.join(User).join(Movie).filter(Movie.id == Comment.movie_id,
                                                            Comment.user_id == User.id).order_by(
        Comment.addtime.desc()
    ).paginate(page=page, per_page=5)
    return render_template("admin/comment_list.html", page_data=page_data)


@admin.route("/comment/del/<int:comment_id>", methods=['GET'])
@login_check
def comment_del(comment_id):
    '''
    评论删除
    '''
    comment = Comment.query.get(comment_id)
    db.session.delete(comment)
    db.session.commit()
    flash("评论已删除", "success")
    return redirect(url_for("admin.comment_list", page=1))


@admin.route("/user/list/<int:page>", methods=["GET"])
@login_check
def user_list(page=None):
    '''
    用户列表
    '''
    if page is None:
        page = 1
    page_data = User.query.order_by("id").paginate(page=page, per_page=5)
    return render_template("admin/user_list.html", page_data=page_data)


@admin.route("/user/detail/<int:userid>", methods=["GET"])
@login_check
def user_detail(userid):
    '''
    用户详情
    '''
    user = User.query.get_or_404(userid)
    return render_template("admin/user_view.html", user=user)


@admin.route("/user/del/<int:userid>", methods=["GET"])
@login_check
def user_del(userid):
    '''
    用户删除
    '''
    user = User.query.get_or_404(userid)
    print(user)
    db.session.delete(user)
    db.session.commit()
    flash("用户已删除", "success")
    return redirect(url_for("admin.user_list", page=1))


@admin.route("/movie_col/list/<int:page>", methods=["GET"])
@login_check
def moviecol_list(page):
    '''
    收藏列表
    '''
    if page is None:
        page = 1
    page_data = Moviecol.query.join(User).join(Movie).filter(Movie.id == Moviecol.movie_id,
                                                             Moviecol.user_id == User.id).order_by(
        Moviecol.addtime.desc()
    ).paginate(page=page, per_page=5)
    return render_template("admin/moviecol_list.html", page_data=page_data)


@admin.route("/movie_col/del/<int:moviecol_id>", methods=["GET"])
@login_check
def moviecol_del(moviecol_id):
    '''
    收藏删除
    '''
    movie_col = Moviecol.query.get_or_404(moviecol_id)
    db.session.delete(movie_col)
    db.session.commit()
    flash("收藏已删除", "success")
    return redirect(url_for("admin.moviecol_list", page=1))


@admin.route("/oplog/list/<int:page>", methods=["GET"])
@login_check
def oplog_list(page=None):
    if page is None:
        page = 1
    page_data = Oplog.query.join(Admin).filter(Admin.id == Oplog.admin_id).order_by(Oplog.addtime.desc()).paginate(
        page=page,
        per_page=5)
    return render_template("admin/oplog_list.html", page_data=page_data)


@admin.route("/adminloginlog/list/<int:page>")
@login_check
def adminloginlog_list(page):
    if page is None:
        page = 1
    page_data = Adminlog.query.join(
        Admin
    ).filter(
        Adminlog.admin_id == Admin.id
    ).order_by(
        Adminlog.addtime.desc()
    ).paginate(page=page, per_page=5)
    return render_template("admin/adminloginlog_list.html", page_data=page_data)


@admin.route("/userloginlog/list/<int:page>", methods=["GET"])
@login_check
def userloginlog_list(page):
    if page is None:
        page = 1
    data_page = Userlog.query.order_by(Userlog.addtime.desc()).paginate(page=page, per_page=5)
    return render_template("admin/userloginlog_list.html", data_page=data_page)


@admin.route("/add/", methods=["GET", "POST"])
@login_check
def admin_add():
    '''
    添加管理员
    '''
    form = AdminForm()
    from werkzeug.security import generate_password_hash
    if form.validate_on_submit():
        admin = Admin(
            name=form.name.data,
            pwd=generate_password_hash(form.pwd.data),
            # role_id=form.role_id.data,
            is_super=1
        )
        db.session.add(admin)
        db.session.commit()
        flash("添加管理员成功！", "success")
    return render_template("admin/admin_add.html", form=form)


@admin.route("/admin/list/<int:page>/", methods=["GET"])
@login_check
def admin_list(page=None):
    if page is None:
        page = 1
    page_data = Admin.query.order_by(
        Admin.addtime.desc()
    ).paginate(page=page, per_page=5)
    return render_template("admin/admin_list.html", page_data=page_data)


CurrentConfig.GLOBAL_ENV = Environment(loader=FileSystemLoader("app/templates/admin/templates"))


@admin.route("/pie/", methods=['GET'])
@login_check
def admin_control():
    '''绘制 电影相关标签饼图'''

    # 获取电影标签
    tags = Tag.query.all()
    tag_id = [i.id for i in tags]
    # print(tag_id)
    tag_name = [i.name for i in tags]
    # print(tag_name)
    t_movie = []
    for i in tag_id:
        # 根据 获取所有电影的标签数量
        try:
            movies_count = Movie.query.filter_by(tag_id=i).count()
            t_movie.append(movies_count)
        except Exception as e:
            t_movie.append(0)

    pie = Pie()
    pie.add("标签-电影数据统计", [list(z) for z in zip(tag_name, t_movie)])

    return pie.render_embed()
    # return redirect(url_for('admin.index'))


# pyecharts.options.InitOpts
# pyecharts.options.ToolBoxFeatureOpts
from pyecharts import options as opts


def admin_controlgeo():
    gao_key = 'a530f43cd595aefd254620e2e8e19ec5'
    ip_list = Userlog.query.all()
    t_list = []

    chongfu_city = []
    for ip in ip_list:
        if ip.ip == '127.0.0.1':
            pass
        else:

            request_url = "https://restapi.amap.com/v3/ip?ip={ip}&output=json&key={key}".format(ip=ip.ip, key=gao_key)

            import requests
            data_json = requests.get(request_url)
            data = data_json.json()
            chongfu_city.append(data['city'])

            # 对出现的城市和出现次数进行统计
            if len(t_list) == 0:
                t_list.append(data['city'])
            else:
                # 对城市信息进行过滤
                if data['city'] in t_list:
                    pass
                else:
                    t_list.append(data['city'])
            # print(t_list)

    from collections import Counter
    # 对出现的城市进行次数统计
    result = Counter(chongfu_city)
    # print(result)
    # print(type(result))
    # print(result.items())
    x = [list(i) for i in result.items()]
    c = (
        Geo()
            .add_schema(maptype="china")
            .add("用户登陆城市", x)
            .set_series_opts(label_opts=opts.LabelOpts(is_show=False))
            .set_global_opts(
            visualmap_opts=opts.VisualMapOpts(is_piecewise=True),
            # visualmap_opts=[i for i in t_list],
            title_opts=opts.TitleOpts(title="用户登录城市统计"),
        )
    )
    return c.render_embed()
