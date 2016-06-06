    //
    //  ZCChartlineView.h
    //  BezeirPath
    //
    //  Created by 邬志成 on 16/6/3.
    //  Copyright © 2016年 邬志成. All rights reserved.
    //

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ZCChartlineTypeBroken = 0,//broken line 折线
    ZCChartlineTypeCurve  //曲线
}  ZCChartlineType;



@interface ZCChartlineView : UIScrollView

/*
 *数轴设置
 */
@property (nonatomic,assign) BOOL showCoordinateArrowhead;//设置是否显示数轴箭头

/**
 *  颜色设置
 */
@property (nonatomic,strong,nonnull) NSArray<UIColor *> *lineColors;//设置线条颜色,如果颜色提供的不足,那么多余的线条自动使用最后一个颜色
@property (nonatomic,strong,nonnull) NSArray<UIColor *> *roundColors;//设置圆点的颜色,如果颜色提供的不足,那么多余的圆点自动使用最后一个颜色
@property (nonatomic,strong,nullable) UIColor *showAssistLineColor;//设置显示图表中的辅助横线的颜色


/**
 *  线条绘制设置
 */
@property (nonatomic,strong,nonnull) NSArray <NSString *> *x_title;//设置 x 的轴的标签
@property (nonatomic,strong,nonnull) NSArray <NSArray *> *y_arrayValues;//设置 y 值,可以绘制多条线
@property (nonatomic,assign) CGFloat lineWith;//设置绘制的线宽度

/**
 *  字体设置
 */
@property (nonatomic,strong,nonnull) UIFont *xy_label_font;//设置 x ,y 标题font
@property (nonatomic,strong,nonnull) UIFont *valueLabel_font;//设置显示数值的标签字体

@property (nonatomic,assign) BOOL showValue;//设置是否显示图表中的数值

@property (nonatomic,assign) BOOL showVerticalLine;//设置是否显示图表中的辅助竖线


@property (nonatomic,assign) CGFloat showAssistLineWidth;//设置是否显示图表中的辅助横线的宽度

@property (nonatomic,assign) BOOL showAssistLine;//设置是否显示图表中的辅助竖线

@property (nonatomic,assign) ZCChartlineType lintype;//设置直线的类型(曲线/折线)


/**
 *  绘制折线
 */
-(void)strokeLine;
@end
