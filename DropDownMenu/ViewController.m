//
//  ViewController.m
//  DropDownMenu
//
//  Created by jamesSU on 2017/4/26.
//  Copyright © 2017年 jamesSU. All rights reserved.
//

#import "ViewController.h"
#import "DropDownMenu.h"

@interface ViewController ()<DropDownMenuDataSource, DropDownMenuDelegate>

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    DropDownMenu *menu = [[DropDownMenu alloc]initWithOrigin:CGPointMake(0, 44)];
    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];
    
}


- (void)menu:(DropDownMenu *)menu didSelectRowAtIndexPath:(DMIndexPath *)indexPath rightOrLeft:(BOOL)isRightRow
{
    NSLog(@"did select column %@ row %@ rightRow %@, isRightRow %@",@(indexPath.column), @(indexPath.row),  @(indexPath.rightRow), @(isRightRow));
}

- (NSUInteger)numberOfColumnsInMenu:(DropDownMenu *)menu
{
    return 3;
}

- (BOOL)haveRightTableAtColumn:(NSUInteger)column
{
    if(column == 1) {
        return YES;
    }
    return NO;
}

- (NSString *)titleForRowInColumn:(NSUInteger)column rightOrLeft:(BOOL)isRight row:(NSUInteger)row
{
    return @"萨达是大所大所多";
}

- (NSInteger)numberOfRowsInColumn:(NSUInteger)column rightOrLeft:(BOOL)isRight
{
    if(column == 1) {
        
        if(isRight) {
            return 10;
        }
        return 20;
    }
    return 10;
}

- (CGFloat)widthRatioOfLeftColumn:(NSUInteger)column
{
    if(column == 1) {
        return 0.5;
    }
    
    return 1.0;
}

@end
