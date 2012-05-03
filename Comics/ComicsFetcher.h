//
//  ComicsFetcher.h
//  Comics
//
//  Created by Sergio Haro on 5/2/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComicsFetcher : NSObject

+ (NSArray *)comics;
+ (NSString *)stringFromType: (NSInteger)type;
@end
