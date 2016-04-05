//
//  ViewController.m
//  cricularImage
//
//  Created by 诸超杰 on 16/4/5.
//  Copyright © 2016年 诸超杰. All rights reserved.
//

#import "ViewController.h"
#import "CricularImage.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 1; i < 6; i ++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]];
        [array addObject:image];
    }
    CricularImage *cricularImage = [[CricularImage alloc] initWithFrame:[UIScreen mainScreen].bounds withContentArray:array];
    [self.view addSubview:cricularImage];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
