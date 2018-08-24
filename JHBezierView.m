//
//  bezierView.m
//  bezierPath
//
//  Created by 江湖 on 2018/7/25.
//  Copyright © 2018年 江湖. All rights reserved.
//

#import "JHBezierView.h"

#define X_LINENUM 35//x轴网格数 至少是self.xMarkNum的整数倍 并 是self.xMarkNum的整数倍，不然网格会对不上标注
#define Y_LINENUM 7//y轴网格数 至少是self.yMarkNum的整数倍 并 是self.yMarkNum的整数倍，不然网格会对不上标注
#define X_MARK_NUM 5 //x标注个数
#define Y_MARK_NUM 7 //Y标注个数

#define Clearance_Num 3 //外框间隙
@interface JHBezierView()

@property(nonatomic,assign)CGFloat clearanceNum;//外框间隙

@property(nonatomic,assign)CGFloat xMarkNum;//x标注个数
@property(nonatomic,assign)CGFloat xLineNum;//x轴网格数 至少是self.xMarkNum的整数倍 并 是self.xMarkNum的整数倍，不然网格会对不上标注
@property(nonatomic,assign)CGFloat yMarkNum;//Y标注个数
@property(nonatomic,assign)CGFloat yLineNum;//y轴网格数 至少是self.yMarkNum的整数倍 并 是self.yMarkNum的整数倍，不然网格会对不上标注

@property(nonatomic,assign)CGFloat axisLineWidth;//x、y轴线宽
@property(nonatomic,assign)CGFloat xAxisToViewPadding;//下方x，y轴间距
@property(nonatomic,assign)CGFloat yAxisToViewPadding;//下方x，y轴间距

@property(nonatomic,assign)CGFloat xAxisSpacing;//x轴间距
@property(nonatomic,assign)CGFloat yAxisSpacing;//y轴间距
@property(nonatomic,assign)CGFloat xAxisSpacings;//x轴大间距
@property(nonatomic,assign)CGFloat yAxisSpacings;//y轴大间距
@property(nonatomic,assign)CGFloat viewWeidth;//表格宽度
@property(nonatomic,assign)CGFloat viewHeight;//表格高度
@property(nonatomic,assign)CGFloat fontSize;//字体大小
@property(nonatomic,strong)CAShapeLayer *bezierLineLayer;//画曲线的layer

@property(nonatomic,strong)UIView *bezierVerticalLineView;//画垂线的View
@property(nonatomic,strong)CAShapeLayer *bezierVerticalLineYLayer;//画垂线的layer
@property(nonatomic,strong)CAShapeLayer *bezierVerticalLineXLayer;//画横线的layer

@property(nonatomic,strong)UIView *popView;//popview
@property(nonatomic,strong)UILabel *textLab;//画垂线的Lable
@property(nonatomic,strong)UILabel *textLab1;//画垂线的Lable

@property(nonatomic,strong)UIView *smailRound;//小圆点

@property(nonatomic,strong)NSMutableArray *xAxisInformationArray;//x轴标注
@property(nonatomic,strong)NSMutableArray *yAxisInformationArray;//y轴标注
@property(nonatomic,strong)NSMutableArray *pointsArray;//坐标数组

@property(nonatomic,assign)CGFloat popHeight;//泡泡高度

@property(nonatomic,assign)CGFloat xMin;//X最小值
@property(nonatomic,assign)CGFloat xMax;//x最大值
@property(nonatomic,assign)CGFloat yMin;//y最小值
@property(nonatomic,assign)CGFloat yMax;//y最大值
@property(nonatomic,assign)BezierViewType leftRight;
@property(nonatomic,assign)BezierViewType topBottom;

@property(nonatomic,strong)UIView *bgView;//背景
@property(nonatomic,strong)UIView *bgView1;//背景

@property(nonatomic,strong)UIView *beforeView;//前景

@property(nonatomic,assign)CGFloat yMaxValue;//y最大值

@property(nonatomic,assign)BOOL isasdas;//是否刷新
@property(nonatomic,assign)BOOL numType;//是否为值模式

@end
@implementation JHBezierView

-(void)setxMin:(CGFloat)xmin xMax:(CGFloat)xmax yMin:(CGFloat)ymin yMax:(CGFloat)ymax{
    self.xMin = xmin;
    self.xMax = xmax;
    self.yMin = ymin;
    self.yMax = ymax;
    [self setUpTheDate:nil yMin:self.yMin yMax:self.yMax showDay:30 numType:YES];
}

-(void)upData{
    [self.xAxisInformationArray removeAllObjects];
    [self.yAxisInformationArray removeAllObjects];
    [self.pointXArray removeAllObjects];
    CGFloat xValue = (self.xMax - self.xMin)/self.xMarkNum;
    CGFloat yValue = (self.yMax - self.yMin)/self.yMarkNum;
    for (int i = 0; i < self.xMarkNum; i++) {
        NSString *xNumStr = [NSString stringWithFormat:@"%.0f",self.xMin + xValue*i];
        
        [self.xAxisInformationArray addObject:xNumStr];
        [self.pointXArray addObject:xNumStr];

    }
    for (int i = 0; i < self.yMarkNum; i++) {
        NSString *yNumStr = [NSString stringWithFormat:@"%.2f",self.yMin + yValue*i];
        
        [self.yAxisInformationArray addObject:yNumStr];
    }
}
#pragma mark -  设置x轴标注为日期格式日期
-(void)setUpTheDate:(NSString *)datestr yMin:(CGFloat)ymin yMax:(CGFloat)ymax showDay:(NSInteger)day numType:(BOOL)type{
    self.numType = type;
//    曲线数据
    NSDate *date = [self getPastHafHourTimeDate:datestr Index:0];
    NSInteger count = (day+1)-self.pointYArray.count;
    if (count>0) {
        for (int i =0 ; i < count; i++) {
            [self.pointYArray insertObject:@(self.yMin) atIndex:0];
        }
    }
//    多条曲线数据
    NSMutableArray *pointYArr = [NSMutableArray arrayWithArray:self.pointYArrayAdd];
    [self.pointYArrayAdd removeAllObjects];
    for (NSArray *array in pointYArr) {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:array];
        
        NSInteger count = (day+1)-array.count;
        if (count>0) {
            for (int i =0 ; i < count; i++) {
                [arr insertObject:@(self.yMin) atIndex:0];
            }
        }
        [self.pointYArrayAdd addObject:arr];
    }
    
    datestr = [self stringToDate:date index:day];
    self.xLineNum = day;

    
    self.yMin = ymin;
    self.yMax = ymax;
    self.isasdas = YES;
    if (self.isAllEqual) {
        self.yLineNum = 2;
        self.yMarkNum = 2;
    }
    CGSize informationSize = [self getTextSizeWithText:[NSString stringWithFormat:@"%.2f",ymax] fontSize:self.fontSize maxSize:CGSizeMake(MAXFLOAT, self.fontSize)];
    self.xAxisToViewPadding = 16+informationSize.width;
    if (self.graphicsType == ColumnGraphicsType) {
        self.clearanceNum = (self.viewWeidth / (self.xLineNum+1))/2*1.2;
    }

    self.viewWeidth = CGRectGetWidth(self.frame)-self.xAxisToViewPadding-self.clearanceNum*2;
    self.xAxisSpacing = self.viewWeidth / self.xLineNum;
    self.xAxisSpacings = self.viewWeidth / self.xMarkNum;
    self.yAxisSpacing = self.viewHeight / self.yLineNum;
    self.yAxisSpacings = self.viewHeight / self.yMarkNum;


    CGFloat xNum = 0;
    if (self.leftRight == BezierViewLeftType) {
        xNum = self.xAxisToViewPadding;
    }
    self.bgView1.frame = CGRectMake(self.xAxisToViewPadding, self.bgView.frame.origin.y, self.viewWeidth+self.clearanceNum*2, self.viewHeight+self.clearanceNum*2);
    self.bgView.frame = CGRectMake(self.clearanceNum, self.clearanceNum, self.viewWeidth, self.viewHeight);
    self.beforeView.frame = CGRectMake(self.clearanceNum, self.clearanceNum, self.viewWeidth, self.viewHeight);
    if (self.graphicsType == ColumnGraphicsType) {
        self.bgView1.frame = CGRectMake(self.xAxisToViewPadding, 0, self.viewWeidth+self.clearanceNum*2, self.viewHeight+3*2);
        self.bgView.frame = CGRectMake(self.clearanceNum, 3, self.viewWeidth, self.viewHeight);
        self.beforeView.frame = CGRectMake(self.clearanceNum, 3, self.viewWeidth, self.viewHeight);
    }
    self.beforeView.hidden = NO;
    [self addGrid:self.bgView];
    [self addGrid:self.beforeView];

    [self upData];
//    getPastHafHourTimeDate
    if (type) {
        
    }else{
        [self.xAxisInformationArray removeAllObjects];
        [self.pointXArray removeAllObjects];
        for (int i = 0; i < self.xMarkNum; i++) {
             NSDate *date = [self getPastHafHourTimeDate:datestr Index:i*(self.xLineNum/self.xMarkNum)];
            NSString *xNumStr = [self dateToStringDate:date formatType:@"MMdd"];
            [self.xAxisInformationArray addObject:xNumStr];
        }
        for (int i = 0; i < self.xLineNum+1; i++) {
            NSDate *date = [self getPastHafHourTimeDate:datestr Index:i];
            NSString *xNumStr = [self dateToStringDate:date formatType:@"yyyy.MM.dd"];
            [self.pointXArray addObject:xNumStr];
        }
    }
//    取y最大值
    //    取y最大值
    self.yMaxValue = [self.pointYArray[0] floatValue];
    for (int i = 0; i<self.pointYArray.count; i++) {
        
        if (self.yMaxValue < [self.pointYArray[i] floatValue]) {
            self.yMaxValue = [self.pointYArray[i] floatValue];
        }
    }
    [self setNeedsDisplay];
}
#pragma mark - 数组中获取最大值
-(CGFloat)getNumMax:(NSArray *)array{
    //    取y最大值
    self.yMaxValue = [array[0] floatValue];
    for (int i = 0; i<array.count; i++) {
        
        if (self.yMaxValue < [array[i] floatValue]) {
            self.yMaxValue = [array[i] floatValue];
        }
    }
    return self.yMaxValue;
}
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.clearanceNum = 3;
        self.xLineNum = 10;
        self.yLineNum = 7;
        self.xMarkNum = 5;
        self.yMarkNum = 7;
        self.isMask = YES;
        self.showLine = NO;
        self.lineColor = RGBA(255, 0, 91, 1);
        self.dottedLineColor = [UIColor greenColor];
        self.shaftColor = RGBA(189, 163, 236, 1);
        self.fillTopColor = RGBA(167, 11, 35, 1);
        self.fillBottomColor = RGBA(167, 11, 35, 0.3);
        self.popHeight = 20;
        self.xMin = 611;
        self.xMax = 709;
        self.yMin = 9.0;
        self.yMax = 11.25;
        self.axisLineWidth = 1;
        self.fontSize = 11;
        self.leftRight = BezierViewLeftType;
        self.topBottom = BezierViewBottonType;
        self.graphicsType = CurveGraphicsType;//默认曲线图
        self.xAxisToViewPadding = 45;
        self.yAxisToViewPadding = 40;

        self.viewWeidth = CGRectGetWidth(self.frame)-self.xAxisToViewPadding-self.clearanceNum*2;
        self.viewHeight = CGRectGetHeight(self.frame)-self.yAxisToViewPadding-self.clearanceNum*2;
        
        self.xAxisInformationArray =[NSMutableArray array];
        self.yAxisInformationArray = [NSMutableArray array];
        CGFloat xValue = (self.xMax - self.xMin)/self.xMarkNum;
        CGFloat yValue = (self.yMax - self.yMin)/self.yMarkNum;
        
        for (int i = 0; i < self.xMarkNum; i++) {
            NSString *xNumStr = [NSString stringWithFormat:@"%.1f",self.xMin + xValue*i];

            [self.xAxisInformationArray addObject:xNumStr];

        }
        for (int i = 0; i < self.yMarkNum; i++) {
            NSString *yNumStr = [NSString stringWithFormat:@"%.2f",self.yMin + yValue*i];
            
            [self.yAxisInformationArray addObject:yNumStr];
        }
        self.xAxisSpacing = self.viewWeidth / self.xLineNum;
        self.yAxisSpacing = self.viewHeight / self.yLineNum;
        self.xAxisSpacings = self.viewWeidth / self.xMarkNum;
        self.yAxisSpacings = self.viewHeight / self.yMarkNum;
        
        self.pointYArray = [NSMutableArray arrayWithArray:@[@(9.0), @(9.5), @(9.20), @(10.2), @(9.1), @(9.9), @(11),@(10),@(10.7),@(9),@(10.5),@(9),@(10.5)]];
        self.pointXArray = [NSMutableArray array];

        self.pointsArray = @[].mutableCopy;
        
        CGFloat xNum = 0;
        if (self.leftRight == BezierViewLeftType) {
            xNum = self.xAxisToViewPadding;
        }
        self.bgView1 = [[UIView alloc]initWithFrame:CGRectMake(xNum, 0, self.viewWeidth+self.clearanceNum*2, self.viewHeight+self.clearanceNum*2)];
//        self.bgView1.backgroundColor = [UIColor yellowColor];
        
        [self addSubview:self.bgView1];
        self.bgView = [[UIView alloc]initWithFrame:CGRectMake(self.clearanceNum, self.clearanceNum, self.viewWeidth, self.viewHeight)];
//        self.bgView.backgroundColor = [UIColor grayColor];
        [self.bgView1 addSubview:self.bgView];
//        [self addGrid:self.bgView];
        
        self.beforeView = [[UIView alloc]initWithFrame:CGRectMake(self.clearanceNum, self.clearanceNum, self.viewWeidth, self.viewHeight)];
        self.beforeView.backgroundColor = RGBA(28, 43, 70, 1);
        self.beforeView.layer.masksToBounds = YES;
        [self.bgView1 addSubview:self.beforeView];
        self.beforeView.hidden = YES;
//        [self addGrid:self.beforeView];
        self.bgView1.layer.masksToBounds = YES;

 
    }
    return self;
}
#pragma mark - 添加网格线
- (void)addGrid:(UIView *)view {
    
    CGFloat widthView = view.frame.size.width;
    CGFloat heightView = view.frame.size.height;
    if (self.graphicsType == ColumnGraphicsType) {
        widthView += self.clearanceNum*2-8;
    }
//    CGFloat xsize = (widthView - 0.5)/self.xLineNum;
    CGFloat ysize = (heightView - 0.5)/self.yLineNum;

    void (^addLineWidthRect)(CGRect rect) = ^(CGRect rect) {
        CALayer *layer = [[CALayer alloc] init];
        [view.layer addSublayer:layer];
        layer.frame = rect;
        layer.backgroundColor = RGBA(224, 224, 224, 0.5).CGColor;
    };
    
//    for (CGFloat i=0; i< widthView; i+=xsize) {
//        addLineWidthRect(CGRectMake(i, 0, 1, heightView));
//    }
    for (CGFloat i=0; i<heightView; i+=ysize) {
        if (self.yMarkNum == 2) {
            if (i==0) {
                continue;
            }
        }
        if (self.graphicsType == ColumnGraphicsType) {
            addLineWidthRect(CGRectMake(-self.clearanceNum+4, i, widthView, 0.5));
        }else{
            addLineWidthRect(CGRectMake(0, i, widthView, 0.5));
        }
    }
}

- (void)drawRect:(CGRect)rect {
    if (self.isasdas) {
        [self drawAxisInformation];//画x、y轴的标注
        [self drawBezierPath];//画曲线
    }

}
#pragma mark -画x、y轴的标注
- (void)drawAxisInformation{
    [self.xAxisInformationArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 计算文字尺寸
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        attributes[NSForegroundColorAttributeName] = self.shaftColor;
        //获取字体宽高
        CGSize informationSize = [self getTextSizeWithText:obj fontSize:self.fontSize maxSize:CGSizeMake(MAXFLOAT, self.fontSize)];
        // 计算绘制起点
        CGFloat drawStartPointX =  idx * self.xAxisSpacings;
        if (self.leftRight == BezierViewLeftType) {
            drawStartPointX = self.xAxisToViewPadding + idx * self.xAxisSpacings;
        }
        CGFloat drawStartPointY = self.viewHeight + (self.yAxisToViewPadding - informationSize.height) / 2.0;
        CGPoint drawStartPoint = CGPointMake(drawStartPointX+self.clearanceNum, drawStartPointY);
        // 绘制文字信息
        [obj drawAtPoint:drawStartPoint withAttributes:attributes];
    }];
    
    // y轴
    [self.yAxisInformationArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.yMarkNum == 2) {
            if (idx == 0) {
               
            }else{
                // 计算文字尺寸
                UIFont *informationFont = [UIFont systemFontOfSize:self.fontSize];
                NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
                attributes[NSForegroundColorAttributeName] = self.shaftColor;
                attributes[NSFontAttributeName] = informationFont;
                if (!obj) {
                    obj = @"";
                }
                // 计算绘制起点
                float drawStartPointX = self.viewWeidth + 10;
                
                if (self.leftRight == BezierViewLeftType) {
                    drawStartPointX =  8;
                }
                float drawStartPointY = CGRectGetHeight(self.frame) - self.yAxisToViewPadding - idx * self.yAxisSpacings - self.fontSize;
                
                CGPoint drawStartPoint = CGPointMake(drawStartPointX, drawStartPointY-self.clearanceNum);
                if (self.graphicsType == ColumnGraphicsType) {
                    drawStartPoint = CGPointMake(drawStartPointX, drawStartPointY-3);
                }
                // 绘制文字信息
                [obj drawAtPoint:drawStartPoint withAttributes:attributes];
            }
        }else{
            // 计算文字尺寸
            UIFont *informationFont = [UIFont systemFontOfSize:self.fontSize];
            NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
            attributes[NSForegroundColorAttributeName] = self.shaftColor;
            attributes[NSFontAttributeName] = informationFont;
            if (!obj) {
                obj = @"";
            }
            // 计算绘制起点
            float drawStartPointX = self.viewWeidth + 10;
            
            if (self.leftRight == BezierViewLeftType) {
                drawStartPointX =  8;
            }
            float drawStartPointY = CGRectGetHeight(self.frame) - self.yAxisToViewPadding - idx * self.yAxisSpacings - self.fontSize;
            
            CGPoint drawStartPoint = CGPointMake(drawStartPointX, drawStartPointY-self.clearanceNum);
            if (self.graphicsType == ColumnGraphicsType) {
                drawStartPoint = CGPointMake(drawStartPointX, drawStartPointY-3);
            }
            // 绘制文字信息
            [obj drawAtPoint:drawStartPoint withAttributes:attributes];
        }
    }];
}

#pragma mark - 画曲线
- (void)drawBezierPath{
    if (self.pointYArrayAdd.count>0&&self.pointYArrayAdd) {
        for (NSArray *pointYArray in self.pointYArrayAdd) {
            [self.pointsArray removeAllObjects];
            [pointYArray enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CGFloat objInter = 0;
                if ([obj respondsToSelector:@selector(floatValue)]) {
                    objInter = [obj floatValue];
                }
                CGFloat yNum  = self.yMax - self.yMin;
                
                CGPoint point = [self pointCoordinateTransformation:CGPointMake(self.xAxisSpacing * idx,self.viewHeight*((objInter - self.yMin)/yNum))];
                NSValue *value = [NSValue valueWithCGPoint:CGPointMake(point.x, point.y)];
                [self.pointsArray addObject:value];
            }];
            NSValue *firstPointValue = [NSValue valueWithCGPoint:CGPointMake(0, self.viewHeight)];
            [self.pointsArray insertObject:firstPointValue atIndex:0];
            NSValue *endPointValue = [NSValue valueWithCGPoint:CGPointMake(self.viewWeidth,self.viewHeight)];
            [self.pointsArray addObject:endPointValue];
            UIBezierPath *path = [UIBezierPath bezierPath];
            if (self.graphicsType == ColumnGraphicsType) {
                
                //    柱形图
                for (NSInteger i = 0; i < self.pointsArray.count; i++) {
                    CGPoint p1 = [[self.pointsArray objectAtIndex:i] CGPointValue];
                    CGPoint p2 = CGPointMake(p1.x, self.viewHeight);
                    if (p1.y==p2.y) {
                        p2 = CGPointMake(p1.x, self.viewHeight-1);
                    }
                    [path moveToPoint:p1];
                    [path addLineToPoint:p2];
                }
            }else if (self.graphicsType == CurveGraphicsType){
                /** 曲线路径 */
                for (NSInteger i = 0; i < self.pointsArray.count-3; i++) {
                    CGPoint p1 = [[self.pointsArray objectAtIndex:i] CGPointValue];
                    CGPoint p2 = [[self.pointsArray objectAtIndex:i+1] CGPointValue];
                    CGPoint p3 = [[self.pointsArray objectAtIndex:i+2] CGPointValue];
                    CGPoint p4 = [[self.pointsArray objectAtIndex:i+3] CGPointValue];
                    if (i == 0) {
                        [path moveToPoint:p2];
                    }
                    [self getControlPointx0:p1.x andy0:p1.y x1:p2.x andy1:p2.y x2:p3.x andy2:p3.y x3:p4.x andy3:p4.y path:path];
                }
            }
            /** 将折线添加到折线图层上，并设置相关的属性 */
            CAShapeLayer *bezierLineLayer = [CAShapeLayer layer];
            bezierLineLayer.frame = CGRectMake(0, 0, self.viewWeidth, self.viewHeight);
            if (self.leftRight == BezierViewLeftType) {
                bezierLineLayer.frame = CGRectMake(0, 0, self.viewWeidth, self.viewHeight);
            }
            bezierLineLayer.path = path.CGPath;
            int R = 105+(arc4random() % 150) ;
            int G = 105+(arc4random() % 150) ;
            int B = 105+(arc4random() % 150) ;
            if (self.showLine) {
                //     显示曲线
                bezierLineLayer.strokeColor = RGBA(R, G, B, 1).CGColor;
            }
            
            if(self.lineType == DottedBrokenLineType||self.lineType == DottedCurveLineType){
                //虚线
                bezierLineLayer.lineDashPattern = @[@(5),@(3),@(5),@(3)];
            }
            bezierLineLayer.fillColor = [[UIColor clearColor] CGColor];
            // 默认设置路径宽度为0，使其在起始状态下不显示
            bezierLineLayer.lineWidth = 1;
            bezierLineLayer.lineCap = kCALineCapSquare;
            bezierLineLayer.lineJoin = kCALineJoinBevel;
            bezierLineLayer.masksToBounds = YES;
            if (self.graphicsType == ColumnGraphicsType) {
                CGFloat weight = self.clearanceNum;
                bezierLineLayer.lineWidth = weight;
                bezierLineLayer.lineCap = kCALineCapButt;
                bezierLineLayer.masksToBounds = NO;
            }
            // 颜色渐变CAGradientLayer
            if (self.isMask) {
                UIColor *topGradientColor = RGBA(R, G, B, 1);
                UIColor *bottomGradientColor = RGBA(R, G, B, 1);
                CALayer *layers = [CALayer layer];
                CAGradientLayer *gradientLayer = [self createGradientWithTopColor:topGradientColor bottomColor:bottomGradientColor inView:self.bgView yMaxValue:[self getNumMax:pointYArray] array:pointYArray];
                CAShapeLayer *maskLayer = [self createMaskWithCurve:path withinView:self.bgView];
                gradientLayer.mask = maskLayer;
                [layers addSublayer:gradientLayer];
                layers.mask = maskLayer;
                [self.bgView.layer addSublayer:layers];
            }
            [self.bgView.layer addSublayer:bezierLineLayer];
        }
    }
    [self.pointsArray removeAllObjects];
    [self.pointYArray enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat objInter = 0;
        if ([obj respondsToSelector:@selector(floatValue)]) {
            objInter = [obj floatValue];
        }
        CGFloat yNum  = self.yMax - self.yMin;
 
        CGPoint point = [self pointCoordinateTransformation:CGPointMake(self.xAxisSpacing * idx,self.viewHeight*((objInter - self.yMin)/yNum))];
        NSValue *value = [NSValue valueWithCGPoint:CGPointMake(point.x, point.y)];
        [self.pointsArray addObject:value];
    }];
    NSValue *firstPointValue = [NSValue valueWithCGPoint:CGPointMake(0, self.viewHeight)];
    [self.pointsArray insertObject:firstPointValue atIndex:0];
    NSValue *endPointValue = [NSValue valueWithCGPoint:CGPointMake(self.viewWeidth,self.viewHeight)];
    [self.pointsArray addObject:endPointValue];
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (self.graphicsType == ColumnGraphicsType) {

        //    柱形图
        for (NSInteger i = 0; i < self.pointsArray.count; i++) {
            CGPoint p1 = [[self.pointsArray objectAtIndex:i] CGPointValue];
            CGPoint p2 = CGPointMake(p1.x, self.viewHeight);
            if (p1.y==p2.y) {
                p2 = CGPointMake(p1.x, self.viewHeight-1);
            }
            [path moveToPoint:p1];
            [path addLineToPoint:p2];
        }
    }else if (self.graphicsType == CurveGraphicsType){
        /** 曲线路径 */
        for (NSInteger i = 0; i < self.pointsArray.count-3; i++) {
            CGPoint p1 = [[self.pointsArray objectAtIndex:i] CGPointValue];
            CGPoint p2 = [[self.pointsArray objectAtIndex:i+1] CGPointValue];
            CGPoint p3 = [[self.pointsArray objectAtIndex:i+2] CGPointValue];
            CGPoint p4 = [[self.pointsArray objectAtIndex:i+3] CGPointValue];
            if (i == 0) {
                [path moveToPoint:p2];
            }
            [self getControlPointx0:p1.x andy0:p1.y x1:p2.x andy1:p2.y x2:p3.x andy2:p3.y x3:p4.x andy3:p4.y path:path];
        }
    }
 

    /** 将折线添加到折线图层上，并设置相关的属性 */
    self.bezierLineLayer = [CAShapeLayer layer];
    self.bezierLineLayer.frame = CGRectMake(0, 0, self.viewWeidth, self.viewHeight);
    if (self.leftRight == BezierViewLeftType) {
        self.bezierLineLayer.frame = CGRectMake(0, 0, self.viewWeidth, self.viewHeight);
    }
    self.bezierLineLayer.path = path.CGPath;
    if (self.showLine) {
        //     显示曲线
        self.bezierLineLayer.strokeColor = self.lineColor.CGColor;
    }
    
    if(self.lineType == DottedBrokenLineType||self.lineType == DottedCurveLineType){
        //虚线
        self.bezierLineLayer.lineDashPattern = @[@(5),@(3),@(5),@(3)];
    }
    self.bezierLineLayer.fillColor = [[UIColor clearColor] CGColor];
    // 默认设置路径宽度为0，使其在起始状态下不显示
    self.bezierLineLayer.lineWidth = 1;
    self.bezierLineLayer.lineCap = kCALineCapSquare;
    self.bezierLineLayer.lineJoin = kCALineJoinBevel;
    self.bezierLineLayer.masksToBounds = YES;
    
    if (self.graphicsType == ColumnGraphicsType) {
        CGFloat weight = self.clearanceNum;
        self.bezierLineLayer.lineWidth = weight;
        self.bezierLineLayer.lineCap = kCALineCapButt;
        self.bezierLineLayer.masksToBounds = NO;
    }
    // 颜色渐变CAGradientLayer
    if (self.isMask) {
//        UIColor *topGradientColor = RGBA(87, 240, 187, 1);
//        UIColor *bottomGradientColor = RGBA(55, 147, 170, 0.5);

        UIColor *topGradientColor = self.fillTopColor;
        UIColor *bottomGradientColor = self.fillBottomColor;
        CALayer *layers = [CALayer layer];
        CAGradientLayer *gradientLayer = [self createGradientWithTopColor:topGradientColor bottomColor:bottomGradientColor inView:self.bgView];
        CAShapeLayer *maskLayer = [self createMaskWithCurve:path withinView:self.bgView];
        gradientLayer.mask = maskLayer;
        [layers addSublayer:gradientLayer];
        layers.mask = maskLayer;
        [self.bgView.layer addSublayer:layers];
    }
    [self.bgView.layer addSublayer:self.bezierLineLayer];
//    self.bezierLineLayer.masksToBounds = YES;

    CGFloat xNum = 0;
    [self bringSubviewToFront:self.beforeView];

    if (self.leftRight == BezierViewLeftType) {
        xNum = self.xAxisToViewPadding;
    }

    if (self.graphicsType == ColumnGraphicsType) {
        self.beforeView.hidden = YES;
        return;
    }
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (self.isMask||self.showLine) {
            self.beforeView.frame = CGRectMake(self.viewWeidth+self.clearanceNum, self.clearanceNum, 0, self.viewHeight);
        }

    } completion:^(BOOL finished) {
        self.beforeView.hidden = YES;

    }];
}

//遮罩
- (CAShapeLayer *)createMaskWithCurve:(UIBezierPath *)curve withinView:(UIView *)superview {
    
    CAShapeLayer *mask = [CAShapeLayer new];
//    CGFloat height = self.viewHeight * ((self.yMaxValue - self.yMin)/(self.yMax - self.yMin));

    mask.frame = superview.bounds;
    if (IPhone5) {
        [curve addLineToPoint:CGPointMake((320 - 28), self.viewHeight)];
    } else {
        [curve addLineToPoint:CGPointMake(self.viewWeidth, self.viewHeight)];
    }
    
    [curve addLineToPoint:CGPointMake(0, self.viewHeight)];
    [curve closePath];
    mask.path = curve.CGPath;
    
    return mask;
}

//颜色渐变
- (CAGradientLayer *)createGradientWithTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor inView:(UIView *)superview {
    
    CAGradientLayer *gradientLayer = [CAGradientLayer new];
    NSLog(@"%@",NSStringFromCGRect(superview.bounds));
    CGFloat height = self.viewHeight * ((self.yMaxValue - self.yMin)/(self.yMax - self.yMin))+10;
    if (isnan(height)) {
        height = 0;
    }
    gradientLayer.frame = CGRectMake(0,self.viewHeight-height, (self.pointYArray.count-1)*self.xAxisSpacing, height);
//    gradientLayer.frame = superview.bounds;

    gradientLayer.colors = @[(id)topColor.CGColor,
                             (id)bottomColor.CGColor];
    return gradientLayer;
}
//其他曲线颜色渐变
- (CAGradientLayer *)createGradientWithTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor inView:(UIView *)superview yMaxValue:(CGFloat)yMaxValue array:(NSArray *)array{
    
    CAGradientLayer *gradientLayer = [CAGradientLayer new];
    NSLog(@"%@",NSStringFromCGRect(superview.bounds));
    CGFloat height = self.viewHeight * ((yMaxValue - self.yMin)/(self.yMax - self.yMin))+10;
    
    gradientLayer.frame = CGRectMake(0,self.viewHeight-height, (array.count-1)*self.xAxisSpacing, height);
    //    gradientLayer.frame = superview.bounds;
    
    gradientLayer.colors = @[(id)topColor.CGColor,
                             (id)bottomColor.CGColor];
    return gradientLayer;
}

//坐标系转换
- (CGPoint)pointCoordinateTransformation:(CGPoint)point {
    return CGPointMake(point.x,self.viewHeight - point.y);
}

//画直线（暂时未用）
-(void)drawBezierVerticalLineLayerPoint:(CGPoint)point{
    if (point.x > self.viewWeidth) {
        return;
    }
    if (point.x >(self.pointYArray.count-1)*self.xAxisSpacing) {
        return;
    }
    if (point.y >self.viewHeight) {
        return;
    }
    
    CGFloat w = self.xAxisSpacing/2;
    NSInteger pointx = ((point.x)/w);
    if (pointx%2 == 0) {
    }else{
        pointx +=1;
    }

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(w*pointx, 0)];//起点
    [path addLineToPoint:CGPointMake(w*pointx, self.viewHeight)];
    if (!self.bezierVerticalLineYLayer) {
        self.bezierVerticalLineYLayer = [CAShapeLayer layer];
        self.bezierVerticalLineYLayer.path = path.CGPath;
        self.bezierVerticalLineYLayer.strokeColor = [UIColor greenColor].CGColor;
        self.bezierVerticalLineYLayer.fillColor = [[UIColor clearColor] CGColor];
        // 默认设置路径宽度为0，使其在起始状态下不显示
        self.bezierVerticalLineYLayer.lineWidth = 1;
        self.bezierVerticalLineYLayer.lineCap = kCALineCapRound;
        self.bezierVerticalLineYLayer.lineJoin = kCALineJoinRound;
        [self.bgView.layer addSublayer:self.bezierVerticalLineYLayer];
    }
    //泡泡PopView
    if (!self.popView) {
        self.popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, self.popHeight*2)];
        self.popView.backgroundColor = RGBA(0, 177, 11, 1);
        self.popView.layer.cornerRadius = 4;
        self.popView.layer.masksToBounds = YES;
        [self.bgView addSubview:self.popView];

        self.textLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, self.popView.frame.size.height/2)];
        self.textLab.textColor = [UIColor whiteColor];
        self.textLab.font = [UIFont systemFontOfSize:10 weight:1];
        self.textLab.textAlignment = NSTextAlignmentCenter;
        self.textLab.text = @"0";
        [self.popView addSubview:self.textLab];
        
        self.textLab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, self.popView.frame.size.height/2, 100, self.popView.frame.size.height/2)];
        self.textLab1.textColor = [UIColor whiteColor];
        self.textLab1.font = [UIFont systemFontOfSize:10 weight:1];
        self.textLab1.textAlignment = NSTextAlignmentCenter;
        [self.popView addSubview:self.textLab1];
    }
    
    NSInteger index = 0;
    if (pointx>=2) {
        index = pointx/2;
    }else{
    }
    CGFloat floatValueY = [self.pointYArray[index] floatValue];
    CGFloat xValue =  (self.xMax - self.xMin)/self.xLineNum;

    CGFloat floatValueX = (self.xMin + index * xValue);
    CGPoint apoint = [self pointCoordinateTransformation:CGPointMake(index*self.xAxisSpacing,self.viewHeight*((floatValueY - self.yMin)/(self.yMax - self.yMin)))];
    self.textLab.text = [NSString stringWithFormat:@"值:%.1f",[self.pointYArray[index] floatValue]];
    if (!self.pointXArray||self.pointXArray.count<=0||self.numType) {
        self.textLab1.text = [NSString stringWithFormat:@"X:%.2f",floatValueX];
    }else{
        self.textLab1.text = [NSString stringWithFormat:@"日期:%@",self.pointXArray[index]];
    }
    self.bezierVerticalLineYLayer.path = path.CGPath;
//小圆点
    if (!self.smailRound) {
        self.smailRound = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 6, 6)];
        self.smailRound.layer.cornerRadius = 3;
        self.smailRound.layer.masksToBounds = YES;
        self.smailRound.backgroundColor = RGBA(0, 177, 11, 1);
        [self.bgView addSubview:self.smailRound];
    }
//    CGFloat xNum = 0;
//    if (self.leftRight == BezierViewLeftType) {
//        xNum = self.xAxisToViewPadding;
//    }
    self.smailRound.center = CGPointMake(apoint.x+0, apoint.y);
    self.popView.center = CGPointMake(apoint.x+0, self.popView.frame.size.height/2);
    [self bringSubviewToFront:self.bgView];
}

//画提示点
-(void)drawBezierVerticalPointLayerPoint:(CGPoint)point{
    if (point.x > self.viewWeidth||point.x<0) {
        return;
    }
    if (point.x >(self.pointYArray.count-1)*self.xAxisSpacing) {
        return;
    }
    if (point.y >self.viewHeight||point.y<0) {
        return;
    }
    NSLog(@"%@",NSStringFromCGPoint(point));

    CGFloat w = self.xAxisSpacing/2;
    NSInteger pointx = ((point.x)/w);
    if (pointx%2 == 0) {
    }else{
        pointx +=1;
    }
    
    NSInteger index = 0;
    if (pointx>=2) {
        index = pointx/2;
    }else{
    }
    CGFloat floatValueY = [self.pointYArray[index] floatValue];
    CGFloat xValue =  (self.xMax - self.xMin)/self.xLineNum;
    
    CGFloat floatValueX = (self.xMin + index * xValue);
    CGFloat apointHeigh = self.viewHeight*((floatValueY - self.yMin)/(self.yMax - self.yMin));
    if (isnan(apointHeigh)) {
        apointHeigh = 0;
    }
    CGPoint apoint = [self pointCoordinateTransformation:CGPointMake(index*self.xAxisSpacing,apointHeigh)];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(0, 0)];//起点
//    [path addLineToPoint:CGPointMake(0, self.viewHeight - apoint.y)];
    [path moveToPoint:CGPointMake(0, 0)];//起点
    [path addLineToPoint:CGPointMake(0, self.viewHeight)];
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:CGPointMake(0, 0)];//起点
    [path1 addLineToPoint:CGPointMake(self.viewWeidth, 0)];
//    [path moveToPoint:CGPointMake(w*pointx, apoint.y)];//起点
//    [path addLineToPoint:CGPointMake(w*pointx,self.viewHeight)];
    if (!self.bezierVerticalLineYLayer) {
        self.bezierVerticalLineYLayer = [CAShapeLayer layer];
        self.bezierVerticalLineYLayer.frame = CGRectMake(0, self.viewHeight, 0.5, apoint.y);

        self.bezierVerticalLineYLayer.path = path.CGPath;
//        虚线
        self.bezierVerticalLineYLayer.lineDashPattern = @[@(2),@(5)];

        self.bezierVerticalLineYLayer.strokeColor = self.dottedLineColor.CGColor;
        self.bezierVerticalLineYLayer.fillColor = [[UIColor clearColor] CGColor];
        // 默认设置路径宽度为0，使其在起始状态下不显示
        self.bezierVerticalLineYLayer.lineWidth = 0.5;
        self.bezierVerticalLineYLayer.lineCap = kCALineCapRound;
        self.bezierVerticalLineYLayer.lineJoin = kCALineJoinRound;
        [self.bgView.layer addSublayer:self.bezierVerticalLineYLayer];
    }
    if (!self.bezierVerticalLineXLayer) {
        self.bezierVerticalLineXLayer = [CAShapeLayer layer];
        self.bezierVerticalLineXLayer.frame = CGRectMake(0, self.viewHeight, self.viewWeidth, 0.5);
        self.bezierVerticalLineXLayer.path = path1.CGPath;
        //        虚线
        self.bezierVerticalLineXLayer.lineDashPattern = @[@(5),@(5)];
        
        self.bezierVerticalLineXLayer.strokeColor = self.dottedLineColor.CGColor;
        self.bezierVerticalLineXLayer.fillColor = [[UIColor clearColor] CGColor];
        // 默认设置路径宽度为0，使其在起始状态下不显示
        self.bezierVerticalLineXLayer.lineWidth = 0.5;
        self.bezierVerticalLineXLayer.lineCap = kCALineCapRound;
        self.bezierVerticalLineXLayer.lineJoin = kCALineJoinRound;
        [self.bgView.layer addSublayer:self.bezierVerticalLineXLayer];
    }
    
    //泡泡PopView
    if (!self.popView) {
        self.popView = [[UIView alloc]initWithFrame:CGRectMake(0, self.viewHeight, 100, self.popHeight)];
        self.popView.backgroundColor = RGBA(255, 255, 255, 1);
        self.popView.layer.cornerRadius = 4;
        self.popView.layer.masksToBounds = YES;
        [self.bgView addSubview:self.popView];
        
        self.textLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, self.popHeight)];
        self.textLab.textColor = [UIColor blackColor];
        self.textLab.font = [UIFont systemFontOfSize:10];
        self.textLab.textAlignment = NSTextAlignmentCenter;
        self.textLab.text = @"0";
        [self.popView addSubview:self.textLab];
        self.popView.hidden = YES;
    }
    
//    self.textLab.text = [NSString stringWithFormat:@"值:%.1f",[self.pointYArray[index] floatValue]];
    if (!self.pointXArray||self.pointXArray.count<=0||self.numType) {
        self.textLab.text = [NSString stringWithFormat:@"%.2f元 X:%.2f",[self.pointYArray[index] floatValue],floatValueX];
    }else{
        NSString *textStr = [NSString stringWithFormat:@"%.2f元 %@",[self.pointYArray[index] floatValue],self.pointXArray[index]];
        CGSize size =  [self getTextSizeWithText:textStr fontSize:10 maxSize:CGSizeMake(MAXFLOAT, self.fontSize)];
        self.popView.frame = CGRectMake(self.popView.frame.origin.x, self.popView.frame.origin.y, 14+size.width, self.popHeight);
        self.textLab.frame = CGRectMake(0, 0, 14+size.width, self.popHeight);
        self.textLab.text = textStr;
    }
//    CABasicAnimation *anim = [CABasicAnimation animation];
//    anim.keyPath = @"path";
//    self.bezierVerticalLineLayer.path = path.CGPath;
    //小圆点
    if (!self.smailRound) {
        self.smailRound = [[UIView alloc]initWithFrame:CGRectMake(0, self.viewHeight, 6, 6)];
        self.smailRound.layer.borderColor = [UIColor whiteColor].CGColor;
        self.smailRound.layer.borderWidth = 1;
        self.smailRound.layer.cornerRadius = 2;
        self.smailRound.layer.masksToBounds = YES;
        self.smailRound.backgroundColor = RGBA(0, 177, 11, 1);
        [self.bgView addSubview:self.smailRound];
        self.smailRound.hidden = YES;
    }
    //    CGFloat xNum = 0;
    //    if (self.leftRight == BezierViewLeftType) {
    //        xNum = self.xAxisToViewPadding;
    //    }

    CGFloat xxx = apoint.x+self.popView.frame.size.width+2;
    CGFloat yyy = apoint.y+self.popView.frame.size.height+2;

    if (xxx>self.viewWeidth) {
        xxx = apoint.x-self.popView.frame.size.width/2-2;
    }else{
        xxx = apoint.x+self.popView.frame.size.width/2+2;
    }
    
    if (yyy>self.viewHeight) {
        yyy = apoint.y - self.popHeight/2-2;
    }else{
        yyy = apoint.y + self.popHeight/2+2;
    }
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.smailRound.hidden = NO;
        self.popView.hidden = NO;
        self.bezierVerticalLineYLayer.path = path.CGPath;

//        self.bezierVerticalLineYLayer.frame = CGRectMake(w*pointx, apoint.y, 1,self.viewHeight - apoint.y);
        self.bezierVerticalLineYLayer.frame = CGRectMake(w*pointx, 0, 0.5,self.viewHeight );

        self.bezierVerticalLineXLayer.frame = CGRectMake(0, apoint.y, self.viewWeidth,1);

        self.popView.center = CGPointMake(xxx,yyy);
        self.smailRound.center = CGPointMake(apoint.x+0, apoint.y);
    } completion:^(BOOL finished) {
        
    }];
    [self bringSubviewToFront:self.bgView];
}

- (void)getControlPointx0:(CGFloat)x0 andy0:(CGFloat)y0
                       x1:(CGFloat)x1 andy1:(CGFloat)y1
                       x2:(CGFloat)x2 andy2:(CGFloat)y2
                       x3:(CGFloat)x3 andy3:(CGFloat)y3
                     path:(UIBezierPath*) path{
    CGFloat smooth_value =0.8;
    CGFloat ctrl1_x;
    CGFloat ctrl1_y;
    CGFloat ctrl2_x;
    CGFloat ctrl2_y;
    CGFloat xc1 = (x0 + x1) /2.0;
    CGFloat yc1 = (y0 + y1) /2.0;
    CGFloat xc2 = (x1 + x2) /2.0;
    CGFloat yc2 = (y1 + y2) /2.0;
    CGFloat xc3 = (x2 + x3) /2.0;
    CGFloat yc3 = (y2 + y3) /2.0;
    CGFloat len1 = sqrt((x1-x0) * (x1-x0) + (y1-y0) * (y1-y0));
    CGFloat len2 = sqrt((x2-x1) * (x2-x1) + (y2-y1) * (y2-y1));
    CGFloat len3 = sqrt((x3-x2) * (x3-x2) + (y3-y2) * (y3-y2));
    CGFloat k1 = len1 / (len1 + len2);
    CGFloat k2 = len2 / (len2 + len3);
    CGFloat xm1 = xc1 + (xc2 - xc1) * k1;
    CGFloat ym1 = yc1 + (yc2 - yc1) * k1;
    CGFloat xm2 = xc2 + (xc3 - xc2) * k2;
    CGFloat ym2 = yc2 + (yc3 - yc2) * k2;
    ctrl1_x = xm1 + (xc2 - xm1) * smooth_value + x1 - xm1;
    ctrl1_y = ym1 + (yc2 - ym1) * smooth_value + y1 - ym1;
    ctrl2_x = xm2 + (xc2 - xm2) * smooth_value + x2 - xm2;
    ctrl2_y = ym2 + (yc2 - ym2) * smooth_value + y2 - ym2;
    if (self.lineType == BrokenLineType||self.lineType == DottedBrokenLineType) {
        //折线
            [path addLineToPoint:CGPointMake(x2, y2)];
    }else if (self.lineType == CurveLineType||self.lineType == DottedCurveLineType){
        //曲线
        [path addCurveToPoint:CGPointMake(x2, y2) controlPoint1:CGPointMake(ctrl1_x, ctrl1_y) controlPoint2:CGPointMake(ctrl2_x, ctrl2_y)];
    }
}


- (CGSize)getTextSizeWithText:(NSString *)text fontSize:(CGFloat)fontSize maxSize:(CGSize)maxSize{
    CGSize size = CGSizeZero;
    if(text.length > 0){
        size = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil].size;
    }
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
}
/**
 字符串转换成日期，index是增加时间的倍数
 */
- (NSDate *)getPastHafHourTimeDate:(NSString *)date Index:(NSInteger)index{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
     NSDate *currentDate = [formatter dateFromString:date];
    
    NSDate *pastHalfHour = [currentDate dateByAddingTimeInterval:3600*24*index]; // 半小时前是-1800   1小时后是3600   1小时前是-3600
    
    return pastHalfHour;
    
}

//将日期转换format类型的字符串
- (NSString *)dateToStringDate:(NSDate *)date formatType:(NSString *)format{
    NSDateFormatter *aformatter = [[NSDateFormatter alloc] init];
    [aformatter setDateFormat:format];
    NSString *timeString = [aformatter stringFromDate:date];
    return timeString;
}

-(NSString *)stringToDate:(NSDate *)date index:(NSInteger)index{
    NSString *datestr = [self dateToStringDate:date formatType:@"yyyy-MM-dd"];
    NSDate *date1 =  [self getPastHafHourTimeDate:datestr Index:-index];
    NSString *datestr1 = [self dateToStringDate:date1 formatType:@"yyyy-MM-dd"];
    return datestr1;
}

#pragma mark touch事件
//一根或者多根手指开始触摸view
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if ( self.isasdas) {
        if (self.isMask||self.showLine) {
            UITouch *touch = [touches anyObject];
            CGPoint point = [touch locationInView:self.bgView];
            [self drawBezierVerticalPointLayerPoint:point];
        }
    }
}

//一根或者多根手指在view上移动
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.isasdas) {
        if (self.isMask||self.showLine) {
            UITouch *touch = [touches anyObject];
            CGPoint point = [touch locationInView:self.bgView];
            //    NSLog(@"%@",NSStringFromCGPoint(point));
            [self drawBezierVerticalPointLayerPoint:point];
        }
    }


}
//一根或者多根手指离开view
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.bgView];
    NSLog(@"%@",NSStringFromCGPoint(point));
}
//触摸结束前，某个系统事件(例如电话呼入)会打断触摸过程
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.bgView];
    NSLog(@"%@",NSStringFromCGPoint(point));
}


@end
@interface JHBezierBgView ()
@end

@implementation JHBezierBgView
-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.bezier = [[JHBezierView alloc]initWithFrame:CGRectMake(0, 20, frame.size.width-20, frame.size.height-20)];
        self.bezier.backgroundColor = self.backgroundColor;
        [self addSubview:self.bezier];
    }
    return self;
}
@end
