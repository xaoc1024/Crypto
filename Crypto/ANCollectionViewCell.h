//
//  ANCollectionViewCell.h
//  Crypto
//
//  Created by Andriy Zhuk on 11.10.13.
//  Copyright (c) 2013 Andriy Zhuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANCollectionViewCellDelegate.h"
@interface ANCollectionViewCell : UICollectionViewCell <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITextField * infoTextField;

@property (nonatomic, assign) NSInteger indexI;
@property (nonatomic, assign) NSInteger indexJ;

@property(nonatomic, weak) id <ANCollectionViewCellDelegate> delegate;

@end
