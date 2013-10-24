//
//  ANCollectionViewCellDelegate.h
//  Crypto
//
//  Created by Andriy Zhuk on 17.10.13.
//  Copyright (c) 2013 Andriy Zhuk. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ANCollectionViewCell;

@protocol ANCollectionViewCellDelegate <NSObject>
@required
- (void)collectionViewCell:(ANCollectionViewCell *)cell didChangeText:(NSString *)text;
@end
