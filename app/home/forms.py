#! /usr/bin/env python
# -*- coding: utf-8 -*-
from datetime import datetime
from time import timezone

from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField, TextAreaField, DateTimeField
from wtforms.validators import DataRequired, Email, Regexp, EqualTo, ValidationError

# 用户注册表单
from app.models import User


class RegisterForm(FlaskForm):
    name = StringField(
        label="账号",
        validators=[
            DataRequired("昵称不能为空！")
        ],
        description="昵称",
        render_kw={
            "class": "form-control input-lg",
            "placeholder": "请输入昵称！",
            # "required":"required"
        }
    )
    email = StringField(
        label="邮箱",
        validators=[
            DataRequired("邮箱不能为空！"),
            Email("邮箱格式不正确！")
        ],
        description="邮箱",
        render_kw={
            "class": "form-control input-lg",
            "placeholder": "请输入邮箱！",
        }
    )
    phone = StringField(
        label="手机",
        validators=[
            DataRequired("手机号不能为空！"),
            Regexp("1[3458]\d{9}", message="手机格式不正确！")
        ],
        description="手机",
        render_kw={
            "class": "form-control input-lg",
            "placeholder": "请输入手机！",
        }
    )
    pwd = PasswordField(
        label="密码",
        validators=[
            DataRequired("密码不能为空！")
        ],
        description="密码",
        render_kw={
            "class": "form-control input-lg",
            "placeholder": "请输入密码！",
        }
    )
    repwd = PasswordField(
        label="确认密码",
        validators=[
            DataRequired("请输入确认密码！"),
            EqualTo('pwd', message="两次密码不一致！")
        ],
        description="确认密码",
        render_kw={
            "class": "form-control input-lg",
            "placeholder": "请输入确认密码！",
        }
    )
    submit = SubmitField(
        '注册',
        render_kw={
            "style": "margin-right:20px; margin-top:20px;"
        }
    )

    def validate_name(self, field):
        name = field.data
        user = User.query.filter_by(name=name).count()
        if user == 1:
            raise ValidationError("昵称已经存在！")

    def validate_email(self, field):
        email = field.data
        user = User.query.filter_by(email=email).count()
        if user == 1:
            raise ValidationError("邮箱已经存在！")

    def validate_phone(self, field):
        phone = field.data
        user = User.query.filter_by(phone=phone).count()
        if user == 1:
            raise ValidationError("手机号码已经存在！")


class LoginForm(FlaskForm):
    name = StringField(
        label="账号",
        validators=[
            DataRequired("账号不能为空！")
        ],
        description="账号",
        render_kw={
            "class": "btn",
            "placeholder": "请输入账号！",
        }
    )
    pwd = PasswordField(
        label="密码",
        validators=[
            DataRequired("密码不能为空！")
        ],
        description="密码",
        render_kw={
            "class": "btn",
            "placeholder": "请输入密码！",
        }
    )
    submit = SubmitField(
        '登录',
        render_kw={
            "class": "btn",
        }
    )


class UserForm(FlaskForm):
    name = StringField(
        label="昵称",
        validators=[
            DataRequired("昵称不能为空！")
        ],
        description="昵称",
        render_kw={
            "class": "form-control",
            "placeholder": "请输入账号（昵称）！",
        }
    )
    email = StringField(
        label="邮箱",
        validators=[
            DataRequired("邮箱不能为空！"),
            Email("邮箱格式不正确！")
        ],
        description="邮箱",
        render_kw={
            "class": "form-control",
            "placeholder": "请输入邮箱！",
        }
    )
    phone = StringField(
        label="手机",
        validators=[
            DataRequired("手机号不能为空！"),
            Regexp("1[3458]\d{9}", message="手机格式不正确！")
        ],
        description="手机",
        render_kw={
            "class": "form-control",
            "placeholder": "请输入手机号码！",
        }
    )
    info = TextAreaField(
        label="简介",
        validators=[
            DataRequired("简介不能为空！")
        ],
        description="简介",
        render_kw={
            "class": "form-control",
            "rows": 10
        }
    )
    submit = SubmitField(
        '保存修改',
        render_kw={
            "class": "btn btn-success",
        }
    )


class PwdForm(FlaskForm):
    old_pwd = PasswordField(
        label="原密码",
        validators=[
            DataRequired("原密码不能为空！")
        ],
        description="原密码",
        render_kw={
            "class": "form-control",
            "placeholder": "请输入原密码！",
        }
    )
    new_pwd = PasswordField(
        label="新密码",
        validators=[
            DataRequired("新密码不能为空！"),
        ],
        description="新密码",
        render_kw={
            "class": "form-control",
            "placeholder": "请输入新密码！",
        }
    )
    submit = SubmitField(
        '修改密码',
        render_kw={
            "class": "btn btn-success",
        }
    )


class CommentForm(FlaskForm):
    content = TextAreaField(
        label="电影评论",
        validators=[
            DataRequired("请输入此电影的评论")
        ],
        description="电影评论",
        render_kw={
            "class": "form-control",
            "placeholder": "请输入相关的电影评论",
            # 'required':"required"
        }
    )

    submit = SubmitField(
        "提交评论",
        render_kw={
            "class": "btn btn-success",
        }
    )


class UserRecommedFrom(FlaskForm):
    '''用户推荐'''
    title = StringField(
        label="电影名称",
        description="电影名称",
        validators=[
            DataRequired("请填写需要推荐的电影名")
        ],
        render_kw={
            "class": "form-control",
            "placeholder": "请输入需要填写的电影名称电影名称"
        }
    )
    protagonist = StringField(label="主演", validators=[DataRequired("请填写电影主演")],render_kw={"placeholder":"请填写电影主演","class": "form-control",})

    info = TextAreaField(
        label="简介",
        validators=[
            DataRequired("简介不能为空！")
        ],
        description="简介",
        render_kw={
            "class": "form-control",
            "rows": 2,
            "placeholder": "电影简介"
        }
    )

    area = StringField(
        label="上映地区",
        validators=[
            DataRequired("请填写上映地区")
        ],
        description="上映地区",
        render_kw={
            "class": "form-control",
            "placeholder": "上映地区"
        }
    )

    release_time = StringField(
        label="上映时间",
        validators=[
            DataRequired("请填写上映时间")
        ],
        description="上映时间",
        render_kw={
            "class": "form-control",
            "placeholder": "上映时间"
        },
        default=datetime.now()
    )
    submit = SubmitField(
        "确认推荐",
        render_kw={
            "class": "btn btn-success",
        }

    )
