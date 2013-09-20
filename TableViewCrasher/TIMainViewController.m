//
//  TIMainViewController.m
//  TableViewCrasher
//
//  Created by Sayers, Russell on 9/20/13.
//
//

#import "TIMainViewController.h"
#import "TICrashTableController.h"

@interface TIMainViewController ()

@end

@implementation TIMainViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushCrash)];
    self.navigationItem.rightBarButtonItem = refreshButton;

}

- (void) pushCrash
{
    TICrashTableController *crasher = [[TICrashTableController alloc] init];
    [[self navigationController] pushViewController:crasher animated:YES];

}

@end
