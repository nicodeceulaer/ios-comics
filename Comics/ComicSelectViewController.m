//
//  ComicSelectViewController.m
//  Comics
//
//  Created by Sergio Haro on 5/2/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import "ComicSelectViewController.h"
#import "ComicsFetcher.h"

@interface ComicSelectViewController ()

@property (nonatomic, strong) NSArray *comicsBySource;
@end

@implementation ComicSelectViewController

@synthesize comicsBySource = _comicsBySource;

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
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
