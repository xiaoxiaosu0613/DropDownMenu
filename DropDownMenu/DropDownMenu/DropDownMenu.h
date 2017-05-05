//
//  DropDownMenu.h
//  DropDownMenu
//
//  Created by jamesSU on 2017/4/26.
//  Copyright © 2017年 jamesSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DropDownMenu;

@interface DMIndexPath : NSObject

@property (nonatomic, assign) NSUInteger column;

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, assign) NSInteger rightRow;

@property (nonatomic, assign, readonly) NSInteger leftRow;

@property (nonatomic, assign, getter=isHaveRightRow) BOOL haveRightRow;

@property (nonatomic, assign, readonly) NSUInteger section;

@end

@protocol DropDownMenuDataSource <NSObject>

@required

- (NSInteger)numberOfRowsInColumn:(NSUInteger)column rightOrLeft:(BOOL)isRight;

- (NSString *)titleForRowInColumn:(NSUInteger)column rightOrLeft:(BOOL)isRight row:(NSUInteger)row;

@optional

- (NSUInteger)numberOfColumnsInMenu:(DropDownMenu *)menu;

- (BOOL)haveRightTableAtColumn:(NSUInteger)column;

- (CGFloat)widthRatioOfLeftColumn:(NSUInteger)column;

@end

@protocol DropDownMenuDelegate <NSObject>

@optional

- (BOOL)menu:(DropDownMenu *)menu willTapColumn:(NSInteger)column;

- (void)menu:(DropDownMenu *)menu didSelectRowAtIndexPath:(DMIndexPath *)indexPath rightOrLeft:(BOOL)isRightRow;

@end


@interface DropDownMenu : UIView <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id <DropDownMenuDataSource> dataSource;

@property (nonatomic, weak) id <DropDownMenuDelegate> delegate;

@property (nonatomic, strong) NSArray <NSString *> *defaultTitles;

/**
 *  default is lightGray
 */
@property (nonatomic, strong)UIColor *menuWordUnselectColor;


@property (nonatomic, strong)UIColor *menudefaultColor;


@property (nonatomic, strong, readonly) UITableView *rightTableView;

/**
 *  the width of menu will be set to screen width defaultly
 *
 *  @param origin the origin of this view's frame, height defult is 40
 *
 *  @return menu
 */
- (instancetype)initWithOrigin:(CGPoint)origin;

//- (NSString *)titleForRowAtIndexPath:(JSIndexPath *)indexPath;

- (void)confiMenuWithSelectRow:(NSInteger)row leftOrRight:(NSInteger)leftOrRight atMenuIndex:(NSInteger)index;

- (void)menuTappedAtIndex:(NSInteger)tapIndex;

- (void)hideBackgroundView;

- (void)updateTitle:(NSString *)title atMenuColumn:(NSUInteger)column;

@end
