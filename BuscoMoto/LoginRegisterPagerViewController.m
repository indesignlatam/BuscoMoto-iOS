//
//  LoginRegisterPagerViewController.m
//  BuscoMoto
//
//  Created by Paulo Mogollon on 10/3/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import "LoginRegisterPagerViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"

@interface LoginRegisterPagerViewController ()

@end

@implementation LoginRegisterPagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Inicia Sesión"];
    
    // Do any additional setup after loading the view.
    self.isProgressiveIndicator = YES;
    self.isElasticIndicatorLimit = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XLPagerTabStripViewControllerDataSource
-(NSArray *)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController{
    // create child view controllers that will be managed by XLPagerTabStripViewController
    UIStoryboard *storyboard = self.storyboard;
    LoginViewController *loginView = [storyboard instantiateViewControllerWithIdentifier:@"loginView"];
    
    RegisterViewController *registerView = [storyboard instantiateViewControllerWithIdentifier:@"registerView"];
    return @[loginView, registerView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
