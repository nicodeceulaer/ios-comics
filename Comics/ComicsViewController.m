//
//  ComicsViewController.m
//  Comics
//
//  Created by Sergio Haro on 5/2/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import "ComicsViewController.h"

@interface ComicsViewController ()

@end

@implementation ComicsViewController

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
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
