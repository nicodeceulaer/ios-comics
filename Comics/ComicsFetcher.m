//
//  ComicsFetcher.m
//  Comics
//
//  Created by Sergio Haro on 5/2/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import "ComicsFetcher.h"

@implementation ComicsFetcher

+ (NSDictionary *)executeFetch:(NSString *)query
{
    query = [NSString stringWithFormat:@"http://hungrybear-comics.appspot.com%@", query];
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // NSLog(@"[%@ %@] sent %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), query);
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error] : nil;
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    // NSLog(@"[%@ %@] received %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), results);
    return results;
}

+ (NSArray *)comics
{
    NSString *request = [NSString stringWithFormat:@"/comics/options/"];
    return [[self executeFetch:request] valueForKey:@"comics"];
}

+ (NSDictionary *)entryForComic:(NSDictionary *)comic forEpisode:(NSUInteger)index
{
    NSUInteger comicID = [[comic valueForKey:@"id"] unsignedIntValue];
    NSString *request = [NSString stringWithFormat:@"/comics/%d/%d/", comicID, index];
    return [[self executeFetch:request] valueForKey:@"entry"];
}

+ (NSString *)stringFromType: (NSInteger)type
{
    switch (type)
    {
        case 2:
            return @"Yahoo";
        case 3:
            return @"Comics.com";
        case 5:
            return @"Arcamax";
        default:
            return @"Misc";
    }
}
@end
