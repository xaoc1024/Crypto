//
//  ANCollectionViewController.m
//  Crypto
//
//  Created by Andriy Zhuk on 09.10.13.
//  Copyright (c) 2013 Andriy Zhuk. All rights reserved.
//

#import "ANCollectionViewController.h"
#import "ANCryptoForLatinSquare.h"

@interface ANCollectionViewController ()

@end

@implementation ANCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    ANCryptoForLatinSquare * crypto = [[ANCryptoForLatinSquare alloc] initWithMessagesCount:4 kesCount:12 cryptogramsCount:5 andMode:M_LESS_THAN_E];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
