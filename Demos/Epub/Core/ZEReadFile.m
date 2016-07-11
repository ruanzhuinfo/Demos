//
//  ZEReadFile.m
//  Demos
//
//  Created by taffy on 16/6/28.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import "ZEReadFile.h"
#import "ZipArchive.h"
#import "TouchXML.h"
#import "NSData+AES128.h"

#define stringFormat(s...) [NSString stringWithFormat:s]

@interface ZEReadFile()
@property(nonatomic)NSString *epubPath;
@property(nonatomic)NSString *base64;
@property(nonatomic)NSDictionary<NSString*, id> *encpryptions;


@end

@implementation ZEReadFile

- (instancetype)initWithEpubPath:(NSString *)ePubPath base64:(NSString *)code {
	
	self = [super init];
	if (self) {
		self.epubPath = ePubPath;
		self.base64 = code;
		
		__weak typeof(self) weakSelf = self;
		[self parseMetaInfo:self.epubPath completion:^(NSDictionary<NSString *,id> *book, NSString *error) {
			__strong typeof(self) strongSelf = weakSelf;
			if (error) {
				NSLog(@"%@", error);
				return;
			}
			strongSelf.book = book;
		}];
	}
	
	return self;
}

- (instancetype)initWithEpubPath:(NSString *)ePubPath base64:(NSString *)code completion:(BookParserCompletion)completion {
	self = [super init];
	if (self) {
		self.epubPath = ePubPath;
		self.base64 = code;
		
		BookParserCompletion callback = [completion copy];
		__weak typeof(self) weakSelf = self;
		[self parseMetaInfo:self.epubPath completion:^(NSDictionary<NSString *,id> *book, NSString *error) {
			__strong typeof(self) strongSelf = weakSelf;
			strongSelf.book = book;
			callback(book, error);
		}];
	}
	return self;
}


#pragma mark - 文件路径解析

/**
 *  epub 文件解压
 *
 *  @return 解压后的文件路径
 */
- (NSString *)UnzipEpubWithPath:(NSString *)path {
	
	ZipArchive *zip = [[ZipArchive alloc] init];
	if (![zip UnzipOpenFile:path]) {
		return nil;
	}
	
	NSString *zipFile = [[path stringByDeletingPathExtension] lastPathComponent];
	NSString *zipPath = stringFormat(@"%@/%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject,zipFile);
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:zipPath]) {
		[fileManager removeItemAtPath:path error:nil];
	}
	
	if ([zip UnzipFileTo:stringFormat(@"/%@",zipPath) overWrite:YES]) {
		return zipPath;
	}
	
	return nil;
}

/**
 *  获取 OPF 文件路径
 *
 *  @param epubPath epub 文件路径
 */
- (NSString *)opfPath:(NSString *)UnzipPath {
	NSString *containerPath = stringFormat(@"%@/META-INF/container.xml",UnzipPath);
	
	if (![self fileExistsAtPath:containerPath]) {
		NSLog(@"%@ 无效", containerPath);
		return nil;
	}
	
	NSData *data = [NSData dataWithContentsOfFile:containerPath];
	
	if ([self needDecryptAtFilePath:containerPath]) {
		data = [data AES128CFBDecryptWithBase64:self.base64];
	}
	
	CXMLDocument *document = [[CXMLDocument alloc] initWithData:data options:0 error:nil];
	CXMLNode* opfPath = [document nodeForXPath:@"//@full-path" error:nil];
	
	// xml文件中获取full-path属性的节点  full-path的属性值就是opf文件的绝对路径
	return stringFormat(@"%@/%@",UnzipPath,[opfPath stringValue]);
}


#pragma mark - 文件内容解析

- (void)parseMetaInfo:(NSString *)zipPath completion:(BookParserCompletion)completion {
	if (self.epubPath.length == 0) {
		completion(nil, @"epubPath 无效");
		return;
	}
	
	// epub 解压
	NSString *unzipPath = [self UnzipEpubWithPath:self.epubPath];
	if (!unzipPath) {
		completion(nil, @"epub文件解压失败");
		return;
	}
	
	// 拿标示文件是否加密的信息
	self.encpryptions = [self parseContent:unzipPath];
	
	// 获取 opf 文件路径
	NSString *opfPath = [self opfPath:unzipPath];
	if (!opfPath) {
		completion(nil, @"opf 文件路径错误");
		return;
	}

	BookParserCompletion completionBlock = [completion copy];
	
	[self parseOPF:opfPath completion:^(NSArray<NSDictionary *> *chapters, NSString *error) {
		if (error) {
			completionBlock(nil, @"opf 文件解析失败");
			return;
		}
		
		NSMutableDictionary *book = [NSMutableDictionary dictionary];
		
		[book setObject:chapters forKey:@"chapters"];
		completionBlock(book, nil);
		return;
	}];
}

/// content.xml 文件信息。
/// 拿到是否需要解密的文件列表
- (NSDictionary<NSString*, id> *)parseContent:(NSString *)UnzipPath {
	NSString *contentPath = stringFormat(@"%@/META-INF/content.xml",UnzipPath);
	
	if (![self fileExistsAtPath:contentPath]) {
		return @{};
	}
	
	CXMLDocument* document = [[CXMLDocument alloc] initWithContentsOfURL:
							  [NSURL fileURLWithPath:contentPath] options:0 error:nil];
	
	NSArray<CXMLElement *> *elements = [document nodesForXPath:@"//file" error:nil];
	
	NSMutableDictionary<NSString*, id> *encryptions = [NSMutableDictionary dictionary];
	
	for (CXMLElement *e in elements) {
		CXMLNode *path = [e nodeForXPath:@"./path" error:nil];
		CXMLNode *encryption = [e nodeForXPath:@"./encryption" error:nil];
		
		NSString *pathString = [NSString stringWithFormat:@"%@/%@", UnzipPath, [path stringValue]];
		
		[encryptions setObject:[encryption stringValue] forKey:pathString];
	}
	
	return encryptions;
}



/**
 *  解析 OPF 文件，获取目录信息
 *
 *  @param opfPath OPF 文件路径
 */
- (void)parseOPF:(NSString *)opfPath completion:(ChapterParserCompletion)completion {
	
	NSData *data = [NSData dataWithContentsOfFile:opfPath];
	
	if ([self needDecryptAtFilePath:opfPath]) {
		data = [data AES128CFBDecryptWithBase64:self.base64];
	}
	
	// step1: 拿到 opf 文件中 <item> 标签中的内容
	// 例：<item id="chapter190"  href="chapter190.html"  media-type="application/xhtml+xml"/>
	
	CXMLDocument* document = [[CXMLDocument alloc] initWithData:data options:0 error:nil];
	NSArray<CXMLElement *>* items = [document nodesForXPath:@"//opf:item"
										   namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"]
													   error:nil];
	
	// step2：获取 ncx 文件名称 根据 ncx 获取书的目录
	// 例：<item id="ncx"  href="fb.ncx" media-type="application/x-dtbncx+xml"/>
	
	NSString *ncxFile;
	for (CXMLElement *obj in items) {
		if ([[[obj attributeForName:@"media-type"] stringValue] isEqualToString:@"application/x-dtbncx+xml"]) {
			ncxFile = [[obj attributeForName:@"href"] stringValue];
			break;
		}
	}
	
	if (!ncxFile) {
		completion(nil, @"ncx 文件路径获取失败");
		return;
	}
	
	// step3：根据opf文件的href获取到ncx文件中的中对应的目录名称
	
	ChapterParserCompletion callback = [completion copy];
	
	[self parseNCX:stringFormat(@"%@/%@", [opfPath stringByDeletingLastPathComponent],ncxFile)
		  opfItems:items
		completion:^(NSArray<NSDictionary *> *chapters, NSString *error) {
			if (error) {
				NSLog(@"ncx 文件解析失败");
				return;
			}
			callback(chapters, nil);
			return;
		}];
}

- (void)parseNCX:(NSString *)ncxPath opfItems:(NSArray<CXMLElement *> *)items completion:(ChapterParserCompletion)completion {
	
	NSData *data = [NSData dataWithContentsOfFile:ncxPath];
	
	if ([self needDecryptAtFilePath:ncxPath]) {
		data = [data AES128CFBDecryptWithBase64:self.base64];
	}
	
	// <navPoint id="chapter101" playOrder="5">
	//   <navLabel>
	//     <text>三、加入了反元复宋的队伍</text>
	//   </navLabel>
	//   <content src="chapter101.html"/>
	// </navPoint>
	
	NSString *absolutePath = [ncxPath stringByDeletingLastPathComponent];
	CXMLDocument *ncxDoc = [[CXMLDocument alloc] initWithData:data options:0 error:nil];
	
	NSMutableArray<NSDictionary *> *chapters = [NSMutableArray array];
	for (CXMLElement* element in items) {
		NSString* eId = [[element attributeForName:@"href"] stringValue];
		NSArray<CXMLElement *>* navPoints = [ncxDoc nodesForXPath:stringFormat(@"//ncx:content[@src='%@']/..", eId)
												namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.daisy.org/z3986/2005/ncx/" forKey:@"ncx"]
															error:nil];
		if([navPoints count] !=0 ) {
			CXMLElement* navPoint = navPoints.firstObject;
			
			NSMutableDictionary *dic = [NSMutableDictionary dictionary];
			
			NSString *contentPath = stringFormat(@"%@/%@",absolutePath,[[element attributeForName:@"href"] stringValue]);
			// 文章正文路径
			[dic setObject:contentPath forKey:@"content"];
			// 章节 ID
			[dic setObject:[[navPoint attributeForName:@"id"] stringValue] forKey:@"chapterId"];
			// 章节序号
			[dic setObject:[[navPoint attributeForName:@"playOrder"] stringValue] forKey:@"chapterOrder"];
			
			CXMLElement *navLabel = [navPoint elementsForName:@"navLabel"].firstObject;
			if (navLabel) {
				// 章节名称
				NSString *title =
				[[navLabel stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
				[dic setObject:title forKey:@"chapterTitle"];
			}
			
			if ([self.encpryptions objectForKey:contentPath]) {
				// 是否加密
				[dic setObject:[self.encpryptions objectForKey:contentPath] forKey:@"encryption"];
			}
			
			[chapters addObject:dic];
		}
	}
	
	completion([chapters copy], nil);
}


#pragma mark - private helper method

- (BOOL)fileExistsAtPath:(NSString *)path {
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	if (![fileManager fileExistsAtPath:path]) {
		return NO;
	}
	return YES;
}

- (BOOL)needDecryptAtFilePath:(NSString *)filePath {
	
	if ([self.encpryptions objectForKey:filePath]) {
		return [[self.encpryptions objectForKey:filePath] boolValue];
	}
	
	return NO;
}

@end
