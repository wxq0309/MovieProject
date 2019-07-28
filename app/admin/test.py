import os

print(os.path.abspath(os.path.dirname(os.path.abspath("__file__")))+'../templates')
