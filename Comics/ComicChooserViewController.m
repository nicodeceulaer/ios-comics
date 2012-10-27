//
//  ComicSelectViewController.m
//  Comics
//
//  Created by Sergio Haro on 5/2/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import "ComicChooserViewController.h"
#import "ComicsFetcher.h"

@interface ComicChooserViewController ()

@property (nonatomic, strong) NSArray *comicsBySource;
@property (nonatomic, strong) NSMutableArray *choosenComics;
@end

@implementation ComicChooserViewController

@synthesize comicsBySource = _comicsBySource;
@synthesize choosenComics = _choosenComics;

- (void)setComics:(NSArray *)comics
{
    self.choosenComics = [comics mutableCopy];
}

- (NSArray *)comics
{
    return [self.choosenComics copy];
}

- (void)setComicsBySource:(NSArray *)comicsBySource
{
    if (_comicsBySource != comicsBySource)
    {
        _comicsBySource = comicsBySource;
        [self.tableView reloadData];
    }
}

- (NSArray *)fetchComics
{
    NSArray *comics = [ComicsFetcher comics];
    
    // allocate comics by source
    NSMutableDictionary *tempStore = [NSMutableDictionary dictionary];
    for (NSDictionary *comic in comics) {
        NSNumber *sourceId = [comic valueForKey:@"source"];
        NSString *source = [ComicsFetcher stringFromType:[sourceId intValue]];
        NSMutableArray *comicsForSource = [tempStore objectForKey:source];
        if (!comicsForSource) {
            comicsForSource = [NSMutableArray array];
            [tempStore setObject:comicsForSource forKey:source];
        }
        [comicsForSource addObject:comic];
    }
    
    // convert dictionary to array
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:[tempStore count]];
    [tempStore enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [sections addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                             key, @"name",
                             obj, @"comics",
                             nil
                             ]];
    }];
    
    return sections;
}

- (NSArray *)comicsForSection:(NSInteger)section
{
    return [[self.comicsBySource objectAtIndex:section] valueForKey:@"comics"];
}

- (NSDictionary *)comicAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self comicsForSection:indexPath.section] objectAtIndex:indexPath.row];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.comicsBySource = [self fetchComics];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.comicsBySource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self comicsForSection:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *source = [[self.comicsBySource objectAtIndex:section] valueForKey:@"name"];
    return source;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Select Comic Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *comic = [self comicAtIndexPath:indexPath];
    cell.textLabel.text = [comic valueForKey:@"name"];
    
    if ([self.choosenComics indexOfObject:comic] != NSNotFound) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *comic = [self comicAtIndexPath:indexPath];
    NSUInteger index = [self.choosenComics indexOfObject:comic];
    if (index == NSNotFound) {
        [self.choosenComics addObject:comic];
         cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        [self.choosenComics removeObjectAtIndex:index];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end
