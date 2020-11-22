//
//  SYPageControl.h
//
//  Created by sy Fu on 2020/11/16.

//

/**
  可自定义图片的自定义 PageControl
*/

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SYPageControlType){
    PageControlMiddle = 0, //
    PageControlRight, //
    PageControlLeft //
};

@interface SYPageControl : UIView

/**
 实现类似系统api
*/
/// default is 0
@property (nonatomic, assign) NSInteger numberOfPages;
/// default is 0. Value is pinned to 0..numberOfPages-1
@property (nonatomic, assign) NSInteger currentPage;
/// hides the indicator if there is only one page, default is NO
@property (nonatomic) BOOL hidesForSinglePage;
/// The tint color for non-selected indicators. Default is nil.
@property (nullable, nonatomic, strong) UIColor *defaultTintColor;
/// The tint color for the currently-selected indicators. Default is nil.
@property (nullable, nonatomic, strong) UIColor *currentTintColor;

/**
 自定义api
*/
/// default is middle
@property (nonatomic, assign) SYPageControlType type;
/// default is 4
@property (nonatomic, assign) CGFloat dotGapWidth;
/// default is (5, 5)
@property (nonatomic, assign) CGSize dotSize;
@property (nullable, nonatomic, strong) UIImage * currentImage; // 高亮图片
@property (nullable, nonatomic, strong) UIImage * defaultImage; // 默认图片
/// default is NO
@property (nonatomic, assign) BOOL isImage; // 是否自定义图片

/// 默认圆点，指定圆点大小和间距，选中和未选中颜色
- (instancetype)initWithFrame:(CGRect)frame
                         type:(SYPageControlType)type
                  dotGapWidth:(CGFloat)dotGapWidth
                      dotSize:(CGSize)dotSize
             defaultTintColor:(UIColor *)color
             currentTintColor:(UIColor *)currentColor;
/// 自定义图片，指定间距，大小为图片大小
- (instancetype)initWithFrame:(CGRect)frame
                         type:(SYPageControlType)type
                  dotGapWidth:(CGFloat)dotGapWidth
                 currentImage:(UIImage *)currentImage
                 defaultImage:(UIImage *)defaultImage;

@end

NS_ASSUME_NONNULL_END
