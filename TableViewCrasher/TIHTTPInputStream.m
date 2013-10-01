//
//  TIHTTPInputStream.m
//  TableViewCrasher
//
//  Created by Sayers, Russell on 9/27/13.
//
//

#import "TIHTTPInputStream.h"

#define AW_LOG_LEVEL AW_LOG_LEVEL_TRACE
//#import "AWLogger.h"
#import "TIHTTPInputStream.h"
//#import "AXException.h"

static const int TIMEOUT_SECS = 90;

#define AWDebug(format, args...) NSLog(format, ##args)
#define AWTrace(format, args...) NSLog(format, ##args)

@implementation TIHTTPInputStream

//@synthesize networkObserver;
@synthesize totalBytesReceived;
@synthesize firstChunk;
@synthesize lastByte;
@synthesize closed;

- (id)initWithRequest:(NSURLRequest *)theRequest {
    self = [super init];
    if (self) {
        closed = NO;
        done = NO;
        responseDataIndex = 0;
        request = theRequest;
        responseDataCapacity = 0;
        responseData = [[NSMutableData alloc] initWithCapacity:responseDataCapacity];
        myRunLoop = [NSRunLoop currentRunLoop];
        firstChunk = 0.0f;
        lastByte = 0.0f;
    }
    
    return self;
}

// close is the only method that can be called from another thread
- (void)close {
    if (!done && !closed) {
        AWDebug(@"%@ AXHTTPInputStream.close()", self);
        [connection cancel];
        closed = YES;
        CFRunLoopWakeUp([myRunLoop getCFRunLoop]);
    }
    else {
        AWDebug(@"%@ AXHTTPInputStream.close() IGNORED - done=%d closed=%d", self, done, closed);
    }
}

- (void)open {
    AWDebug(@"%@ AXHTTPInputStream.open()", self);
    timeout = [NSDate dateWithTimeIntervalSinceNow:TIMEOUT_SECS];
    
    // initiate the request
    connection = [NSURLConnection connectionWithRequest:request delegate:self];
    NSAssert(nil != connection, @"failed to create NSURLConnection");
}

- (NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)maxLength {
    AWTrace(@"%@ AXHTTPInputStream.read maxLength=%d, timeout= %@", self, maxLength, timeout);
    NSUInteger availableBytes = [responseData length] - responseDataIndex;
    
    for (;!done && (availableBytes < maxLength);) {
        AWTrace(@"ENTERING RUNLOOP responseData.maxLength=%d  responseDataIndex=%d  availableBytes=%d", maxLength, responseDataIndex, availableBytes);
        BOOL b = [myRunLoop runMode:NSDefaultRunLoopMode beforeDate:timeout];
        // "b" is only used in the assert a few lines below.
        // This line is here to avoid an "unused variable" warning which is treated as an error because
        // the build server uses the OTHER_CFLAGS=-DNS_BLOCK_ASSERTIONS=1 option which removes asserts
        ((void)b);
        
        if (closed) {
            //[NSException raise:IOException format:@"connection closed"];
        }
        
        NSAssert(b, @"ERROR - run loop started without input source defined for NSDefaultRunLoopMode");
        availableBytes = [responseData length] - responseDataIndex;
        
        // check for timeout
        if ([timeout compare:[NSDate date]] == NSOrderedAscending) {
//            @throw [NSException
//                    //exceptionWithName: @"IOException"
//                    exceptionWithName: IOException
//                    reason: [NSString stringWithFormat:@"connection timeout exceeded: timeout (secs) = %d", TIMEOUT_SECS]
//                    userInfo: nil
//                    ];
            break;
        }
    }
    
    NSUInteger bytesRead = maxLength;
    AWTrace(@"AFTER RUNLOOP responseData.maxLength=%d  responseDataIndex=%d  availableBytes=%d", maxLength, responseDataIndex, availableBytes);
    if (availableBytes < maxLength) {
        bytesRead = availableBytes;
    }
    
    NSRange range = {responseDataIndex, bytesRead};
    [responseData getBytes:buffer range:range];
    responseDataIndex += bytesRead;
    
    return (NSInteger)bytesRead;
}

- (BOOL)getBuffer:(uint8_t **)buffer length:(NSUInteger *)len { return NO; }

- (BOOL)hasBytesAvailable {
    if (done) {
        return NO;
    }
    
    return YES;
}

// NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //[networkObserver didFailWithError:error];
    
    // Apple's localized error messages are good enough
    //NSException* exception = [NSException exceptionWithName:NetworkError
//                                                     reason:[error localizedDescription] 
//                                                   userInfo:[NSDictionary dictionaryWithObject:error forKey:@"NSError"]];
    //[exception raise];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    lastByte = [NSDate timeIntervalSinceReferenceDate];
    AWDebug(@"    delegate.didReceiveData: data.length=%d", [data length]);
    //[networkObserver didReceiveDataOfLength:[data length]];
    
    totalBytesReceived += [data length];
    didReceiveData = YES;
    
    NSUInteger newLength = [responseData length] - responseDataIndex + data.length;
    if (responseDataIndex + newLength < responseDataCapacity) {
        // Plenty of room -- append to existing buffer, that's faster
        [responseData appendData:data];
    } else {
        if (responseDataIndex) {
            [responseData replaceBytesInRange:NSMakeRange(0, responseDataIndex) withBytes:NULL length:0];
            responseDataIndex = 0;
        }
        [responseData appendData:data];
        responseDataCapacity = MAX(responseDataCapacity, newLength);
    }
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
    if (0.0f == firstChunk) {
        firstChunk = [NSDate timeIntervalSinceReferenceDate];
    }
    //[networkObserver didReceiveResponse:response]; // records the response time and the content-length
    AWDebug(@"    delegate.didReceiveResponse statusCode: %d %@", [response statusCode], [response allHeaderFields]);
    // we can't handle a new response if we've already started receiving (and processing) data
    NSAssert(!didReceiveData, @"Received didReceiveResponse after didReceiveData");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    AWDebug(@"    delegate.connectionDidFinishLoading");
    done = YES;
}

@end

