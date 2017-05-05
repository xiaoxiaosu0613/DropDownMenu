//
//  DropDownMenu.m
//  DropDownMenu
//
//  Created by jamesSU on 2017/4/26.
//  Copyright © 2017年 jamesSU. All rights reserved.
//

#import "DropDownMenu.h"
#import <Masonry/Masonry.h>
#import "DropDownMenuConfig.h"
#import "UIView+DropDownMenu.h"

#define BackColor (self.backgroundColor ? : [UIColor whiteColor])

@interface UIImage (YHExt)

+ (UIImage *)imageWithColor:(UIColor *)color;

@end

@implementation UIImage (YHExt)


+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end

@interface DropDownMenuItem: UIView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *indicator;

@property (nonatomic, assign, getter=isSelected) BOOL selected;

@property (nonatomic, assign) NSUInteger index;

@end

@implementation DropDownMenuItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor whiteColor];
    self.selected = NO;
    self.index = 0;
    
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = menuTitleColor;
    label.highlightedTextColor = menuTitleSelectedColor;
    [self addSubview:label];
    self.titleLabel = label;
    
    UIImageView *imageview = [[UIImageView alloc]init];
    imageview.image = menuIndicator;
    imageview.highlightedImage = menuSelectedIndicator;
    [self addSubview:imageview];
    self.indicator = imageview;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_greaterThanOrEqualTo(8);
        make.centerX.equalTo(@-8);
        make.centerY.equalTo(self);
    }];
    
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.lessThanOrEqualTo(@-8);
        make.left.equalTo(label.mas_right).offset(4);
        make.centerY.equalTo(label);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    [imageview setContentHuggingPriority:UILayoutPriorityRequired
                                 forAxis:UILayoutConstraintAxisHorizontal];
    [imageview setContentCompressionResistancePriority:UILayoutPriorityRequired
                                               forAxis:UILayoutConstraintAxisHorizontal];
    [label setContentHuggingPriority:UILayoutPriorityDefaultLow
                             forAxis:UILayoutConstraintAxisHorizontal];
    [label setContentCompressionResistancePriority:UILayoutPriorityDefaultLow
                                           forAxis:UILayoutConstraintAxisHorizontal];
    
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    self.titleLabel.highlighted = selected;
    self.indicator.highlighted = selected;
    self.backgroundColor = selected ? menuSelectedColor : [UIColor whiteColor];
}

@end


@interface DropDownMenuTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *cellTextLabel;

@end

@implementation DropDownMenuTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.separatorInset = UIEdgeInsetsZero;
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *selectedBackgroundView = [[UIView alloc]initWithFrame:self.bounds];
    selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    self.selectedBackgroundView = selectedBackgroundView;
    
    _cellTextLabel = [UILabel new];
    _cellTextLabel.textColor = menuTitleColor;
    _cellTextLabel.highlightedTextColor = menuTitleSelectedColor;
    _cellTextLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:_cellTextLabel];
    [_cellTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@-10);
        make.centerY.equalTo(self.contentView);
    }];
    
    UIImageView *divider = [UIImageView new];
    divider.image = [UIImage imageWithColor:seperatorColor];
    [self.contentView addSubview:divider];
    [divider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(@0);
    }];
    
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.selectedBackgroundView.frame = self.contentView.bounds;
}


@end

@implementation DMIndexPath

- (NSUInteger)section
{
    return 0;
}

- (NSInteger)leftRow
{
    return self.row;
}

- (NSIndexPath *)indexPath
{
    if(self.row < 0) {
        return nil;
    }
    return [NSIndexPath indexPathForRow:self.row inSection:self.section];
}


- (NSIndexPath *)rightIndexPath
{
    if(self.rightRow < 0 || !self.haveRightRow) {
        return nil;
    }
    return [NSIndexPath indexPathForRow:self.rightRow inSection:self.section];
}

+ (instancetype)indexPathWithColumn:(NSUInteger)column row:(NSInteger)row
{
    DMIndexPath *indexPath = [[self alloc]init];
    indexPath.column = column;
    indexPath.row = row;
    return indexPath;
}

+ (instancetype)indexPathWithColumn:(NSUInteger)column haveRightRow:(BOOL)haveRightRow
{
    DMIndexPath *indexPath = [[self alloc]init];
    indexPath.column = column;
    indexPath.haveRightRow = haveRightRow;
    if(haveRightRow) {
        indexPath.row = 0;
    }
    return indexPath;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.haveRightRow = NO;
        self.row = -1;
        self.rightRow = -1;
    }
    return self;
}

@end

@interface DropDownMenu()

@property (nonatomic, strong) NSMutableArray <DropDownMenuItem *>*menuItems;

@property (nonatomic, strong) UITableView *leftTableView;

@property (nonatomic, strong) UITableView *rightTableView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, weak) DropDownMenuItem *selectedItem;

@property (nonatomic, strong) NSMutableArray <DMIndexPath *>*indexPaths;;

@end

@implementation DropDownMenu

- (instancetype)initWithOrigin:(CGPoint)origin
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self = [self initWithFrame:CGRectMake(origin.x, origin.y, screenWidth, 40)];
    if(self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self setup];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithOrigin:CGPointZero];
}

- (void)setup
{
    self.backgroundColor = [UIColor whiteColor];
    CGSize screenSize =  [UIScreen mainScreen].bounds.size;
    UIColor *separatorColor = [UIColor colorWithRed:220.f / 255.0f green:220.f / 255.0f blue:220.f / 255.0f alpha:1.0];
    
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.yh_x, self.yh_bottom, 0, 0) style:UITableViewStylePlain];
    _leftTableView.backgroundColor = RGB(242, 242, 242);
    _leftTableView.separatorColor = separatorColor;
    _leftTableView.allowsMultipleSelection = NO;
    _leftTableView.rowHeight = 44.0f;
    _leftTableView.dataSource = self;
    _leftTableView.delegate = self;
    _leftTableView.separatorStyle = 0;
    
    _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.yh_x, self.yh_bottom, 0, 0) style:UITableViewStylePlain];
    _rightTableView.allowsMultipleSelection = NO;
    _rightTableView.backgroundColor = RGB(242, 242, 242);
    _rightTableView.separatorColor = separatorColor;
    _rightTableView.rowHeight = 44.0f;
    _rightTableView.dataSource = self;
    _rightTableView.delegate = self;
    _rightTableView.separatorStyle = 0;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.yh_x, self.yh_bottom, 0, 0) collectionViewLayout:flowLayout];
    
    //[_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    _collectionView.backgroundColor = separatorColor;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    self.autoresizesSubviews = NO;
    _leftTableView.autoresizesSubviews = NO;
    _rightTableView.autoresizesSubviews = NO;
    _collectionView.autoresizesSubviews = NO;
    
    _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(self.yh_x, self.yh_bottom, screenSize.width, screenSize.height)];
    _backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    _backgroundView.opaque = NO;
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
    [_backgroundView addGestureRecognizer:gesture];
    
}

- (void)setDataSource:(id<DropDownMenuDataSource>)dataSource
{
    _dataSource = dataSource;
    
    NSUInteger cloumn = 0;
    if(dataSource && [dataSource respondsToSelector:@selector(numberOfColumnsInMenu:)]) {
        cloumn = [self.dataSource numberOfColumnsInMenu:self];
    }
    
    [_menuItems enumerateObjectsUsingBlock:^(DropDownMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    _menuItems = [NSMutableArray arrayWithCapacity:cloumn];
    
    self.indexPaths = [NSMutableArray arrayWithCapacity:cloumn];
    
    CGFloat itemW = self.frame.size.width/cloumn;

    for (int i = 0; i < cloumn; i++) {
        
        DropDownMenuItem *item = [[DropDownMenuItem alloc]initWithFrame:CGRectMake(itemW * i, 0, itemW, self.frame.size.height)];
        item.index = i;
        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTapped:)];
        [item addGestureRecognizer:tapGesture];
        [self addSubview:item];
        [_menuItems addObject:item];

        BOOL haveRightRow = NO;
        if ([self.dataSource respondsToSelector:@selector(haveRightTableAtColumn:)]) {
            haveRightRow = [self.dataSource haveRightTableAtColumn:i];
        }
        DMIndexPath *indexPath = [DMIndexPath indexPathWithColumn:i haveRightRow:haveRightRow];
        [_indexPaths addObject:indexPath];
        
        if (i != cloumn - 1 ) {
            CGPoint separatorPosition = CGPointMake(itemW * (i + 1) , self.yh_height / 2);
            CAShapeLayer *separator = [self createSeparatorLineWithColor:seperatorColor andPosition:separatorPosition];
            [self.layer addSublayer:separator];
        }
    }
    
    CALayer *bottomLine = [self createBottomLineWithColor:seperatorColor];
    [self.layer addSublayer:bottomLine];
}


- (CALayer *)createBottomLineWithColor:(UIColor *)color
{
    CALayer *layer = [CALayer layer];
    layer.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - 0.5);
    layer.bounds = CGRectMake(0, 0, self.frame.size.width, 0.5);
    layer.backgroundColor = color.CGColor;
    return layer;
}

- (UIView *)createSeparatorWithColor:(UIColor *)color andOrigin:(CGPoint)origin
{
    UIView *separator = [UIView new];
    separator.backgroundColor = color;
    separator.frame = CGRectMake(0, 0, 1.0f, self.yh_height / 2);
    separator.yh_origin = origin;
    return separator;
}

- (CAShapeLayer *)createSeparatorLineWithColor:(UIColor *)color andPosition:(CGPoint)point
{
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(160, self.frame.size.height / 2)];
    [path addLineToPoint:CGPointMake(160, self.frame.size.height)];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.strokeColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    CGPathRelease(bound);
    layer.position = point;
    return layer;
}

- (void)menuTapped:(UITapGestureRecognizer *)recognizer
{
    if(recognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    DropDownMenuItem *item  =  (DropDownMenuItem *)recognizer.view;
    if ([_delegate respondsToSelector:@selector(menu:willTapColumn:)]) {
        BOOL canSelect =  [self.delegate menu:self willTapColumn:item.tag];
        if(!canSelect) {
            return;
        }
    }
    
    DropDownMenuItem *preItem = self.selectedItem;
    
    item.selected = !item.selected;
    if(![preItem isEqual:item]) {
        preItem.selected = NO;
    }
    self.selectedItem = item;
    
    BOOL isShow = item.selected;
    
    if (![preItem isEqual:item] && preItem != nil) {
        
        BOOL hasRightTableView = NO;
        CGFloat ratio = 1.0;
        
        if ([self.dataSource respondsToSelector:@selector(haveRightTableAtColumn:)]) {
            hasRightTableView = [self.dataSource haveRightTableAtColumn:preItem.index];
        }
        
        if ([self.dataSource respondsToSelector:@selector(widthRatioOfLeftColumn:)]) {
            ratio = [_dataSource widthRatioOfLeftColumn:preItem.index];
        }
        self.leftTableView.yh_size = CGSizeMake(self.yh_width * ratio, 0);
        if (hasRightTableView) {
            self.rightTableView.yh_size = CGSizeMake((self.yh_width * 1-ratio), 0);
        }
    }
    
    [self showBackgroundView:isShow completion:^{
        [self showTableView:isShow completion:nil];
    }];

}

- (void)showBackgroundView:(BOOL)show completion:(void (^)())completion
{
    if (show) {
        [self.superview addSubview:self.backgroundView];
        [self.backgroundView.superview addSubview:self];
        
        [UIView animateWithDuration:animationDuration animations:^{
            self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
            
        }];
    } else {
        [UIView animateWithDuration:animationDuration animations:^{
            self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        }completion:^(BOOL finished) {
            [self.backgroundView removeFromSuperview];
        }];
    }
    
    if(completion) {
     completion();
    }
}

- (void)showTableView:(BOOL)show completion:(void (^)())completion
{
    BOOL hasRightTableView = NO;
    CGFloat ratio = 1.0;
    
    if ([self.dataSource respondsToSelector:@selector(widthRatioOfLeftColumn:)]) {
        ratio = [_dataSource widthRatioOfLeftColumn:self.selectedItem.index];
    }
    
    if ([self.dataSource respondsToSelector:@selector(haveRightTableAtColumn:)]) {
        hasRightTableView = [self.dataSource haveRightTableAtColumn:self.selectedItem.index];
    }
    
    if (!show) {
        [self.leftTableView deselectRowAtIndexPath:[self.leftTableView indexPathForSelectedRow] animated:NO];
        [self.rightTableView deselectRowAtIndexPath:[self.rightTableView indexPathForSelectedRow] animated:NO];
        
        [UIView animateWithDuration:animationDuration animations:^{
            self.leftTableView.yh_size = CGSizeMake(self.yh_width * ratio, 0);
            self.rightTableView.yh_size = CGSizeMake((self.yh_width * 1-ratio), 0);
        }completion:^(BOOL finished) {
            [self.leftTableView removeFromSuperview];
            [self.rightTableView removeFromSuperview];
        }];
    }else {
        
        CGFloat suitTableViewH = 0;
        
        self.leftTableView.yh_width = self.yh_width * ratio;
        [self.superview addSubview:_leftTableView];
        [self.leftTableView reloadData];
        [self.leftTableView selectRowAtIndexPath:[self.indexPaths[self.selectedItem.index] indexPath] animated:NO scrollPosition:0];
        
        CGFloat leftTableViewH = MIN([_leftTableView numberOfRowsInSection:0], 10.5) * _leftTableView.rowHeight;
        CGFloat possibleTableViewH = floor((self.superview.yh_height - CGRectGetMaxY(self.frame)) / _leftTableView.rowHeight) * _leftTableView.rowHeight - _leftTableView.rowHeight * 1.5;
        suitTableViewH = MIN(leftTableViewH, possibleTableViewH);
        
        if (hasRightTableView) {
          self.rightTableView.yh_width = self.frame.size.width * (1-ratio);
          self.rightTableView.yh_x = self.leftTableView.yh_width;
          [self.superview addSubview:_rightTableView];
          [self.rightTableView reloadData];
          [self.rightTableView selectRowAtIndexPath:[self.indexPaths[self.selectedItem.index] rightIndexPath] animated:NO scrollPosition:0];
          CGFloat rightTableViewH = MIN([_rightTableView numberOfRowsInSection:0], 10.5) * _rightTableView.rowHeight;
          CGFloat possibleTableViewH = floor((self.superview.yh_height - CGRectGetMaxY(self.frame)) / _rightTableView.rowHeight) * _rightTableView.rowHeight - _rightTableView.rowHeight * 1.5;
          suitTableViewH =  MAX(suitTableViewH, MIN(rightTableViewH, possibleTableViewH));
        }
        
        [UIView animateWithDuration:animationDuration animations:^{
           self.leftTableView.yh_height = suitTableViewH;
            if (hasRightTableView) {
               self.rightTableView.yh_height = suitTableViewH;
            }
        }];
    }
    if(completion) {
      completion();   
    }
}

#pragma tableViewSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count = 0;
    if([self.dataSource respondsToSelector:@selector(numberOfRowsInColumn:rightOrLeft:)]) {
        count = [self.dataSource numberOfRowsInColumn:self.selectedItem.index rightOrLeft:(tableView == self.rightTableView)];
    }
    return count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"DropDownMenuTableViewCell";
    DropDownMenuTableViewCell *cell = [[DropDownMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    BOOL isRightTable = (tableView == self.rightTableView);
    NSString *title = @"";
    if([self.dataSource respondsToSelector:@selector(titleForRowInColumn:rightOrLeft:row:)]) {
        title = [self.dataSource titleForRowInColumn:self.selectedItem.index rightOrLeft:isRightTable row:indexPath.row];
    }
    cell.cellTextLabel.text = title;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DMIndexPath *myIndexPath = self.indexPaths[self.selectedItem.index];
    
    if(myIndexPath.haveRightRow == YES && tableView == self.leftTableView) {
         cell.backgroundColor = menuSelectedColor;
    }else {
        cell.backgroundColor = [UIColor whiteColor];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DMIndexPath *myIndexPath = self.indexPaths[self.selectedItem.index];
    BOOL isRightTable = (tableView == self.rightTableView);
    NSString *title = @"";
    if([self.dataSource respondsToSelector:@selector(titleForRowInColumn:rightOrLeft:row:)]) {
        title = [self.dataSource titleForRowInColumn:self.selectedItem.index rightOrLeft:isRightTable row:indexPath.row];
    }
    
    if(myIndexPath.haveRightRow == YES && tableView == self.rightTableView) {
        myIndexPath.rightRow = indexPath.row;
        [self backgroundTapped:nil];
        [self updateTitle:title atMenuColumn:myIndexPath.column];
    }else if (myIndexPath.haveRightRow == YES) {
        myIndexPath.row = indexPath.row;
        myIndexPath.rightRow = -1;
        [self.rightTableView  reloadData];
        [self.rightTableView setContentOffset:CGPointZero animated:NO];
    }else {
        myIndexPath.row = indexPath.row;
        [self backgroundTapped:nil];
        [self updateTitle:title atMenuColumn:myIndexPath.column];
    }
    if([self.delegate respondsToSelector:@selector(menu:didSelectRowAtIndexPath:rightOrLeft:)]) {
        [self.delegate menu:self didSelectRowAtIndexPath:myIndexPath rightOrLeft:tableView == self.rightTableView];
    }
}

- (void)backgroundTapped:(UITapGestureRecognizer *)sender
{
    self.selectedItem.selected = NO;
    self.selectedItem = nil;
    [self showBackgroundView:NO completion:^{
        [self showTableView:NO completion:nil];
    }];
}

- (void)hideBackgroundView
{
    self.selectedItem.selected = NO;
    self.selectedItem = nil;
    [self showBackgroundView:NO completion:^{
        [self showTableView:NO completion:nil];
    }];
}

- (void)updateTitle:(NSString *)title atMenuColumn:(NSUInteger)column
{
    if(self.menuItems.count <= column) {
        return;
    }
    DropDownMenuItem *item = self.menuItems[column];
    item.titleLabel.text = title;
}

@end
