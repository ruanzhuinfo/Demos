// Created by Noah Martin
// http://noahmart.in

#import "NSData+AES128.h"
#import <CommonCrypto/CommonCryptor.h>
#import "AESCipher.h"

@implementation NSData (AES128)

- (NSData *)AES128CFBDecryptWithBase64:(NSString *)base64 {
	NSData *codeData = [[NSData alloc] initWithBase64EncodedString:base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
	NSData *iv = [self subdataWithRange:NSMakeRange(0, 16)];
	AESCipher *cipher = [[AESCipher alloc] initWithMode:MODE_CFB keyData:codeData ivData:iv];
	NSData *result = [cipher decrypt:[self subdataWithRange:NSMakeRange(iv.length, self.length - iv.length)]];
	return result;
}

- (NSData*)AES128CBCDecryptWithKey:(NSString*)key {
    NSMutableData *mutableData = [NSMutableData dataWithData:self];
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
	
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [mutableData length];
    int excess = dataLength % 16;
    if(excess) {
        int padding = 16 - excess;
        [mutableData increaseLengthBy:padding];
        dataLength += padding;
    }
    NSMutableData *returnData = [[NSMutableData alloc] init];
    int bufferSize = 16;
    int start = 0;
    int i = 0;
    while(start < dataLength) {
        i++;
        void *buffer = malloc(bufferSize);
        size_t numBytesDecrypted = 0;
        CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, 0,
                                              keyPtr, kCCKeySizeAES128,
                                              NULL,
                                              [[mutableData subdataWithRange:NSMakeRange(start, bufferSize)] bytes], bufferSize,
                                              buffer, bufferSize,
                                              &numBytesDecrypted);
        if (cryptStatus == kCCSuccess) {
            NSData *piece = [NSData dataWithBytes:buffer length:numBytesDecrypted];
            [returnData appendData:piece];
        }
        free(buffer);
        start += bufferSize;
    }
    return returnData;
}

- (NSData*)AES128CBCEncryptWithKey:(NSString*)key {
    NSMutableData *mutableData = [NSMutableData dataWithData:self];
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [mutableData length];
    int excess = dataLength % 16;
    if(excess) {
        int padding = 16 - excess;
        [mutableData increaseLengthBy:padding];
        dataLength += padding;
    }
    NSMutableData *returnData = [[NSMutableData alloc] init];
    int bufferSize = 16;
    int start = 0;
    int i = 0;
    while(start < dataLength) {
        i++;
        void *buffer = malloc(bufferSize);
        size_t numBytesDecrypted = 0;
        CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, 0,
                                              keyPtr, kCCKeySizeAES128,
                                              NULL,
                                              [[mutableData subdataWithRange:NSMakeRange(start, bufferSize)] bytes], bufferSize,
                                              buffer, bufferSize,
                                              &numBytesDecrypted);
        if (cryptStatus == kCCSuccess) {
            NSData *piece = [NSData dataWithBytes:buffer length:numBytesDecrypted];
            [returnData appendData:piece];
        }
        free(buffer);
        start += bufferSize;
    }
    return returnData;
    return nil;
}

@end
