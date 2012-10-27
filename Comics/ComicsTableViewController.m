//
//  ComicsViewController.m
//  Comics
//
//  Created by Sergio Haro on 5/2/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import "ComicsTableViewController.h"
#import "ComicsPageViewController.h"
#import "ComicChooserViewController.h"

@interface ComicsTableViewController () <UIPopoverControllerDelegate>
@property (nonatomic, strong) NSArray *comics;
@property (nonatomic, weak) UIPopoverController *popover;
@end

@implementation ComicsTableViewController

@synthesize comics = _comics;
@synthesize popover = _popover;

- (NSArray *)comics
{
    if (!_comics) {
        _comics = [NSArray array];
    }
    return _comics;
}

- (void)setComics:(NSArray *)comics
{
    if (_comics != comics) {
        _comics = comics;
        [self.tableView reloadData];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)chooseComicsPressed:(UIBarButtonItem *)sender {
    if (self.popover) {
        [self.popover dismissPopoverAnimated:YES];
    } else {
        [self performSegueWithIdentifier:@"Choose Comics Segue" sender:sender];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    ComicChooserViewController *controller = (ComicChooserViewController *)popoverController.contentViewController;
    self.comics = controller.comics;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Choose Comics Segue"]) {
        self.popover = [(UIStoryboardPopoverSegue *)segue popoverController];
        self.popover.delegate = self;
        ComicChooserViewController *controller = (ComicChooserViewController *)segue.destinationViewController;
        controller.comics = self.comics;
    }
    else if ([segue.identifier isEqualToString:@"Show Comic Segue"]) {
        ComicsPageViewController *controller = (ComicsPageViewController *)segue.destinationViewController;
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        NSDictionary *detail = [self.comics objectAtIndex:path.row];
        controller.dataSource = controller;
        controller.comic = detail;
    }
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.comics count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Comic Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *comic = [self.comics objectAtIndex:indexPath.row];
    cell.textLabel.text = [comic valueForKey:@"name"];
    return cell;
}

@end
