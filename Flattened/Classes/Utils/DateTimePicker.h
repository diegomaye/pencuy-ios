//
//  DateTimePicker.h
//  Flattened
//
//  Created by Diego Maye on 21/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface DateTimePicker : UIView {
}

@property (nonatomic, assign, readonly) UIDatePicker *picker;

- (void) setMode: (UIDatePickerMode) mode;
- (void) addTargetForDoneButton: (id) target action: (SEL) action;
- (void) addTargetForCancelButton: (id) target action: (SEL) action;

@end