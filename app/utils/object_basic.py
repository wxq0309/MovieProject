import oss2, uuid


class Oss(object):
    def __init__(self):
        self.auth = oss2.Auth('LTAIatq91508QOPV', 'rp9vIYNTnZskVIBRevq7nNPhpMYh8o')
        self.endpoint = 'http://oss-cn-shenzhen.aliyuncs.com'
        self.bucket = oss2.Bucket(self.auth, self.endpoint, 'person-movie')

    def putfile(self, key, filename):
        '''文件上传'''
        key = 'static/uploads/' + key
        self.bucket.put_object_from_file(key, filename)
        print(key)
        print('success upload!!!')

#
# if __name__ == "__main__":
#     img_key = '.mp4'
#     img_path = '/movie_project/app/static/uploads/20181208233313f3bcaa01d3cf4f86b2f7e0237653b039.mp4'
#     oss(img_key, img_path)
#     print('success')
