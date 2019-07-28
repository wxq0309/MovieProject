/*
 Navicat MySQL Data Transfer

 Source Server         : 192.168.88.179
 Source Server Type    : MySQL
 Source Server Version : 80011
 Source Host           : localhost:3306
 Source Schema         : bishe

 Target Server Type    : MySQL
 Target Server Version : 80011
 File Encoding         : 65001

 Date: 30/04/2019 08:11:12
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `pwd` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `is_super` smallint(6) NULL DEFAULT NULL,
  `addtime` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE,
  INDEX `ix_admin_addtime`(`addtime`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES (1, 'smart', '123456', NULL, NULL);
INSERT INTO `admin` VALUES (3, 'admin', 'pbkdf2:sha256:50000$JpV3QWs0$06e31e9aa775fcc746439f3292b2120be06d70949535496342e1dd8222e138b1', 1, '2019-04-29 21:57:30');

-- ----------------------------
-- Table structure for adminlog
-- ----------------------------
DROP TABLE IF EXISTS `adminlog`;
CREATE TABLE `adminlog`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) NULL DEFAULT NULL,
  `ip` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `addtime` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `admin_id`(`admin_id`) USING BTREE,
  INDEX `ix_adminlog_addtime`(`addtime`) USING BTREE,
  CONSTRAINT `adminlog_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of adminlog
-- ----------------------------
INSERT INTO `adminlog` VALUES (27, 1, '127.0.0.1', '2019-04-29 21:51:21');
INSERT INTO `adminlog` VALUES (28, 3, '127.0.0.1', '2019-04-29 21:58:34');

-- ----------------------------
-- Table structure for advertise
-- ----------------------------
DROP TABLE IF EXISTS `advertise`;
CREATE TABLE `advertise`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `info` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `addtime` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `image`(`image`) USING BTREE,
  UNIQUE INDEX `image_2`(`image`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for alembic_version
-- ----------------------------
DROP TABLE IF EXISTS `alembic_version`;
CREATE TABLE `alembic_version`  (
  `version_num` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`version_num`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `movie_id` int(11) NULL DEFAULT NULL,
  `user_id` int(11) NULL DEFAULT NULL,
  `addtime` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `movie_id`(`movie_id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  INDEX `ix_comment_addtime`(`addtime`) USING BTREE,
  CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 51 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for movie
-- ----------------------------
DROP TABLE IF EXISTS `movie`;
CREATE TABLE `movie`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `info` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `logo` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `star` smallint(6) NULL DEFAULT NULL,
  `playnum` bigint(20) NULL DEFAULT NULL,
  `commentnum` bigint(20) NULL DEFAULT NULL,
  `tag_id` int(11) NULL DEFAULT NULL,
  `area` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `release_time` date NULL DEFAULT NULL,
  `length` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `addtime` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `title`(`title`) USING BTREE,
  UNIQUE INDEX `url`(`url`) USING BTREE,
  UNIQUE INDEX `logo`(`logo`) USING BTREE,
  INDEX `tag_id`(`tag_id`) USING BTREE,
  INDEX `ix_movie_addtime`(`addtime`) USING BTREE,
  CONSTRAINT `movie_ibfk_1` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 31 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of movie
-- ----------------------------
INSERT INTO `movie` VALUES (8, '今日说法', '20181214100240c0724bba1d2d4f73a2781b59ee9c4a40.mp4', '发哈发哈设计开发哈萨克就发哈就发哈时间hash理解哈是几号放假啊号放假咯静安寺的绿卡含量可达负能量咖啡机离开\r\nask的拉克丝发哪里看烦了访问拉克丝烦死了分年龄可适当分担烦恼就是来得及啊可能就阿三哪里看自己flak发家史分厘卡机费JFK多方力量', '20181214100240431d0213ccae48ba9ff93ce1c3b3b6b0.jpg', 5, 85, 3, 14, '南京南', '2018-12-18', '655', '2018-12-14 10:02:41');
INSERT INTO `movie` VALUES (9, '无敌原始人', '201812190022035eb31ecea96547078f4ceb4aabf9063e.mp4', '\r\n测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------', '20181219002203978481c62dc14c0fb6fce415ae8f36e8.jpg', 1, 36, 7, 3, '南京', '2018-12-17', '345', '2018-12-19 00:22:03');
INSERT INTO `movie` VALUES (11, '测试数据一', '201812190022035eb31ecea96547078f4ceaaaabf9063e.mp4', '\r\n测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------', '20181219002203978481c62dc14c0fs6fce415ae8f36e8.jpg', 1, 33, 7, 3, '南京', '2018-12-17', '345', '2018-12-19 00:22:03');
INSERT INTO `movie` VALUES (12, '测试数据2', '201812190022035eb31ecea96547078f4ceaa1abf9063e.mp4', '\r\n测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------', '20181219002203978481c62dc14c0fs6fce415ae2f36e8.jpg', 1, 33, 7, 3, '南京', '2018-12-17', '345', '2018-12-19 00:22:03');
INSERT INTO `movie` VALUES (13, '测试数据3', '201812190022035eb31ecad96547078f4ceaaaabf9063e.mp4', '\r\n测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------', '20181219002203478481c62dc14c0fs6fce415ae8f36e8.jpg', 1, 35, 7, 3, '南京', '2018-12-17', '345', '2018-12-19 00:22:03');
INSERT INTO `movie` VALUES (14, '测试数据4', '201812190022035eb31ecea96347078f4ceaa1abf9063e.mp4', '\r\n测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------', '20181219002203978481c62dc14c0fs6ace415ae2f36e8.jpg', 1, 33, 7, 3, '南京', '2018-12-17', '345', '2018-12-19 00:22:03');
INSERT INTO `movie` VALUES (15, '测试数据5', '201812190022035eb31ecad96537078f4ceaaaabf9063e.mp4', '\r\n测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------', '20181219002203478481c62dc14c0fs6fce415ae8f36ee.jpg', 1, 33, 7, 3, '南京', '2018-12-17', '345', '2018-12-19 00:22:03');
INSERT INTO `movie` VALUES (17, '测试数据6', '201812190022035eb31ecad96537078f4cezaaabf9063e.mp4', '\r\n测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------', '20181219002203478481c62dc14c0fs6fce415ze8f36ee.jpg', 1, 34, 7, 3, '南京', '2018-12-17', '345', '2018-12-19 00:22:03');
INSERT INTO `movie` VALUES (18, '测试数据9', '201812190022035eb31ecad96537078f4cezaaabfz063e.mp4', '\r\n测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------', '20181219002203478481c62dc14c0fs6fce415ze8f3zee.jpg', 1, 33, 7, 3, '南京', '2018-12-17', '345', '2018-12-19 00:22:03');
INSERT INTO `movie` VALUES (19, '测试数据8', '201812190022035eb31ecea9634z078f4ceaazabf9063e.mp4', '\r\n测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------', '201812190022039784z1c62dc14c0fs6aze415ae2f36e8.jpg', 1, 33, 7, 3, '南京', '2018-12-17', '345', '2018-12-19 00:22:03');
INSERT INTO `movie` VALUES (20, '测试数据10', '201812190022035eb31ecea9634z0fgf4ceaazabf9063e.mp4', '\r\n测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------', '2018121900gf039784z1c62dc14c0fs6aze415ae2f36e8.jpg', 1, 33, 7, 3, '南京', '2018-12-17', '345', '2018-12-19 00:22:03');
INSERT INTO `movie` VALUES (21, '测试数据11', '201812190022035eb31ecad96537078f4c1fgaabfz063e.mp4', '\r\n测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------测试数据----------------------------', '20181219002210478481c62dc14c0fs6fce415ze8f3zee.jpg', 1, 33, 7, 3, '南京', '2018-12-17', '345', '2018-12-19 00:22:03');
INSERT INTO `movie` VALUES (22, 'oss数据测试', '201903191410082c528aa70caf4be58d83fb53e16a0ac4.mp4', 'oss数据测试oss数据测试oss数据测试oss数据测试oss数据测试oss数据测试oss数据测试oss数据测试oss数据测试oss数据测试oss数据测试oss数据测试oss数据测试oss数据测试oss数据测试oss数据测试oss数据测试oss数据测试oss数据测试', '201903191410084da07b077fc14064a5fc9ebc1ab76a6b.mp4', 2, 1, 0, 2, '东京', '2019-03-26', '256', '2019-03-19 14:10:10');
INSERT INTO `movie` VALUES (26, 'oss数据测试----1', '20190319165044eaaa5faa42b545dbb49529ad9a75542e.mp4', 'oss数据测试----1oss数据测试----1oss数据测试----1oss数据测试----1oss数据测试----1oss数据测试----1oss数据测试----1oss数据测试----1oss数据测试----1', '2019031916504483c970c28c41412ca413f03b5c8e3c8f.mp4', 3, 1, 0, 16, '海南', '2019-03-26', '256', '2019-03-19 16:50:49');
INSERT INTO `movie` VALUES (27, 'oss数据测试----2-3-1', '2019032109252897ef560b2b6746c29325914efde49b2e.mp4', 'find / -name nginx.conffind / -name nginx.conffind / -name nginx.conffind / -name nginx.conffind / -name nginx.conf', '20190321092528c8523f8376744044aaa20551f3ecff50.jpg', 3, 0, 0, 14, '东京', '2019-03-20', '256', '2019-03-21 09:25:29');
INSERT INTO `movie` VALUES (28, 'oss数据测试dsaaa', '201903211709154830f54345314699bd915b7903300f5f.mp4', 'saddddddd', '20190321170915bf143b9d019c46a88de6c8247276ebb4.mp4', 1, 1, 0, 1, '南极给你', '2019-03-26', '32', '2019-03-21 17:09:23');
INSERT INTO `movie` VALUES (29, 'dqwsdasdasdsadsad', '20190401085130a894510f98eb4d01a791e330baeae755.mp4', 'qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq', '20190401085130c4ec65fe51bc40d3b7f9cad9e45d0866.mp4', 2, 3, 0, 1, '31', '2019-04-24', '3', '2019-04-01 08:51:39');
INSERT INTO `movie` VALUES (30, 'dqwsdasdasdsadsadweqewqdsa', '2019040111474118b9b09d1826407fb6233af2d9294753.mp4', 'vfssssssssssssssssssssssssssssssss', '20190401114741c8058bfe5ffa41f7bc0222937b0706c0.png', 3, 1, 0, 3, 'wqe', '2019-04-30', '3', '2019-04-01 11:47:44');

-- ----------------------------
-- Table structure for moviecol
-- ----------------------------
DROP TABLE IF EXISTS `moviecol`;
CREATE TABLE `moviecol`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `movie_id` int(11) NULL DEFAULT NULL,
  `user_id` int(11) NULL DEFAULT NULL,
  `addtime` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `movie_id`(`movie_id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  INDEX `ix_moviecol_addtime`(`addtime`) USING BTREE,
  CONSTRAINT `moviecol_ibfk_1` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `moviecol_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of moviecol
-- ----------------------------
INSERT INTO `moviecol` VALUES (1, NULL, 36, '2018-12-10 10:15:13');
INSERT INTO `moviecol` VALUES (4, NULL, 37, '2018-12-10 10:16:06');
INSERT INTO `moviecol` VALUES (5, NULL, 38, '2018-12-10 10:16:06');
INSERT INTO `moviecol` VALUES (13, 8, 45, '2018-12-17 10:25:18');
INSERT INTO `moviecol` VALUES (14, 8, 1, '2018-12-18 22:51:56');
INSERT INTO `moviecol` VALUES (15, 9, 45, '2019-02-05 18:26:50');

-- ----------------------------
-- Table structure for oplog
-- ----------------------------
DROP TABLE IF EXISTS `oplog`;
CREATE TABLE `oplog`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) NULL DEFAULT NULL,
  `ip` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `reason` varchar(600) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `addtime` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `admin_id`(`admin_id`) USING BTREE,
  INDEX `ix_oplog_addtime`(`addtime`) USING BTREE,
  CONSTRAINT `oplog_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oplog
-- ----------------------------
INSERT INTO `oplog` VALUES (10, 3, '127.0.0.1', '删除标签换壳', '2019-04-29 22:23:34');
INSERT INTO `oplog` VALUES (11, 3, '127.0.0.1', '删除标签科幻1', '2019-04-29 22:23:37');
INSERT INTO `oplog` VALUES (12, 3, '127.0.0.1', '删除标签爱情2', '2019-04-29 22:23:38');

-- ----------------------------
-- Table structure for preview
-- ----------------------------
DROP TABLE IF EXISTS `preview`;
CREATE TABLE `preview`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `logo` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `addtime` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `logo`(`logo`) USING BTREE,
  UNIQUE INDEX `title`(`title`) USING BTREE,
  INDEX `ix_preview_addtime`(`addtime`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of preview
-- ----------------------------
INSERT INTO `preview` VALUES (24, '大江大河', '20181217124312f135ba65a02145c78f81f59d306f7917.jpg', '2018-12-17 12:43:12');
INSERT INTO `preview` VALUES (25, '后会无期', '20181217125047abc86a1604f0494ead24c315ba20498c.jpg', '2018-12-17 12:50:47');
INSERT INTO `preview` VALUES (26, 'fhfg ', '20181217130221e6eb34af0b824245b3183aec3ce0e3e5.jpg', '2018-12-17 13:02:21');
INSERT INTO `preview` VALUES (27, 'juab', '201812182249431276169000cd4646a41c8292fef5ad90.jpg', '2018-12-18 22:49:43');

-- ----------------------------
-- Table structure for tag
-- ----------------------------
DROP TABLE IF EXISTS `tag`;
CREATE TABLE `tag`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `addtime` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE,
  INDEX `ix_tag_addtime`(`addtime`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tag
-- ----------------------------
INSERT INTO `tag` VALUES (1, '小清新', '2018-12-18 22:44:17');
INSERT INTO `tag` VALUES (2, '动作', '2018-12-18 22:44:28');
INSERT INTO `tag` VALUES (3, '校园爱情', '2018-12-18 22:44:45');
INSERT INTO `tag` VALUES (14, '搞笑', '2018-12-09 22:32:41');
INSERT INTO `tag` VALUES (15, '科学', '2018-12-09 22:43:59');
INSERT INTO `tag` VALUES (16, '人文', '2018-12-09 22:44:48');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `pwd` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `email` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `phone` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `info` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `face` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `addtime` datetime(0) NULL DEFAULT NULL,
  `uuid` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `email`(`email`) USING BTREE,
  UNIQUE INDEX `face`(`face`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE,
  UNIQUE INDEX `phone`(`phone`) USING BTREE,
  UNIQUE INDEX `uuid`(`uuid`) USING BTREE,
  INDEX `ix_user_addtime`(`addtime`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 47 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (36, '猪', '123456', '1123@13.com', '12345678998', '猪', NULL, '2018-12-10 09:02:41', '95c8438c-af81-467a-88e7-780153a09853');
INSERT INTO `user` VALUES (37, '牛', '123456', '1124@13.com', '12345678994', '牛', NULL, '2018-12-10 09:02:41', '95c8438c-af81-467a-88e7-780153a09857');
INSERT INTO `user` VALUES (38, '马', '123456', '1125@13.com', '12345678995', '马', NULL, '2018-12-10 09:02:41', '95c8438c-af81-467a-88e7-780153a09856');
INSERT INTO `user` VALUES (39, '驴', '123456', '1126@13.com', '12345678996', '驴', NULL, '2018-12-10 09:02:41', '95c8438c-af81-467a-88e7-780153a09855');
INSERT INTO `user` VALUES (40, '鼠', '123456', '1127@13.com', '12345678997', '鼠', NULL, '2018-12-10 09:02:41', '95c8438c-af81-467a-88e7-780153a09854');
INSERT INTO `user` VALUES (41, '龙', '123456', '1128@13.com', '12345678990', '龙', NULL, '2018-12-10 09:02:41', '95c8438c-af81-467a-88e7-780153a09852');
INSERT INTO `user` VALUES (42, '羊', '123456', '1129@13.com', '12345678999', '羊', NULL, '2018-12-10 09:02:43', '95c8438c-af81-467a-88e7-780153a09851');
INSERT INTO `user` VALUES (43, 'smart998', '147258369', '1053522308@qq.com', '18734422941', '爱德华', NULL, '2018-12-11 10:25:43', 'e340d49778c84fa09fadd99728a25cc4');
INSERT INTO `user` VALUES (44, 'smart99', '147258369', '1053522308@163.com', '14725836999', NULL, NULL, '2018-12-11 15:55:30', '7728818f00404e4d865f7ae123803c80');
INSERT INTO `user` VALUES (45, 'smart', 'pbkdf2:sha256:50000$EUTCrIyA$ac5984345395247f50a76c2db4472a7af5773c077554ddfd9df12fc626a27e8b', '1053522301@qq.com', '14725836111', NULL, NULL, '2018-12-11 16:11:33', 'c281df5e3b4e4bd8bdea7645f2ccce72');
INSERT INTO `user` VALUES (46, 'smart2', 'pbkdf2:sha256:50000$QdJp9dxs$1ee70cb1cd6d39dbed13c472e68cdf93421e8ff2855ee344e7916ef062b815e6', '10535223087@qq.com', '18734422942', NULL, NULL, '2019-01-29 15:40:07', 'a1d2e8f2881649d1ad1ff5b5aea268fa');

-- ----------------------------
-- Table structure for userlog
-- ----------------------------
DROP TABLE IF EXISTS `userlog`;
CREATE TABLE `userlog`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NULL DEFAULT NULL,
  `ip` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `addtime` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  INDEX `ix_userlog_addtime`(`addtime`) USING BTREE,
  CONSTRAINT `userlog_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for userrecommend
-- ----------------------------
DROP TABLE IF EXISTS `userrecommend`;
CREATE TABLE `userrecommend`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `protagonist` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `info` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `area` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `release_time` date NULL DEFAULT NULL,
  `addtime` datetime(0) NULL DEFAULT NULL,
  `user_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `title`(`title`) USING BTREE,
  UNIQUE INDEX `title_2`(`title`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  INDEX `ix_userrecommend_addtime`(`addtime`) USING BTREE,
  CONSTRAINT `userrecommend_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
