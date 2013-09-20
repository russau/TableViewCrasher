//
//  TICrashTableController.m
//  TableViewCrasher
//
//  Created by Sayers, Russell on 9/20/13.
//
//

#import "TICrashTableController.h"

@interface TICrashTableController ()

@property (nonatomic) UITextField* emailTextField;
@property (nonatomic) UITextField* passwordTextField;

@end

@implementation TICrashTableController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)]; 
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 500.0f;
        //return [self headerView].frame.size.height;
    }
    return 0.0f;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    
    if ((long)sectionIndex==0) return 2;
    if ((long)sectionIndex==1) return 0;
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // this breaks
    UITableViewCell* nc = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    // this works
    //UITableViewCell* nc = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    
    nc.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView* contentView = nc.contentView;
    
    if ((NSUInteger)indexPath.section == 0)
    {
        if ((NSUInteger)indexPath.row == 0)
        {
            [contentView addSubview:self.emailTextField];
            [self.emailTextField resignFirstResponder];
        }
        else
        {
            [contentView addSubview:self.passwordTextField];
        }
    }
    
    // stashing cells into an array also seems to give them a "stay of execution" that fixes the problem
    //[cells addObject:nc];
    return nc;
    
    
}

@end
