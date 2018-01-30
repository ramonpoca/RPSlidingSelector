//
//  RPViewController.m
//  RPSlidingSelector
//
//  Created by ramon.poca@gmail.com on 01/30/2018.
//  Copyright (c) 2018 ramon.poca@gmail.com. All rights reserved.
//

#import "RPViewController.h"
#import <RPSlidingSelector/RPSlidingSelector.h>

@interface RPViewController () <RPSlidingSelectorDelegate>
@property (strong, nonatomic) IBOutlet RPSlidingSelector *slidingSelector;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation RPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.slidingSelector.delegate = self;
    self.infoLabel.text = @"";
}

- (void)viewDidAppear:(BOOL)animated {
    [self.slidingSelector selectItemAnimated:2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)slidingSelector:(RPSlidingSelector *)selector didSelectIndex:(NSInteger)index {
    self.infoLabel.text = [NSString stringWithFormat:@"Selected button %ld", index];
}

@end
