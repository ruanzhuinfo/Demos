// Created by Noah Martin
// http://noahmart.in

#import <Foundation/Foundation.h>

@interface NSData (AES128)

- (NSData*)AES128CBCDecryptWithKey:(NSString*)key;
- (NSData*)AES128CBCEncryptWithKey:(NSString*)key;

- (NSData *)AES128CFBDecryptWithBase64:(NSString *)base64;

@end
