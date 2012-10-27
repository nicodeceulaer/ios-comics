//
//  ComicsPageViewController.h
//  Comics
//
//  Created by Sergio Haro on 9/25/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComicsPageViewController : UIPageViewController <UIPageViewControllerDataSource>
@property (nonatomic, strong) NSDictionary *comic;
@end
