    //
    //  ZCChartlineView.m
    //  BezeirPath
    ///Users/wuzhicheng/Desktop/项目/BezeirPath/ZCChart
    //  Created by 邬志成 on 16/6/3.
    //  Copyright © 2016年 邬志成. All rights reserved.
    //

#import "ZCChartlineView.h"

@interface ZCChartlineView ()

@property NSMutableArray<NSMutableArray *> *swithY_value;

@property NSMutableArray<NSNumber*> *swithX_value;

@end


@implementation ZCChartlineView{
    
    
    CGFloat coordinates_offset_x;
    CGFloat coordinates_offset_y;
    CGFloat scaleValue;
    CGFloat x_offset;
    CAShapeLayer *xyLayer;
    CGFloat labelHeight;
    NSInteger y_space;
    NSInteger maxY;
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self load];
    }
    return self;
}


-(instancetype)init{
    self = [super init];
    if (self) {
        [self load];
    }
    return self;
}

-(void)load{
    self.lineWith = 1.5;
    self.showValue = YES;
    self.showVerticalLine = YES;
    self.xy_label_font = [UIFont systemFontOfSize:14];
    self.valueLabel_font = [UIFont systemFontOfSize:11];
    self.strokeColor = [UIColor blueColor];
    _lintype = ZCChartlineTypeBroken;
    xyLayer = [[CAShapeLayer alloc]init];
    _showAssistLineColor = [UIColor redColor];
    _showAssistLineWidth = 1.2f;
    _showAssistLine = YES;
    _showCoordinateArrowhead = YES;
}

-(void)strokeLine{
    if (!(self.x_title&&self.y_arrayValues)) {
        NSLog(@"ERROR:x_title or y_arrayValues is null ");
        return;
    }
    x_offset = [self countXPotintDistance];
    
    labelHeight = [self getLabelWidthWithString:[_x_title firstObject] font:self.xy_label_font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
    maxY = [self getMaxY];
    coordinates_offset_x = [self getLabelWidthWithString:[NSString stringWithFormat:@"%ld",maxY] font:self.xy_label_font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + 10;
    
    coordinates_offset_y = labelHeight * 2.0f;
    self.contentSize = CGSizeMake(x_offset * (self.x_title.count + 1) + coordinates_offset_x, 0);
    y_space = [self getYSpaceWithMaxY:maxY withLabelHeight:labelHeight Yheight:self.frame.size.height - coordinates_offset_y * 2];
    scaleValue = (self.frame.size.height - coordinates_offset_y * 2)/maxY ;
    [self strokeCoordinates];
    [self swichCoordinate];
    [self chartLine];
    
}

-(void)strokeCoordinates{
    
    UIBezierPath *coordinates = [UIBezierPath bezierPath];
    [coordinates moveToPoint:CGPointMake(coordinates_offset_x, coordinates_offset_y - labelHeight)];
    [coordinates addLineToPoint:CGPointMake(coordinates_offset_x,self.frame.size.height - coordinates_offset_y)];
    [coordinates addLineToPoint:CGPointMake(x_offset * (1 + self.x_title.count), self.frame.size.height - coordinates_offset_y)];
    if (self.showCoordinateArrowhead) {
        UIBezierPath *y_jiantou = [UIBezierPath bezierPath];
        [y_jiantou moveToPoint:CGPointMake(coordinates_offset_x - 3, coordinates_offset_y + 6 - labelHeight)];
        [y_jiantou addLineToPoint:CGPointMake(coordinates_offset_x, coordinates_offset_y - labelHeight)];
        [y_jiantou addLineToPoint:CGPointMake(coordinates_offset_x + 3, coordinates_offset_y + 6 - labelHeight)];
        [coordinates appendPath:y_jiantou];
        UIBezierPath *x_jiantou = [UIBezierPath bezierPath];
        [x_jiantou moveToPoint:CGPointMake(x_offset * (1+self.x_title.count) - 6, self.frame.size.height - coordinates_offset_y - 3)];
        [x_jiantou addLineToPoint:CGPointMake(x_offset * (1+self.x_title.count), self.frame.size.height - coordinates_offset_y)];
        [x_jiantou addLineToPoint:CGPointMake(x_offset * (1+self.x_title.count) - 6, self.frame.size.height - coordinates_offset_y + 3)];
        [coordinates appendPath:x_jiantou];
    }
    for (int i = 1; i <= maxY / y_space; i ++) {
        CGPoint point = CGPointMake(coordinates_offset_x + 3,  self.frame.size.height - coordinates_offset_y - y_space * scaleValue * i);
        CGPoint point2 = CGPointMake(coordinates_offset_x,  self.frame.size.height - coordinates_offset_y - y_space * scaleValue * i);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, coordinates_offset_x - 3, labelHeight)];
        label.text = [NSString stringWithFormat:@"%ld",y_space * i];
        label.center = CGPointMake(coordinates_offset_x / 2.0f, self.frame.size.height - coordinates_offset_y - y_space * scaleValue * i);
        label.font = self.xy_label_font;
        label.textAlignment = NSTextAlignmentRight;
        [self addSubview:label];
        UIBezierPath *kedu = [UIBezierPath bezierPath];
        [kedu moveToPoint:point];
        [kedu addLineToPoint:point2];
        [coordinates appendPath:kedu];
    }
    UIBezierPath *x_vLine = [UIBezierPath bezierPath];
    for (int i = 0; i < self.x_title.count; i ++) {
        UILabel *xlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, x_offset, labelHeight)];
        xlabel.text = self.x_title[i];
        xlabel.center = CGPointMake(x_offset * (i + 1) + coordinates_offset_x, self.frame.size.height - coordinates_offset_y / 2.0f);
        xlabel.font = self.xy_label_font;
        xlabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:xlabel];
        if (self.showVerticalLine) {
            [x_vLine moveToPoint:CGPointMake(x_offset * (i + 1) + coordinates_offset_x, coordinates_offset_y)];
            [x_vLine addLineToPoint:CGPointMake(x_offset * (i + 1) + coordinates_offset_x, self.frame.size.height - coordinates_offset_y)];
        }
    }
    if (self.showVerticalLine) {
        CAShapeLayer *x_VLayer = [[CAShapeLayer alloc]init];
        x_VLayer.path = x_vLine.CGPath;
        x_VLayer.fillColor = [UIColor clearColor].CGColor;
        x_VLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        [self.layer addSublayer:x_VLayer];
    }else{
        x_vLine = nil;
    }
    CAShapeLayer *coordinatesLayer = [[CAShapeLayer alloc]init];
    coordinatesLayer.path = coordinates.CGPath;
    coordinatesLayer.lineWidth = 1;
    coordinatesLayer.strokeColor = [UIColor blackColor].CGColor;
    coordinatesLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:coordinatesLayer];
    
}
-(CGFloat)countXPotintDistance{
    CGFloat x_offset_tmp = 38;
    for (NSString *title  in self.x_title) {
        CGSize size = [self getLabelWidthWithString:title font:self.xy_label_font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        x_offset_tmp = MAX(size.width, x_offset_tmp);
    }
    x_offset_tmp += 2;
    return x_offset_tmp;
}

-(void)chartLine{
    
    for (int i = 0  ;i <self.swithY_value.count; i ++) {
        NSArray *arr = self.swithY_value[i];
        UIBezierPath *line = [UIBezierPath bezierPath];
        UIBezierPath *lineFlagPath = [UIBezierPath bezierPath];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGPoint point = CGPointMake([self.swithX_value[idx] floatValue], [obj floatValue]);
            if (idx == 0) {
                [line moveToPoint:point];
            }else{
                if (_lintype == ZCChartlineTypeBroken) {
                    
                    [line addLineToPoint:point];
                    
                }else{
                    CGPoint c1 = CGPointMake([self.swithX_value[idx - 1] floatValue] + x_offset / 2.0f, [arr[idx - 1] floatValue]);
                    CGPoint c2 = CGPointMake([self.swithX_value[idx - 1] floatValue] + x_offset / 2.0f, [obj floatValue]);
                    [line addCurveToPoint:point controlPoint1:c1 controlPoint2:c2];
                }
            }
                //标签数值显示
            if (self.showValue) {
                CGRect frame = CGRectZero;
                frame.size = [self getLabelWidthWithString:[NSString stringWithFormat:@"%@",[[self.y_arrayValues objectAtIndex:i] objectAtIndex:idx]] font:self.valueLabel_font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                UILabel *valueLabel = [[UILabel alloc]initWithFrame:frame];
                valueLabel.text = [NSString stringWithFormat:@"%@",[[self.y_arrayValues objectAtIndex:i] objectAtIndex:idx]];
                valueLabel.font = self.valueLabel_font;
                valueLabel.center = CGPointMake(x_offset * (idx + 1) + coordinates_offset_x, point.y - 10);
                [self addSubview:valueLabel];
            }
            UIBezierPath *tmpPath = [UIBezierPath bezierPath];
            [tmpPath addArcWithCenter:point radius:self.lineWith*1.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
            [lineFlagPath appendPath:tmpPath];
        }];
        CAShapeLayer *layer = [[CAShapeLayer alloc]init];
        CAShapeLayer *lineFlageLayer = [[CAShapeLayer alloc]init];
        lineFlageLayer.path = lineFlagPath.CGPath;
        if (i < self.roundColors.count) {
            lineFlageLayer.fillColor = self.roundColors[i].CGColor;
        }else if(self.roundColors){
            lineFlageLayer.fillColor = [self.roundColors lastObject].CGColor;
        }else{
            lineFlageLayer.fillColor = [UIColor blueColor].CGColor;
        }
        layer.path = line.CGPath;
        layer.lineWidth = self.lineWith;
        layer.lineCap = kCALineCapRound;
        if (i < self.lineColors.count) {
            layer.strokeColor = self.lineColors[i].CGColor;
        }else if(self.lineColors){
            layer.strokeColor = [self.lineColors lastObject].CGColor;
        }else{
            layer.strokeColor = [UIColor blueColor].CGColor;
        }
        layer.fillColor = [UIColor clearColor].CGColor;
        CABasicAnimation *animation = [CABasicAnimation animation];
        animation.fromValue = @0.0;
        animation.byValue = @2.0;
        animation.toValue = @1.0;
        animation.duration = 4;
        [animation setKeyPath:@"strokeEnd"];
        [lineFlageLayer addAnimation:animation forKey:@"animati"];
        [layer addAnimation:animation forKey:@"animation"];
        [self.layer addSublayer:layer];
        [self.layer addSublayer:lineFlageLayer];
    }
}
-(void)swichCoordinate{
    self.swithY_value = [[NSMutableArray alloc]init];
    self.swithX_value = [[NSMutableArray alloc]init];
    for (NSArray *arr in self.y_arrayValues) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat tmp = self.frame.size.height - coordinates_offset_y - [obj floatValue] * scaleValue;
            [array addObject:@(tmp)];
        }];
        [self.swithY_value addObject:array];
    }
    for (int i = 0; i < self.x_title.count; i ++) {
        CGFloat tmp = x_offset * (i + 1) + coordinates_offset_x;
        [self.swithX_value addObject:@(tmp)];
    }
    
}
-(NSInteger)getMaxY{
    __block CGFloat maxValue = 0;
    for (NSArray *arr in self.y_arrayValues) {
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            maxValue = MAX(maxValue, [obj floatValue]);
        }];
    }
    NSInteger yValue = (int)maxValue + 1;
    return yValue;
}
-(NSInteger)getYSpaceWithMaxY:(NSInteger)max withLabelHeight:(CGFloat)height Yheight:(CGFloat)yheight{
    NSInteger num = yheight / height;
    for (int i = 1; ; i ++) {
        if (max <= 1) {
            return 1;
        }
        
        if (max<=10 && max > 1) {
            return 2;
        }
        
        if (max <= 100 && max > 10) {
            if (max/num * 2 < i * 5) {
                return i * 5;
            }
        }
        if (max >100) {
            if (max/num * 2 < i * 10) {
                return i * 10;
            }
        }
    }
    
    return 0;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    NSInteger touchIndex;
    CGFloat x_lenth = point.x;
    x_lenth -= (coordinates_offset_x + x_offset / 2.0f);
    touchIndex = x_lenth / x_offset;
    if (touchIndex < 0) {
        return;
    }
    if (self.showAssistLine) {
        [xyLayer removeFromSuperlayer];
        UIBezierPath *xyLine = [UIBezierPath bezierPath];
        for (NSArray *arr in self.swithY_value) {
            if (touchIndex >= arr.count) {
                return;
            }
            UIBezierPath *xLine = [UIBezierPath bezierPath];
            CGPoint p1 = CGPointMake(coordinates_offset_x, [arr[touchIndex] floatValue]);
            CGPoint p2 = CGPointMake(x_offset * (self.x_title.count + 1), [arr[touchIndex] floatValue]);
            [xLine moveToPoint:p1];
            [xLine addLineToPoint:p2];
            [xyLine appendPath:xLine];
        }
        [xyLine moveToPoint:CGPointMake([self.swithX_value[touchIndex] floatValue], self.frame.size.height - coordinates_offset_y)];
        [xyLine addLineToPoint:CGPointMake([self.swithX_value[touchIndex] floatValue], coordinates_offset_y)];
        xyLayer.path = xyLine.CGPath;
        xyLayer.fillColor = [UIColor clearColor].CGColor;
        xyLayer.strokeColor = self.showAssistLineColor.CGColor;
        xyLayer.lineWidth = self.showAssistLineWidth;
        [self.layer addSublayer:xyLayer];
    }
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    [xyLayer removeFromSuperlayer];
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    [xyLayer removeFromSuperlayer];
}


-(CGSize)getLabelWidthWithString:(NSString*)str font:(UIFont*)font maxSize:(CGSize)maxSize{
    
    return [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}
@end
