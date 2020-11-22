//
//  SYPageControl.m
//
//  Created by sy Fu on 2020/11/16.
//

#import "SYPageControl.h"

@implementation SYPageControl

- (instancetype)initWithFrame:(CGRect)frame
                         type:(SYPageControlType)type
                  dotGapWidth:(CGFloat)dotGapWidth
                 currentImage:(UIImage *)currentImage
                 defaultImage:(UIImage *)defaultImage
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentImage = currentImage;
        _defaultImage = defaultImage;
        _numberOfPages = 0;
        _currentPage = 0;
        _type = type;
        _dotSize = currentImage.size;
        _dotGapWidth = dotGapWidth;
        _isImage = YES;
        _hidesForSinglePage = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                         type:(SYPageControlType)type
                  dotGapWidth:(CGFloat)dotGapWidth
                      dotSize:(CGSize)dotSize
             defaultTintColor:(UIColor *)defaultTintColor
             currentTintColor:(UIColor *)currentTintColor
{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        _numberOfPages = 0;
        _currentPage = 0;
        _dotGapWidth = dotGapWidth;
        _dotSize = dotSize;
        _isImage = NO;
        _defaultTintColor = defaultTintColor;
        _currentTintColor = currentTintColor;
        _hidesForSinglePage = YES;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _numberOfPages = 0;
        _currentPage = 0;
        _defaultTintColor = nil;
        _currentTintColor = nil;
        _type = PageControlMiddle;
        _dotSize = CGSizeMake(5, 5);
        _dotGapWidth = 4;
        _isImage = NO;
        _hidesForSinglePage = YES;
    }
    return self;
}

- (void)setDefaultTintColor:(UIColor *)defaultTintColor
{
    if (![self isTheSameColor:defaultTintColor anotherColor:_defaultTintColor]) {
        _defaultTintColor = defaultTintColor;
        [self setupViews];
    }
}

- (void)setCurrentTintColor:(UIColor *)currentTintColor
{
    if (![self isTheSameColor:currentTintColor anotherColor:_currentTintColor]) {
        _currentTintColor = currentTintColor;
        [self setupViews];
    }
}

- (void)setDotSize:(CGSize)dotSize
{
    if (_dotSize.width != dotSize.width || _dotSize.height != dotSize.height) {
        _dotSize = dotSize;
        [self setupViews];
    }
}

- (void)setDotGapWidth:(CGFloat)dotGapWidth
{
    if (_dotGapWidth != dotGapWidth) {
        _dotGapWidth = dotGapWidth;
        [self setupViews];
    }
}

- (void)setCurrentImage:(UIImage *)currentImage
{
    _isImage = YES;
    if (_currentImage != currentImage) {
        _currentImage = currentImage;
        _dotSize = currentImage.size;
        [self setupViews];
    }
}

- (void)setDefaultImage:(UIImage *)defaultImage
{
    _isImage = YES;
    if (_defaultImage != defaultImage) {
        _defaultImage = defaultImage;
        _dotSize = defaultImage.size;
        [self setupViews];
    }
}

- (void)setType:(SYPageControlType)type
{
    if (_type != type) {
        _type = type;
        [self setupViews];
    }
}

- (void)setHidesForSinglePage:(BOOL)hidesForSinglePage
{
    _hidesForSinglePage = hidesForSinglePage;
    [self setupViews];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    if (_currentPage == currentPage) {
        return;
    }
    [self exchangeCurrentView:_currentPage new:currentPage];
    _currentPage = currentPage;
}

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    if (_numberOfPages == numberOfPages) {
        return;
    }
    _numberOfPages = numberOfPages;
    [self setupViews];
}

- (void)clearView
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)setupViews
{
    [self clearView];
    if (_numberOfPages <= 0) return;

    self.hidden = _numberOfPages == 1 && _hidesForSinglePage;

    //居中控件
    CGFloat startX = 0;
    CGFloat startY = 0;
    CGFloat mainWidth = (_numberOfPages - 1) * _dotGapWidth + _numberOfPages * _dotSize.width;

    if (_type == PageControlLeft) {
        startX = 0;
    }else if (_type == PageControlMiddle){
        startX = (self.frame.size.width - mainWidth) / 2.0;
    }else if (_type == PageControlRight){
        startX = self.frame.size.width - mainWidth;
    }

    //动态创建点
    for (int page = 0; page < _numberOfPages; page++) {
        if(page == _currentPage) {
            UIView *curPointView = [[UIView alloc]initWithFrame:CGRectMake(startX, startY, _dotSize.width, _dotSize.height)];
            curPointView.layer.cornerRadius = _dotSize.width / 2;
            curPointView.tag = page + 1000;
            curPointView.backgroundColor = _currentTintColor;
            [self addSubview:curPointView];

            startX = CGRectGetMaxX(curPointView.frame) + _dotGapWidth;

            if (_isImage) {
                curPointView.backgroundColor = [UIColor clearColor];
                UIImageView *curImgView = [[UIImageView alloc] init];
                curImgView.frame = CGRectMake(0, 0, curPointView.frame.size.width, curPointView.frame.size.height);
                curImgView.image = _currentImage;
                [curPointView addSubview: curImgView];
            }
        } else {
            UIView *otherPointView = [[UIView alloc]initWithFrame:CGRectMake(startX, startY, _dotSize.width, _dotSize.height)];
            otherPointView.backgroundColor = _defaultTintColor;
            otherPointView.tag = page + 1000;
            otherPointView.layer.cornerRadius = _dotSize.width / 2.0;

            if (_isImage) {
                otherPointView.backgroundColor = [UIColor clearColor];
                UIImageView *otherImgView = [[UIImageView alloc] init];
                otherImgView.frame = CGRectMake(0, 0, otherPointView.frame.size.width, otherPointView.frame.size.height);
                otherImgView.image = _defaultImage;
                [otherPointView addSubview:otherImgView];
            }

            [self addSubview:otherPointView];
            startX = CGRectGetMaxX(otherPointView.frame) + _dotGapWidth;
        }
    }
}

//切换当前的点
- (void)exchangeCurrentView:(NSInteger)old new:(NSInteger)new {
    UIView *oldSelect = [self viewWithTag: 1000 + old];
    UIView *newSelect = [self viewWithTag: 1000 + new];

    if (_isImage) {
        UIImageView *oldImgview = oldSelect.subviews.firstObject;
        oldImgview.image = _defaultImage;
        UIImageView *newImgView = newSelect.subviews.firstObject;
        newImgView.image = _currentImage;
    } else {
        oldSelect.backgroundColor = _defaultTintColor;
        newSelect.backgroundColor = _currentTintColor;
    }
}

- (BOOL)isTheSameColor:(UIColor*)color1 anotherColor:(UIColor*)color2
{
    return CGColorEqualToColor(color1.CGColor, color2.CGColor);
}

@end
