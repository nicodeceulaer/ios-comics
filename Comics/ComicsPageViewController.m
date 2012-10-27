//
//  ComicsPageViewController.m
//  Comics
//
//  Created by Sergio Haro on 9/25/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import "ComicsPageViewController.h"
#import "ComicViewController.h"

@interface ComicsPageViewController ()
@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic) NSUInteger maxIndex;
@end

@implementation ComicsPageViewController

@synthesize comic = _comic;
@synthesize currentIndex, maxIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (ComicViewController*)comicControllerForComic:(NSDictionary*)comic atIndex:(NSUInteger)i
{
    ComicViewController *controller = [[ComicViewController alloc] init];
    controller.index = i;
    controller.comic = comic;
    return controller;
}

- (void)setComic:(NSDictionary *)comic
{
    _comic = comic;
    self.maxIndex = [[comic valueForKey:@"num_entries"] unsignedIntValue];
    self.currentIndex = self.maxIndex;
    ComicViewController *pageZero = [self comicControllerForComic:comic atIndex:self.maxIndex];
    
    [self setViewControllers:@[pageZero]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO
                  completion:NULL];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerBeforeViewController:(ComicViewController *)vc
{
    NSUInteger index = vc.index;
    if (index  <= 0) {
        return NULL;
    }
    
    return [self comicControllerForComic:vc.comic atIndex:index-1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerAfterViewController:(ComicViewController *)vc
{
    NSUInteger index = vc.index;
    if (index >= self.maxIndex) {
        return NULL;
    }
    
    return [self comicControllerForComic:vc.comic atIndex:index+1];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.maxIndex;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return self.currentIndex;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
