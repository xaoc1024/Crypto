//
//  ANViewController.h
//  Crypto
//
//  Created by Andriy Zhuk on 11.10.13.
//  Copyright (c) 2013 Andriy Zhuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANCollectionViewCellDelegate.h"

@interface ANViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, ANCollectionViewCellDelegate, UITextFieldDelegate>

@end
