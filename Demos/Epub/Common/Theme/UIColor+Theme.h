//
// 通过脚本生成
// 

#import <UIKit/UIKit.h>

@interface UIColor (Theme)


/// 通常界面
+ (UIColor *)color_BG01;
+ (UIColor *)color_BG01_Night;

/// 卡片界面与回答页问题标题抽屉底色
+ (UIColor *)color_BG02;
+ (UIColor *)color_BG02_Night;

/// 分享界面背景颜色
+ (UIColor *)color_BG03;
+ (UIColor *)color_BG03_Night;

/// 夜间模式图片遮罩颜色
+ (UIColor *)color_BG04;
+ (UIColor *)color_BG04_Night;

/// Feed分隔线色
+ (UIColor *)color_LINE01;
+ (UIColor *)color_LINE01_Night;

/// 条目区域分割线
+ (UIColor *)color_LINE02;
+ (UIColor *)color_LINE02_Night;

/// 用于分隔文字描述区域
+ (UIColor *)color_LINE03;
+ (UIColor *)color_LINE03_Night;

/// IMAGE_FEED的条目分隔线
+ (UIColor *)color_LIEN04;
+ (UIColor *)color_LIEN04_Night;

/// 顶栏颜色
+ (UIColor *)color_TOP01;
+ (UIColor *)color_TOP01_Night;

/// 标题文字色，覆盖一切问题标题
+ (UIColor *)color_W01;
+ (UIColor *)color_W01_Night;

/// 卡片与条目正文摘要文字&正文页未赞时的赞数颜色
+ (UIColor *)color_W02;
+ (UIColor *)color_W02_Night;

/// 条目说明文字色，如关注了该问题
+ (UIColor *)color_W03;
+ (UIColor *)color_W03_Night;

/// Feed用户名、话题名称
+ (UIColor *)color_W04;
+ (UIColor *)color_W04_Night;

/// 回答与文章页正文文字色
+ (UIColor *)color_W05;
+ (UIColor *)color_W05_Night;

/// 回答与文章页底部创建与编辑时间文字颜色
+ (UIColor *)color_W06;
+ (UIColor *)color_W06_Night;

/// 最近浏览(阅读历史)页面标题色
+ (UIColor *)color_W07;
+ (UIColor *)color_W07_Night;

/// Feed条目赞同数色
+ (UIColor *)color_B01;
+ (UIColor *)color_B01_Night;

/// 功能条目文字如：顶栏的发现、消息、个人
+ (UIColor *)color_C01;
+ (UIColor *)color_C01_Night;

/// 滑动功能文字非选中色如：推荐、收藏、月榜、日榜
+ (UIColor *)color_C02;
+ (UIColor *)color_C02_Night;

/// 滑动功能文字选中色如：推荐、收藏、月榜、日榜
+ (UIColor *)color_C03;
+ (UIColor *)color_C03_Night;

/// 正文页用户名色
+ (UIColor *)color_T01;
+ (UIColor *)color_T01_Night;

/// 正文页一句话介绍色
+ (UIColor *)color_T02;
+ (UIColor *)color_T02_Night;

/// 正文页面链接颜色
+ (UIColor *)color_L01;
+ (UIColor *)color_L01_Night;

/// 底栏Icon功能描述文字色
+ (UIColor *)color_T03;
+ (UIColor *)color_T03_Night;

/// 问题页的问题描述文字与专栏页和收藏页的描述文字
+ (UIColor *)color_Q01;
+ (UIColor *)color_Q01_Night;

/// 专栏条目信息及一些相关信息字体
+ (UIColor *)color_Q02;
+ (UIColor *)color_Q02_Night;

/// 列表页xxx人关注xxx人评论字体
+ (UIColor *)color_Q03;
+ (UIColor *)color_Q03_Night;

/// 问题页话题标签字体
+ (UIColor *)color_Q04;
+ (UIColor *)color_Q04_Night;

/// 个人页、设置页条目文字
+ (UIColor *)color_G01;
+ (UIColor *)color_G01_Night;

/// 绿色关注按钮文字
+ (UIColor *)color_I01;
+ (UIColor *)color_I01_Night;

/// 灰色取消关注按钮文字
+ (UIColor *)color_I02;
+ (UIColor *)color_I02_Night;

/// 蓝色关注按钮文字
+ (UIColor *)color_I03;
+ (UIColor *)color_I03_Night;

/// 分享页面文字颜色
+ (UIColor *)color_S01;
+ (UIColor *)color_S01_Night;

/// 当未填充内容无法发布或跳转至下一步时，发布按钮或下一步按钮的颜色
+ (UIColor *)color_R01;
+ (UIColor *)color_R01_Night;

/// 提问、回答、评论页面用户操作提示文字
+ (UIColor *)color_R02;
+ (UIColor *)color_R02_Night;

/// 私信蓝色对话框链接颜色
+ (UIColor *)color_SX01;
+ (UIColor *)color_SX01_Night;

/// 文字按钮颜色,非选中状态
+ (UIColor *)color_DL01;
+ (UIColor *)color_DL01_Night;

/// 文字按钮颜色,选中状态
+ (UIColor *)color_DL02;
+ (UIColor *)color_DL02_Night;

/// 首页时间标记等
+ (UIColor *)color_TL01;
+ (UIColor *)color_TL01_Night;

/// 评论的作者
+ (UIColor *)color_AUTHOR;
+ (UIColor *)color_AUTHOR_Night;

/// 评论正文
+ (UIColor *)color_COMMENT;
+ (UIColor *)color_COMMENT_Night;

/// 评论meta中的高亮「赞」
+ (UIColor *)color_HL01;
+ (UIColor *)color_HL01_Night;
+ (UIColor *)color_IMTITLE;
+ (UIColor *)color_IMTITLE_Night;
+ (UIColor *)color_IMSUMMARY;
+ (UIColor *)color_IMSUMMARY_Night;

/// ImageFeed的操作区，TODO：夜间模式
+ (UIColor *)color_IMMETA;
+ (UIColor *)color_IMMETA_Night;

/// 文字disable颜色
+ (UIColor *)color_DisableText;
+ (UIColor *)color_DisableText_Night;
+ (UIColor *)color_GrayButton;
+ (UIColor *)color_GrayButton_Night;

/// 正文页问题标题抽屉未点选底色
+ (UIColor *)color_BOX01;
+ (UIColor *)color_BOX01_Night;

/// 正文页问题标题抽屉点选底色
+ (UIColor *)color_BOX02;
+ (UIColor *)color_BOX02_Night;

/// 功能状态条(此为应用中唯一使用的标示当前功能状态的蓝色）
+ (UIColor *)color_BLUE;
+ (UIColor *)color_BLUE_Night;

/// 条目点选高亮区域底色
+ (UIColor *)color_GRAY;
+ (UIColor *)color_GRAY_Night;

/// 赞同显示区域底色
+ (UIColor *)color_VOTE;
+ (UIColor *)color_VOTE_Night;

/// 不再显示与提醒通知原点
+ (UIColor *)color_RED;
+ (UIColor *)color_RED_Night;

/// feed条目选中区域高亮底色
+ (UIColor *)color_FH;
+ (UIColor *)color_FH_Night;

/// 标题文字色，覆盖一切问题标题高亮色
+ (UIColor *)color_FEED_TITLE_H;
+ (UIColor *)color_FEED_TITLE_H_Night;

/// 卡片与条目正文摘要文字&正文页未赞时的赞数颜色高亮色
+ (UIColor *)color_FEED_TEXT_H;
+ (UIColor *)color_FEED_TEXT_H_Night;

/// Feed用户名、话题名称高亮色
+ (UIColor *)color_FEED_META_H;
+ (UIColor *)color_FEED_META_H_Night;

/// feed搜索框底色
+ (UIColor *)color_S;
+ (UIColor *)color_S_Night;

/// 所有关注按钮的关注状态
+ (UIColor *)color_GREEN_N;
+ (UIColor *)color_GREEN_N_Night;

/// 关注按钮未关注时外框色
+ (UIColor *)color_BLUE_N;
+ (UIColor *)color_BLUE_N_Night;

/// 所有关注按钮点按高亮状态
+ (UIColor *)color_GREEN_H;
+ (UIColor *)color_GREEN_H_Night;

/// 所有已关注按钮的关注状态
+ (UIColor *)color_GRAY_N;
+ (UIColor *)color_GRAY_N_Night;

/// 所有已关注按钮的高亮状态
+ (UIColor *)color_GRAY_H;
+ (UIColor *)color_GRAY_H_Night;

/// 问题页话题标签底色
+ (UIColor *)color_HT;
+ (UIColor *)color_HT_Night;

/// 未读消息条目高亮色
+ (UIColor *)color_TZ;
+ (UIColor *)color_TZ_Night;

/// 个人页底栏的蓝点提示和个人页条目与收藏夹卡片上的数字提示底色
+ (UIColor *)color_Y_BLUE;
+ (UIColor *)color_Y_BLUE_Night;

/// 图片未显示前的底色
+ (UIColor *)color_P01;
+ (UIColor *)color_P01_Night;

/// 回答建议修改提示文案区域的底色
+ (UIColor *)color_P02;
+ (UIColor *)color_P02_Night;

/// 分享页面分页器当前页圆点颜色
+ (UIColor *)color_SH01;
+ (UIColor *)color_SH01_Night;

/// 分享页面分页器非当前页圆点颜色
+ (UIColor *)color_SH02;
+ (UIColor *)color_SH02_Night;

/// 链接点按高亮底色
+ (UIColor *)color_LJ01;
+ (UIColor *)color_LJ01_Night;

/// segmentControl底色
+ (UIColor *)color_ZHGray_01;
+ (UIColor *)color_ZHGray_01_Night;

/// 图片PlaceHolder的颜色，目前在Feed中会用到
+ (UIColor *)color_IMG_HOLDER;
+ (UIColor *)color_IMG_HOLDER_Night;

/// 微信支付按钮底色
+ (UIColor *)color_Green_WeChat;
+ (UIColor *)color_Green_WeChat_Night;

/// 顶部通知栏背景底色-常规通知
+ (UIColor *)color_BG05;
+ (UIColor *)color_BG05_Night;

/// 气泡播放中背景底色、L01/Blue的辅助状态
+ (UIColor *)color_L02;
+ (UIColor *)color_L02_Night;

/// Live-录音按钮底色
+ (UIColor *)color_Green_Light;
+ (UIColor *)color_Green_Light_Night;

/// Live-录音波形颜色
+ (UIColor *)color_WaveColor;
+ (UIColor *)color_WaveColor_Night;

/// 蓝色气泡底色
+ (UIColor *)color_BubbleBlue;
+ (UIColor *)color_BubbleBlue_Night;

/// 白色气泡底色
+ (UIColor *)color_BubbleWhite;
+ (UIColor *)color_BubbleWhite_Night;

/// 气泡中分割线
+ (UIColor *)color_BubbleSeparate;
+ (UIColor *)color_BubbleSeparate_Night;

/// 蓝色气泡基线&蓝色气泡上的文字颜色
+ (UIColor *)color_BubbleBlueBaseline;
+ (UIColor *)color_BubbleBlueBaseline_Night;

/// 白色气泡基线
+ (UIColor *)color_BubbleWhiteBaseline;
+ (UIColor *)color_BubbleWhiteBaseline_Night;

/// 语音气泡时长数字颜色
+ (UIColor *)color_BubbleTime;
+ (UIColor *)color_BubbleTime_Night;

/// 蓝色气泡进度条&选中色
+ (UIColor *)color_BubbleBlueHightLighted;
+ (UIColor *)color_BubbleBlueHightLighted_Night;

/// 白色气泡进度条&选中色
+ (UIColor *)color_BubbleWhiteHightLighted;
+ (UIColor *)color_BubbleWhiteHightLighted_Night;

/// Placeholder（提示文案）的颜色
+ (UIColor *)color_R03;
+ (UIColor *)color_R03_Night;

/// 二级通知文字颜色
+ (UIColor *)color_ORANGE;
+ (UIColor *)color_ORANGE_Night;

/// 首页卡片式的背景，临时使用，需要设计师提供新色值
+ (UIColor *)color_FEED_BG;
+ (UIColor *)color_FEED_BG_Night;
+ (UIColor *)color_Gold;
+ (UIColor *)color_Gold_Night;
+ (UIColor *)color_BlueLight;
+ (UIColor *)color_BlueLight_Night;

/// 声音播放组件中「时间指示器上时间」的颜色
+ (UIColor *)color_GRAY_TIME;
+ (UIColor *)color_GRAY_TIME_Night;

/// 声音播放组件背景色
+ (UIColor *)color_GRAY_BG;
+ (UIColor *)color_GRAY_BG_Night;
+ (UIColor *)color_LiveCardFill;
+ (UIColor *)color_LiveCardFill_Night;
+ (UIColor *)color_LiveCardBorder;
+ (UIColor *)color_LiveCardBorder_Night;

/// 蓝色button点击时文本的颜色
+ (UIColor *)color_BlueTextPressed;
+ (UIColor *)color_BlueTextPressed_Night;

/// feedlive卡片背景色
+ (UIColor *)color_CardBg;
+ (UIColor *)color_CardBg_Night;

/// 梯度定价第三档使用色
+ (UIColor *)color_NavyBlue;
+ (UIColor *)color_NavyBlue_Night;
+ (UIColor *)color_AliPay;
+ (UIColor *)color_AliPay_Night;
+ (UIColor *)color_WePay;
+ (UIColor *)color_WePay_Night;
+ (UIColor *)color_AliPayPressed;
+ (UIColor *)color_AliPayPressed_Night;
+ (UIColor *)color_WePayPressed;
+ (UIColor *)color_WePayPressed_Night;
+ (UIColor *)color_HintBG;
+ (UIColor *)color_HintBG_Night;
+ (UIColor *)color_GrayToolbar;
+ (UIColor *)color_GrayToolbar_Night;
+ (UIColor *)color_ProfileBlueButton;
+ (UIColor *)color_ProfileBlueButton_Night;
+ (UIColor *)color_ProfileGreenButton;
+ (UIColor *)color_ProfileGreenButton_Night;
+ (UIColor *)color_ProfileBlueText;
+ (UIColor *)color_ProfileBlueText_Night;
+ (UIColor *)color_InputBg;
+ (UIColor *)color_InputBg_Night;
+ (UIColor *)color_BB01;
+ (UIColor *)color_BB01_Night;
+ (UIColor *)color_BW01;
+ (UIColor *)color_BW01_Night;
+ (UIColor *)color_BB02;
+ (UIColor *)color_BB02_Night;
+ (UIColor *)color_BW02;
+ (UIColor *)color_BW02_Night;

/// 电子书新添加
+ (UIColor *)color_BG06;
+ (UIColor *)color_BG06_Night;

/// 电子书新添加
+ (UIColor *)color_BG07;
+ (UIColor *)color_BG07_Night;

@end