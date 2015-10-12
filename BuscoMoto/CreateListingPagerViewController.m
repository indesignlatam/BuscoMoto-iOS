//
//  CreateListingPagerViewController.m
//  BuscoMoto
//
//  Created by Paulo Mogollon on 10/4/15.
//  Copyright © 2015 Indesign Colombia. All rights reserved.
//

#import "CreateListingPagerViewController.h"
#import "XLPagerTabStripViewController.h"

@interface CreateListingPagerViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation CreateListingPagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.navigationController){
        UILabel *bigLabel = [[UILabel alloc] init];
        bigLabel.backgroundColor = [UIColor clearColor];
        bigLabel.textColor = [UIColor whiteColor];
        bigLabel.font = [UIFont boldSystemFontOfSize:20];
        bigLabel.adjustsFontSizeToFitWidth = YES;
        self.navigationItem.titleView = bigLabel;
        [bigLabel sizeToFit];
    }
    [[self childViewControllers] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[XLPagerTabStripViewController class]]){
            XLPagerTabStripViewController * pagerController = (id)obj;
            [self updateTitle:pagerController];
            *stop = YES;
        }
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateTitle:(XLPagerTabStripViewController *)pagerController{
    NSString * title = [NSString stringWithFormat:@"Progressive = %@  ElasticLimit = %@",[self stringFromBool:pagerController.isProgressiveIndicator] ,[self stringFromBool:pagerController.isElasticIndicatorLimit]];
    self.titleLabel.text = title;
    ((UILabel *)self.navigationItem.titleView).text = title;
    [((UILabel *)self.navigationItem.titleView) sizeToFit];
}

-(NSString *)stringFromBool:(BOOL)value{
    return value ? @"YES" : @"NO";
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
