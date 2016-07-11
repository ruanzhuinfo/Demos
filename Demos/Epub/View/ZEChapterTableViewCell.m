//
//  ZEChapterTableViewCell.m
//  Demos
//
//  Created by taffy on 16/7/8.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import "ZEChapterTableViewCell.h"
#import "ZEChapter.h"

@interface ZEChapterTableViewCell()

@property(nonatomic)UILabel *chapterLabel;
@property(nonatomic)UILabel *pageIndexLabel;

@end

@implementation ZEChapterTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	
	if (self) {
		
		self.chapterLabel = [[UILabel alloc] init];
		[self.chapterLabel setFont:[UIFont systemFontOfSize:15]];
		[self.contentView addSubview:self.chapterLabel];
		[self.chapterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self.contentView);
			make.left.equalTo(self.contentView).offset(10);
		}];
		
		self.pageIndexLabel = [[UILabel alloc] init];
		[self.pageIndexLabel setFont:[UIFont systemFontOfSize:14]];
		[self.pageIndexLabel setTextAlignment:NSTextAlignmentRight];
		[self.contentView addSubview:self.pageIndexLabel];
		[self.pageIndexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self.contentView).offset(-10);
			make.centerY.equalTo(self.chapterLabel);
			make.width.mas_equalTo(42);
			make.left.equalTo(self.chapterLabel.mas_right).offset(20);
		}];
	}
	
	return self;
}

- (void)setupDataWithChapterModel:(ZEChapter *)chapter {
	if (self.isCurrentPage) {
		[self changeTextColor:[UIColor blueColor]];
	} else {
		switch(self.chapterStyle) {
			case ZEChapterStyleNormal:
				[self changeTextColor:[UIColor blackColor]];
				break;
				
			case ZEchapterStyleNoPurchase:
				[self changeTextColor:[UIColor grayColor]];
				break;
		}
	}
	
	self.chapterLabel.text = chapter.title;
	self.pageIndexLabel.text = [NSString stringWithFormat:@"%ld", chapter.pageIndex + 1];
}


- (void)changeTextColor:(UIColor *)color {
	[self.chapterLabel setTextColor:color];
	[self.pageIndexLabel setTextColor:color];
}


@end
