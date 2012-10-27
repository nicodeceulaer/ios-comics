//
//  ComicsTableViewCell.m
//  Comics
//
//  Created by Sergio Haro on 5/3/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import "ComicViewController.h"
#import "ImageScrollView.h"
#import "ComicsFetcher.h"

@interface ComicViewController ()
@property (nonatomic, strong) ImageScrollView *scrollView;
@property (nonatomic, strong) UIImage *image;
@end

@implementation ComicViewController

@synthesize scrollView = _scrollView;
@synthesize index = _index;
@synthesize comic = _comic;
@synthesize image = _image;

- (void)startAsyncActivity
{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithCustomView:indicator];
    self.navigationItem.rightBarButtonItem = button;
    [indicator startAnimating];
}

- (void)stopAsyncActivity
{
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)fetchPhoto
{
    [self startAsyncActivity];
    dispatch_queue_t queue = dispatch_queue_create("photo downloader", NULL);
    dispatch_async(queue, ^{
        NSDictionary *currentEntry = [ComicsFetcher entryForComic:self.comic forEpisode:self.index];
        NSURL* url = [NSURL URLWithString:[currentEntry valueForKey:@"img_url"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = img;
            [self stopAsyncActivity];
        });
    });
    dispatch_release(queue);    
}

- (void)setComic:(NSDictionary *)comic
{
    _comic = comic;
    self.title = [_comic valueForKey:@"name"];
    [self fetchPhoto];
} 

- (void)setImage:(UIImage *)image
{
    if (_image != image) {
        _image = image;
        [self reframeImage];
        [self.view setNeedsDisplay];
    }
}

- (void)reframeImage
{
    [self.scrollView displayImage:self.image];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView = [[ImageScrollView alloc] init];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view = self.scrollView;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.image) {
        [self reframeImage];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setImage:nil];
    [super viewDidUnload];
}

@end
