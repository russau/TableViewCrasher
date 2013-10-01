//
//  TIMainViewController.m
//  TableViewCrasher
//
//  Created by Sayers, Russell on 9/20/13.
//
//

#import "TIMainViewController.h"
#import "TICrashTableController.h"
#import "TIHTTPInputStream.h"
#import "TIAppDelegate.h"
#import "TIWebViewController.h"



@interface TIMainViewController ()

@end

@implementation TIMainViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
//    NSDictionary* cookieProperties = @{
//                                       NSHTTPCookieName: @"cookie-set-from-code",
//                                       NSHTTPCookieValue: @"blech",
//                                       NSHTTPCookieDomain: @"test-ssl.tinisles.com",
//                                       NSHTTPCookieDiscard: @"FALSE",
//                                       NSHTTPCookiePath: @"/"
//                                       };
//    NSHTTPCookie* cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];   
//    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
//    
//      
//    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushCrash)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    
    webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.backgroundColor = [UIColor whiteColor];
    webView.scalesPageToFit = NO;
    
    [self.view addSubview:webView];
    
    NSLog(@"webView.scrollView.contentInset !!!!!!!! %p %f %f", webView, webView.scrollView.contentInset.top, webView.scrollView.contentInset.bottom);
    
    NSURL *url = [NSURL URLWithString:@"http://test-ssl.tinisles.com/"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [webView loadRequest:req];
}




- (void) pushCrash
{
    
    if (!TIAppDelegate.webView) {
        [webView removeFromSuperview];
        TIAppDelegate.webView = webView;
        TIWebViewController *wvc = [[TIWebViewController alloc] init];
        [[self navigationController] pushViewController:wvc animated:YES];
        //
    } else {
        [self.view addSubview:TIAppDelegate.webView];
        TIAppDelegate.webView = nil;

    }
    
    NSLog(@"webView.scrollView.contentInset !!!!!!!! %p %f %f", webView, webView.scrollView.contentInset.top, webView.scrollView.contentInset.bottom);    
    
    
    
//    NSURL *url = [NSURL URLWithString:@"http://test-ssl.tinisles.com/"];
//    NSURLRequest *req = [NSURLRequest requestWithURL:url];
//    TIHTTPInputStream *stream = [[TIHTTPInputStream alloc] initWithRequest:req];    
//    [stream open];
    
//    TICrashTableController *crasher = [[TICrashTableController alloc] init];
//    [[self navigationController] pushViewController:crasher animated:YES];
        
//    BOOL cookieEnabled = [[webView stringByEvaluatingJavaScriptFromString:@"navigator.cookieEnabled"] boolValue];
//    NSString *message = cookieEnabled ? @"enabled" : @"not enabled";
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil
//                                                     message:message
//                                                    delegate:self
//                                           cancelButtonTitle:@"ok" otherButtonTitles:nil];
//    [alert show];

}

@end
