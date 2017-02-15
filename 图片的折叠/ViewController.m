//
//  ViewController.m
//  图片的折叠
//
//  Created by 张艳楠 on 2017/1/24.
//  Copyright © 2017年 zhang yannan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *topImageView;
@property (strong, nonatomic) IBOutlet UIImageView *bottomImageView;
@property (strong, nonatomic) IBOutlet UIView *dragView;
@property(strong,nonatomic) CAGradientLayer *grandientLayer;
@end

@implementation ViewController
//实现图片折叠必须设置两个控件显示,先转的时候旋转上半部分控件
//如何设置一张完整的图片通过两个控件显示
//通过layer控制显示图片的内容
//如何快速把两个控件拼接成一个完整的图片
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //显示图片的上半部分
    self.topImageView.layer.contentsRect=CGRectMake(0, 0, 1, 0.5);
    self.topImageView.layer.anchorPoint=CGPointMake(0.5, 1);
    self.bottomImageView.layer.contentsRect=CGRectMake(0, 0.5, 1, 0.5);
    self.bottomImageView.layer.anchorPoint=CGPointMake(0.5, 0);
    //在dragView上添加手势
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.dragView addGestureRecognizer:pan];
    
    //创建渐变图层
    CAGradientLayer *grandientLayer=[CAGradientLayer layer];
    //设置渐变图层的尺寸
    grandientLayer.frame=self.bottomImageView.bounds;
    grandientLayer.opacity=0;
    //计算颜色的渐变
    grandientLayer.colors=@[(id)[UIColor clearColor].CGColor,(id)[UIColor blackColor].CGColor];
    self.grandientLayer=grandientLayer;
//    grandientLayer.locations=@[@0.1,@0.4,@0.5];
//    grandientLayer.colors=@[(id)[UIColor redColor].CGColor,(id)[UIColor yellowColor].CGColor,(id)[UIColor greenColor].CGColor];
//    grandientLayer.startPoint=CGPointMake(0, 1);
    [self.bottomImageView.layer addSublayer:grandientLayer];
    
    
}
-(void)pan:(UIPanGestureRecognizer *)pan{
    //获取手势在dragView上的偏移量
    CGPoint transPoint = [pan translationInView:self.dragView];
    //获得旋转的角度
    CGFloat angel=-transPoint.y / 200.0 *M_PI;
    //开始旋转
    CATransform3D transform=CATransform3DMakeRotation(angel, 1, 0, 0);
    //增加立体感
    transform.m34 = -1 / 500.0;
    self.topImageView.layer.transform =transform;
    //计算渐变
    self.grandientLayer.opacity = transPoint.y * 1 / 200;
    if (pan.state == UIGestureRecognizerStateEnded) {
        //SpringWithDamping:弹性系数，越小，弹簧效果越明显
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.topImageView.layer.transform = CATransform3DIdentity;
            self.grandientLayer.opacity=0;
        } completion:^(BOOL finished) {
            
        }];

    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
