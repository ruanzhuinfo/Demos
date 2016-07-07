/**
 * rijndael-alg-fst.c
 *
 * @version 3.0 (December 2000)
 *
 * Optimised ANSI C code for the Rijndael cipher (now AES)
 *
 * @author Vincent Rijmen <vincent.rijmen@esat.kuleuven.ac.be>
 * @author Antoon Bosselaers <antoon.bosselaers@esat.kuleuven.ac.be>
 * @author Paulo Barreto <paulo.barreto@terra.com.br>
 *
 * This code is hereby placed in the public domain.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHORS ''AS IS'' AND ANY EXPRESS
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHORS OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "AESCipher.h"
#include "AES.c"

@implementation AESCipher {
    block_state st;
}

-(id)initWithMode:(int)aesMode keyData:(NSData *)keyData ivData:(NSData *)ivData {
    if ((self = [super init])) {

        unsigned char *key, *lIV;
    	int keylen, IVlen=0, lmode= MODE_ECB, lsegment_size=0;
    	void *lcounter = NULL;

    	// Set default values
        key = (unsigned char *)[keyData bytes];
        keylen = (int)keyData.length;
        lIV = (unsigned char *)[ivData bytes];
        IVlen = (int)ivData.length;
        lmode = aesMode;


    	if (KEY_SIZE!=0 && keylen!=KEY_SIZE)
    	{
            printf("Key must be %i bytes long, not %i", KEY_SIZE, keylen);
    		return NULL;
    	}
    	if (KEY_SIZE==0 && keylen==0)
    	{
            printf("Key cannot be the null string");
    		return NULL;
    	}
    	if (IVlen != BLOCK_SIZE && IVlen != 0)
    	{
            printf("IV must be %i bytes long", BLOCK_SIZE);
    		return NULL;
    	}
    	if (lmode<MODE_ECB || lmode>MODE_CTR)
    	{
            printf("Unknown cipher feedback mode %i", mode);
    		return NULL;
    	}

    	// Mode-specific checks
    	if (lmode == MODE_CFB) {
    		if (lsegment_size == 0) lsegment_size = 8;
    		if (lsegment_size < 1 || lsegment_size > BLOCK_SIZE*8) {
                printf("segment_size must be multiple of 8 between 1 and %i", BLOCK_SIZE);
    		}
    	}

    	if (lmode == MODE_CTR) {
    		if (NULL == lcounter) {
                printf("'counter' parameter must be a callable object");
    		}
    	} else {
    		if (lcounter != NULL) {
                printf("'counter' parameter only useful with CTR mode");
    		}
    	}

    	// Copy parameters into object
    	//new = newALGobject();
        self->segment_size = lsegment_size;
        self->counter = lcounter;

        block_init(&(self->st), key, keylen);
    	//if (PyErr_Occurred())
    	//{
    	//	Py_DECREF(new);
    	//	return NULL;
    	//}

    	memset(self->IV, 0, BLOCK_SIZE);
    	memset(self->oldCipher, 0, BLOCK_SIZE);
    	memcpy(self->IV, lIV, IVlen);
        self->mode = lmode;
        self->count=8;

        // NSLog(@"Init AESCipher\n\nKey        %s (keylen=%i) \nIV         %s (ivLen=%i) \nMode       %i \n", key, keylen, self->IV, IVlen, self->mode);
    }
    return self;
}

-(void)dealloc {

    // Overwrite the contents of the object
    self->counter = NULL;
    self->counter = NULL;
    memset(self->IV, 0, BLOCK_SIZE);
    memset(self->oldCipher, 0, BLOCK_SIZE);
    memset((char*)&(self->st), 0, sizeof(block_state));
    self->mode = self->count = self->segment_size = 0;

    [super dealloc];
}

- (NSData *)encrypt:(NSData*)plainData {
    unsigned char *buffer, *str;
   	unsigned char temp[BLOCK_SIZE];
   	int i, j, len;

    str = (unsigned char *)plainData.bytes;
    len = (int)plainData.length;

	//NSLog(@"Plaintext-Objc: %s", plainData.bytes);

   	if (len==0)
   	{
        NSLog(@"Invalid ciphertext of len 0");
   		return nil;
   	}
   	if ( (len % BLOCK_SIZE) !=0 &&
   	     (self->mode!=MODE_CFB) && (self->mode!=MODE_PGP))
   	{
        NSLog(@"Input strings must be a multiple of %i in length", BLOCK_SIZE);
   		return nil;
   	}
   	if (self->mode == MODE_CFB &&
   	    (len % (self->segment_size/8) !=0)) {
           NSLog(@"Input strings must be a multiple of the segment size %i in length", self->segment_size/8);
   		return nil;
   	}

   	buffer=malloc(len);
   	if (buffer==NULL)
   	{
           NSLog(@"No memory available in encrypt");
   		return nil;
   	}
   	switch(self->mode)
   	{
   	case(MODE_ECB):
   		for(i=0; i<len; i+=BLOCK_SIZE)
   		{
   			block_encrypt(&(self->st), str+i, buffer+i);
   		}
   		break;

   	case(MODE_CBC):
   		for(i=0; i<len; i+=BLOCK_SIZE)
   		{
   			for(j=0; j<BLOCK_SIZE; j++)
   			{
   				temp[j]=str[i+j]^self->IV[j];
   			}
   			block_encrypt(&(self->st), temp, buffer+i);
   			memcpy(self->IV, buffer+i, BLOCK_SIZE);
   		}
   		break;

   	case(MODE_CFB):
   		for(i=0; i<len; i+=self->segment_size/8)
   		{
   			block_encrypt(&(self->st), self->IV, temp);
   			for (j=0; j<self->segment_size/8; j++) {
   				buffer[i+j] = str[i+j] ^ temp[j];
   			}
   			if (self->segment_size == BLOCK_SIZE * 8) {
   				/* s == b: segment size is identical to
   				   the algorithm block size */
   				memcpy(self->IV, buffer + i, BLOCK_SIZE);
   			}
   			else if ((self->segment_size % 8) == 0) {
   				int sz = self->segment_size/8;
   				memmove(self->IV, self->IV + sz,
   					BLOCK_SIZE-sz);
   				memcpy(self->IV + BLOCK_SIZE - sz, buffer + i,
   				       sz);
   			}
   			else {
   				/* segment_size is not a multiple of 8;
   				   currently this can't happen */
   			}
   		}
   		break;

   	case(MODE_PGP):
   		if (len<=BLOCK_SIZE-self->count)
   		{
   			/* If less than one block, XOR it in */
   			for(i=0; i<len; i++)
   				buffer[i] = self->IV[self->count+i] ^= str[i];
   			self->count += len;
   		}
   		else
   		{
   			int j;
   			for(i=0; i<BLOCK_SIZE-self->count; i++)
   				buffer[i] = self->IV[self->count+i] ^= str[i];
   			self->count=0;
   			for(; i<len-BLOCK_SIZE; i+=BLOCK_SIZE)
   			{
   				block_encrypt(&(self->st), self->oldCipher,
   					      self->IV);
   				for(j=0; j<BLOCK_SIZE; j++)
   					buffer[i+j] = self->IV[j] ^= str[i+j];
   			}
   			/* Do the remaining 1 to BLOCK_SIZE bytes */
   			block_encrypt(&(self->st), self->oldCipher, self->IV);
   			self->count=len-i;
   			for(j=0; j<len-i; j++)
   			{
   				buffer[i+j] = self->IV[j] ^= str[i+j];
   			}
   		}
   		break;

   	case(MODE_OFB):
   		for(i=0; i<len; i+=BLOCK_SIZE)
   		{
   			block_encrypt(&(self->st), self->IV, temp);
   			memcpy(self->IV, temp, BLOCK_SIZE);
   			for(j=0; j<BLOCK_SIZE; j++)
   			{
   				buffer[i+j] = str[i+j] ^ temp[j];
   			}
   		}
   		break;

   	case(MODE_CTR):
           /*
   		for(i=0; i<len; i+=BLOCK_SIZE)
   		{
   			PyObject *ctr = PyObject_CallObject(self->counter, NULL);
   			if (ctr == NULL) {
   				free(buffer);
   				return NULL;
   			}
   			if (!PyString_Check(ctr))
   			{
   				PyErr_SetString(PyExc_TypeError,
   						"CTR counter function didn't return a string");
   				Py_DECREF(ctr);
   				free(buffer);
   				return NULL;
   			}
   			if (PyString_Size(ctr) != BLOCK_SIZE) {
   				PyErr_Format(PyExc_TypeError,
   					     "CTR counter function returned "
   					     "string not of length %i",
   					     BLOCK_SIZE);
   				Py_DECREF(ctr);
   				free(buffer);
   				return NULL;
   			}
   			block_encrypt(&(self->st), PyString_AsString(ctr),
   				      temp);
   			Py_DECREF(ctr);
   			for(j=0; j<BLOCK_SIZE; j++)
   			{
   				buffer[i+j] = str[i+j]^temp[j];
   			}
   		}    */
   		break;

   	default:
               NSLog(@"Unknown ciphertext feedback mode %i; this shouldn't happen",
   			     self->mode);
   		free(buffer);
   		return NULL;
   	}

    //buffer[len] = '\0';
	NSData *result = [[[NSData alloc] initWithBytes:buffer length:len] autorelease];
	free(buffer);

   	return result;
}

-(NSData *)decrypt:(NSData*)cipherData
{
    unsigned char *buffer, *str;
	unsigned char temp[BLOCK_SIZE];
	int i, j, len;


    str = (unsigned char *)cipherData.bytes;
    len = (int)cipherData.length;

	//NSLog(@"Cipher-Objc (%i | %i): %s", cipherData.length, len, cipherData.bytes);

    if (len==0)			// Handle empty string
	{
        NSLog(@"Invalid plaintext of len 0");
		return nil;
	}
	if ( (len % BLOCK_SIZE) !=0 &&
	     (self->mode!=MODE_CFB && self->mode!=MODE_PGP))
	{
        NSLog(@"Input strings must be a multiple of %i in length", BLOCK_SIZE);
		return nil;
	}
	if (self->mode == MODE_CFB && (len % (self->segment_size/8) !=0)) {
        NSLog(@"Input strings must be a multiple of  the segment size %i in length", self->segment_size/8);
		return nil;
	}

	buffer = malloc(len);
	if (buffer==NULL)
	{
        NSLog(@"No memory available in decrypt");
		return nil;
	}

    switch(self->mode)
	{
	case(MODE_ECB):
		for(i=0; i<len; i+=BLOCK_SIZE)
		{
			block_decrypt(&(self->st), str+i, buffer+i);
		}
		break;

	case(MODE_CBC):
		for(i=0; i<len; i+=BLOCK_SIZE)
		{
			memcpy(self->oldCipher, self->IV, BLOCK_SIZE);
			block_decrypt(&(self->st), str+i, temp);
			for(j=0; j<BLOCK_SIZE; j++)
			{
				buffer[i+j]=temp[j]^self->IV[j];
				self->IV[j]=str[i+j];
			}
		}
		break;

	case(MODE_CFB):
		for(i=0; i<len; i+=self->segment_size/8)
		{
			block_encrypt(&(self->st), self->IV, temp);
			for (j=0; j<self->segment_size/8; j++) {
				buffer[i+j] = str[i+j]^temp[j];
			}
			if (self->segment_size == BLOCK_SIZE * 8) {
				// s == b: segment size is identical to  the algorithm block size
				memcpy(self->IV, str + i, BLOCK_SIZE);
			}
			else if ((self->segment_size % 8) == 0) {
				int sz = self->segment_size/8;
				memmove(self->IV, self->IV + sz, BLOCK_SIZE-sz);
				memcpy(self->IV + BLOCK_SIZE - sz, str + i, sz);
			}
			else {
				// segment_size is not a multiple of 8; currently this can't happen
			}
		}
		break;

	case(MODE_PGP):
		if (len<=BLOCK_SIZE-self->count)
		{
            // If less than one block, XOR it in
			unsigned char t;
			for(i=0; i<len; i++)
			{
				t=self->IV[self->count+i];
				buffer[i] = t ^ (self->IV[self->count+i] = str[i]);
			}
			self->count += len;
		}
		else
		{
			int j;
			unsigned char t;
			for(i=0; i<BLOCK_SIZE-self->count; i++)
			{
				t=self->IV[self->count+i];
				buffer[i] = t ^ (self->IV[self->count+i] = str[i]);
			}
			self->count=0;
			for(; i<len-BLOCK_SIZE; i+=BLOCK_SIZE)
			{
				block_encrypt(&(self->st), self->oldCipher, self->IV);
				for(j=0; j<BLOCK_SIZE; j++)
				{
					t=self->IV[j];
					buffer[i+j] = t ^ (self->IV[j] = str[i+j]);
				}
			}
			// Do the remaining 1 to BLOCK_SIZE bytes
			block_encrypt(&(self->st), self->oldCipher, self->IV);
			self->count=len-i;
			for(j=0; j<len-i; j++)
			{
				t=self->IV[j];
				buffer[i+j] = t ^ (self->IV[j] = str[i+j]);
			}
		}
		break;

	case (MODE_OFB):
		for(i=0; i<len; i+=BLOCK_SIZE)
		{
			block_encrypt(&(self->st), self->IV, temp);
			memcpy(self->IV, temp, BLOCK_SIZE);
			for(j=0; j<BLOCK_SIZE; j++)
			{
				buffer[i+j] = str[i+j] ^ self->IV[j];
			}
		}
		break;

	case (MODE_CTR):
        /*
		for(i=0; i<len; i+=BLOCK_SIZE)
		{
			PyObject *ctr = PyObject_CallObject(self->counter, NULL);
			if (ctr == NULL) {
				free(buffer);
				return NULL;
			}
			if (!PyString_Check(ctr))
			{
				PyErr_SetString(PyExc_TypeError,
						"CTR counter function didn't return a string");
				Py_DECREF(ctr);
				free(buffer);
				return NULL;
			}
			if (PyString_Size(ctr) != BLOCK_SIZE) {
				PyErr_SetString(PyExc_TypeError,
						"CTR counter function returned string of incorrect length");
				Py_DECREF(ctr);
				free(buffer);
				return NULL;
			}
			block_encrypt(&(self->st), PyString_AsString(ctr), temp);
			Py_DECREF(ctr);
			for(j=0; j<BLOCK_SIZE; j++)
			{
				buffer[i+j] = str[i+j]^temp[j];
			}
		}
		*/
		break;

	default:
        NSLog(@"Unknown ciphertext feedback mode %i; this shouldn't happen", self->mode);
		free(buffer);
		return nil;
	}

    buffer[len] = '\0';
	NSData *result = [[[NSData alloc] initWithBytes:buffer length:len] autorelease];
    free(buffer);

	//NSLog(@"Cipher-Objc (%i <> %i): %s <> %s ", len, result.length, cipherData.bytes, result.bytes);

    return result;
}

@end