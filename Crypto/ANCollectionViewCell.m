//
//  ANCollectionViewCell.m
//  Crypto
//
//  Created by Andriy Zhuk on 11.10.13.
//  Copyright (c) 2013 Andriy Zhuk. All rights reserved.
//

#import "ANCollectionViewCell.h"

@implementation ANCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    self.infoTextField.inputView = dummyView;
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField.text.length < 1){
        return YES;
    }

    [self.delegate collectionViewCell:self didChangeText:textField.text];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
