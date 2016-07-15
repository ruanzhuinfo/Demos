# -*- coding: utf-8 -*-
"""
    image_to_class.py
    ~~~~~~~~~

    把项目中的图片资源生成一个 Objective-C 语言的 class

    :copyright: (c) 2016 - 3 - 8 by taffy.
"""
import os


# 需要手动修改

resource_dir =  '/Users/taffy/Project/Moblie/Demos/Demos/Epub/Reource/Images/' # 图片资源的路径
class_dir = '/Users/taffy/Project/Moblie/Demos/Demos/Epub/Common/Theme/' # 生成 class 文件的路径

class_name_h = 'UIImage+Theme.h'
class_name_m = 'UIImage+Theme.m'

class_header_h = '//\n// 通过脚本生成\n// \n\n#import <UIKit/UIKit.h>\n\n@interface UIImage (Theme)\n\n'
class_header_m = '//\n// 通过脚本生成\n//\n\n#import "UIImage+Theme.h"\n\n@implementation UIImage (Theme)\n\n'




def filter_filename(name):

    # 过滤掉非图片的
    if name.endswith('png') == False and name.endswith('jpg') == False:
        return None

    # 过滤掉 @3x 的
    if '@3x' in name:
        return None

    filename = name[:-4]

    if '@2x' in filename:
        filename = filename[:-3]

    return filename


def write_to_class_interface(filename):
    file_h.write('+ (UIImage *)theme_' + filename + ';\n')

def write_to_class_implemention(filename):
    file_m.write('+ (UIImage *)theme_' + filename + ' {\n' + '    return [UIImage imageNamed:@"' + filename + '"];\n}\n\n')


def walk_dir(dir, file_h, topdown = True):
    for root, dirs, files in os.walk(dir, topdown):
        for name in files:
            filename = filter_filename(name)
            if filename != None:
                write_to_class_interface(filename)
                write_to_class_implemention(filename)

file_h = open(class_dir + class_name_h, 'w')
file_m = open(class_dir + class_name_m, 'w')

file_h.write(class_header_h)
file_m.write(class_header_m)

walk_dir(resource_dir, file_h)

file_h.write('\n@end')
file_m.write('\n@end')

file_h.close()
file_m.close()





