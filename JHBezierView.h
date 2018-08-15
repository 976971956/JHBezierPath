//
//  bezierView.h
//  bezierPath
//
//  Created by 江湖 on 2018/7/25.
//  Copyright © 2018年 江湖. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RGBA(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define   IPhone5 [UIScreen mainScreen].bounds.size.width == 320 ? YES:NO

#define   IPhone6 [UIScreen mainScreen].bounds.size.width == 375 ? YES:NO

#define   IPhone6P [UIScreen mainScreen].bounds.size.width == 414 ? YES:NO

#define   IPhoneX [UIScreen mainScreen].bounds.size.height == 812.0 ? YES:NO
typedef NS_ENUM(NSInteger, BezierViewType) {
    BezierViewLeftType,//x坐标标注在左边
    BezierViewRightType,//x坐标标注在右边
    BezierViewTopType,//y坐标标注在上边
    BezierViewBottonType,//y坐标标注在下边
};
typedef NS_ENUM(NSInteger, BezierLineType) {
    BrokenLineType,//折线
    CurveLineType,//曲线
    DottedBrokenLineType,//虚折线
    DottedCurveLineType,//虚曲线
};
@interface JHBezierView : UIView
@property(nonatomic,strong)NSMutableArray *pointYArray;//y值波动值
@property(nonatomic,strong)NSMutableArray *pointXArray;//y值波动值
@property(nonatomic,strong)NSMutableArray *pointYArrayAdd;//添加的曲线

//曲线类型
@property(nonatomic,assign) BezierLineType lineType;
//是否需要遮罩 默认有遮罩
@property(nonatomic,assign) BOOL isMask;
//是否显示曲线
@property(nonatomic,assign) BOOL showLine;
//曲线颜色
@property(nonatomic,strong) UIColor *lineColor;
//虚线颜色
@property(nonatomic,strong) UIColor *dottedLineColor;
//设置x、y轴标注颜色
@property(nonatomic,strong) UIColor *shaftColor;

//填充的上面颜色
@property(nonatomic,strong) UIColor *fillTopColor;
//填充的下面颜色
@property(nonatomic,strong) UIColor *fillBottomColor;

//全部价格相等
@property(nonatomic,assign) BOOL isAllEqual;

//=====================================================================================================================

/**
 设置x、y

 @param xmin x最小值
 @param xmax x最大值
 @param ymin y最小值
 @param ymax y最大值
 */
-(void)setxMin:(CGFloat)xmin xMax:(CGFloat)xmax yMin:(CGFloat)ymin yMax:(CGFloat)ymax;
//=====================================================================================================================

/**
  设置x轴标注为日期格式日期

 @param datestr 日期字符串
 @param ymin y最小值
 @param ymax y最大值
 @param day 数值必须为5的整数倍
 @param type 是否为值模式
 */
-(void)setUpTheDate:(NSString *)datestr yMin:(CGFloat)ymin yMax:(CGFloat)ymax showDay:(NSInteger)day numType:(BOOL)type;

//=====================================================================================================================

/**
 日期转换

 @param date 传入时间
 @param index date回倒天数
 @return date回倒天数的时间
 */
-(NSString *)stringToDate:(NSDate *)date index:(NSInteger)index;
@end
@interface JHBezierBgView : UIView
@property (nonatomic,strong)JHBezierView *bezier;
@end
