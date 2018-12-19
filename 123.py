#import keras
import sys
import os


#print(sys.version)


print(os.environ['path'])
#print(sys.version[0])


if sys.version[0] == '2':
    reload(sys)
    sys.setdefaultencoding('utf8')
