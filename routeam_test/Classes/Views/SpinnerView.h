//
//  SpinnerView.h
//  routeam_test
//
//  Created by Maxim Grigoriev on 01/12/2017.
//  Copyright © 2017 Maxim Grigoriev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpinnerView : UIView

+ (SpinnerView *)spinnerViewWithFrame:(CGRect)frame;
+ (SpinnerView *)spinnerViewWithFrame:(CGRect)frame indicatorStyle:(UIActivityIndicatorViewStyle)style backgroundColor:(UIColor *)color alfa:(CGFloat)alfa;


@end
