//
//  UIPlaceHolderTextView.h
//  UrUn
//
//  Created by Paulo Mogollon on 2/4/14.
//  Copyright (c) 2014 Indesign Colombia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
