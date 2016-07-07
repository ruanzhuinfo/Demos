//
//  Created by Alexander Lehnert on 04.03.12.
//  Copyright 2011 Alexander Lehnert
//

#import <Foundation/Foundation.h>

#define MODULE_NAME AES
#define BLOCK_SIZE 16
#define KEY_SIZE 0

#define MODE_ECB 1
#define MODE_CBC 2
#define MODE_CFB 3
#define MODE_PGP 4
#define MODE_OFB 5
#define MODE_CTR 6

@interface AESCipher : NSObject {
    
   @public
    int mode, count, segment_size;
    unsigned char IV[BLOCK_SIZE];
    unsigned char oldCipher[BLOCK_SIZE];
    void *counter;
}

-(id)initWithMode:(int)aesMode keyData:(NSData *)keyData ivData:(NSData *)ivData;

-(NSData *)decrypt:(NSData*)cipherData;
-(NSData *)encrypt:(NSData*)plainData;

@end
