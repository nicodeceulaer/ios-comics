//
//  ComicsTableViewCell.h
//  Comics
//
//  Created by Sergio Haro on 5/3/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComicViewController : UIViewController

@property (nonatomic, strong) NSDictionary *comic;
@property (nonatomic) NSUInteger index;
@end
