//
//  GraphicViewController.m
//  Semaphore Control
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 02/10/15.
//  Copyright © 2015 Leonardo Vinicius Kaminski Ferreira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GraphicViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "Constants.h"
#import "HelperFunctions.h"
#import "JBChartView.h"
#import "JBBarChartView.h"
#import "JBLineChartView.h"

#import "JBBarChartViewController.h"

@interface GraphicViewController ()

@end

@implementation GraphicViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    JBBarChartViewController *barChartController = [[JBBarChartViewController alloc] init];
    //[self.navigationController pushViewController:barChartController animated:YES];
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:barChartController, nil];
    [self.navigationController setViewControllers:array];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) viewDidAppear:(BOOL)animated {
    
    
}


@end