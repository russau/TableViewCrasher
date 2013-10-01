//
//  TIHTTPInputStream.h
//  TableViewCrasher
//
//  Created by Sayers, Russell on 9/27/13.
//
//

#import <Foundation/Foundation.h>

@interface TIHTTPInputStream : NSInputStream {
@private
    NSURLRequest *request;
    NSURLConnection *connection;
    BOOL didReceiveData;
    NSMutableData *responseData;
    NSUInteger responseDataIndex;
    NSUInteger responseDataCapacity;
    NSDate *timeout;
    volatile BOOL closed;
    volatile BOOL done;
    NSRunLoop *myRunLoop;
    //AXNetworkObserver* networkObserver;
    NSUInteger totalBytesReceived;
    NSTimeInterval firstChunk;
    NSTimeInterval lastByte;
}

-(id)initWithRequest:(NSURLRequest *)theRequest;

//@property (atomic) AXNetworkObserver* networkObserver;
@property (atomic,readonly) NSUInteger totalBytesReceived;
@property (atomic,readonly) NSTimeInterval firstChunk;
@property (atomic,readonly) NSTimeInterval lastByte;
@property (atomic,readonly) volatile BOOL closed;

@end
