# -*- coding: utf-8 -*-
"""
    color_to_class.py
    ~~~~~~~~~
    :copyright: (c) 2016 - 3 - 8 by taffy.

    UIColor+Thme.h
    + (UIColor *)color_Green_WeChat;
    + (UIColor *)color_Green_WeChat_Night;

    UIColor+theme.m
    + (UIColor *)color_Green_WeChat {
        return [UIColor colorWithHexString:@"#00C800"];
    }
    + (UIColor *)color_Green_WeChat_Night {
        return [UIColor colorWithHexString:@"#00C800"];
    }
"""

# 需要手动修改

color_file_dir = '/Users/taffy/Project/Moblie/Demos/Demos/Epub/Reource/theme.txt' # 色值文件的路径
class_dir = '/Users/taffy/Project/Moblie/Demos/Demos/Epub/Common/Theme/' # 生成 class 文件的路径

class_name_h = 'UIColor+Theme.h'
class_name_m = 'UIColor+Theme.m'

class_header_h = '//\n// 通过脚本生成\n// \n\n#import <UIKit/UIKit.h>\n\n@interface UIColor (Theme)\n\n'
class_header_m = '//\n// 通过脚本生成\n//\n\n#import "UIImage+Theme.h"\n#import "UIColor+HEX.h"\n\n@implementation UIColor (Theme)\n\n'

def check_contain_chinese(check_str):
    for ch in check_str.decode('utf-8'):
        if u'\u4e00' <= ch <= u'\u9fff':
            return True
    return False

def generate_code_h(method_name):
    return "+ (UIColor *)color_" + method_name + ";\n"

def generate_code_m(method_name, color_string):
    return '+ (UIColor *)color_' + method_name + ' {\n    return [UIColor colorWithHexString:@"'+ color_string + '"];\n}\n\n'

def parse_line(line):
    arr = line.split()
    arr_count = len(arr)

    # 低于三组内容不做处理
    if arr_count < 3:
        return

    # 第一个元素是中文的不做处理
    if check_contain_chinese(arr[0]) == True:
        return

    if (arr_count > 3):
        file_h.write('\n/// ' + ''.join(arr[3:]) + '\n')

    file_h.write(generate_code_h(arr[0]))
    file_h.write(generate_code_h(arr[0] + '_Night'))

    file_m.write(generate_code_m(arr[0], arr[1]))

    if arr[2] == '-':
       night_color = arr[1]
    else:
        night_color = arr[2]

    file_m.write(generate_code_m(arr[0] + '_Night', night_color))


file_h = open(class_dir + class_name_h, 'w')
file_m = open(class_dir + class_name_m, 'w')

file_h.write(class_header_h)
file_m.write(class_header_m)

# 逐行遍历, 解析日间和夜间色值并写入文件
with open(color_file_dir, 'r') as file:
    all_lines = file.readlines()
    for line in all_lines:
        parse_line(line)


file_h.write('\n@end')
file_m.write('\n@end')

file_h.close()
file_m.close()





