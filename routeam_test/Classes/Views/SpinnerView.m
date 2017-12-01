//
//  SpinnerView.m
//  routeam_test
//
//  Created by Maxim Grigoriev on 01/12/2017.
//  Copyright © 2017 Maxim Grigoriev. All rights reserved.
//

#import "SpinnerView.h"

@implementation SpinnerView

+ (SpinnerView *)spinnerViewWithFrame:(CGRect)frame {
    
    return [self spinnerViewWithFrame:frame
                       indicatorStyle:UIActivityIndicatorViewStyleWhiteLarge
                      backgroundColor:[UIColor grayColor]
                                 alfa:0.75];
    
}

+ (SpinnerView *)spinnerViewWithFrame:(CGRect)frame indicatorStyle:(UIActivityIndicatorViewStyle)style backgroundColor:(UIColor *)color alfa:(CGFloat)alfa {
    
    SpinnerView *view = [[SpinnerView alloc] initWithFrame:frame];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.backgroundColor = color;
    view.alpha = alfa;
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    spinner.center = view.center;
    spinner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [spinner startAnimating];
    [view addSubview:spinner];
    
    return view;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
