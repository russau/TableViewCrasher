//
//  TIWebViewController.m
//  TableViewCrasher
//
//  Created by Sayers, Russell on 9/30/13.
//
//

#import "TIWebViewController.h"
#import "TIAppDelegate.h"


@implementation TIWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:TIAppDelegate.webView];
    TIAppDelegate.webView = nil;
    
}



@end
