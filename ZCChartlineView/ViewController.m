    //
    //  ViewController.m
    //  BezeirPath
    //
    //  Created by 邬志成 on 16/5/23.
    //  Copyright © 2016年 邬志成. All rights reserved.
    //

#import "ViewController.h"
#import "ZCChartlineView.h"

@interface ViewController (){
    
    ZCChartlineView *lineView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    lineView = [[ZCChartlineView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
    lineView.x_title = @[@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"十二月",@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"十二月"];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (int j = 0; j < 2; j ++) {
        NSMutableArray *tmp = [NSMutableArray new];
        for (int i = 0 ; i < lineView.x_title.count; i ++) {
            [tmp addObject:@(arc4random_uniform(100)/10.0f)];
        }
        [array addObject:tmp];
    }
    
    lineView.y_arrayValues = array;
    
        //    lineView.lintype = ZCChartlineTypeCurve; //曲线绘制
    [lineView strokeLine];//画线
    [self.view addSubview:lineView];
    lineView.backgroundColor = [UIColor grayColor];
}



@end
