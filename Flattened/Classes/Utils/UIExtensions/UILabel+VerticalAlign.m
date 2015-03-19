//
//  UILabel+VerticalAlign.m
//  Flattened
//
//  Created by Diego Maye on 23/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "UILabel+VerticalAlign.h"

@implementation UILabel (VerticalAlign)
- (void)alignTop
{
    NSDictionary *attributes = @{NSFontAttributeName: self.font};
    CGSize fontSize = [self.text sizeWithAttributes:attributes];
    
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    
    
    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    
    
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    
    for(int i=0; i<= newLinesToPad; i++)
        {
        self.text = [self.text stringByAppendingString:@" \n"];
        }
}

- (void)alignBottom
{
    NSDictionary *attributes = @{NSFontAttributeName: self.font};
    CGSize fontSize = [self.text sizeWithAttributes:attributes];
    
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    
    
    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    
    
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    
    for(int i=0; i< newLinesToPad; i++)
        {
        self.text = [NSString stringWithFormat:@" \n%@",self.text];
        }
}
@end
