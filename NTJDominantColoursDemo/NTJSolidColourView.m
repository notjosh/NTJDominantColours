//
//  NTJSolidColourView.m
//  NTJDominantColours
//
//  Created by joshua may on 7/06/2016.
//  Copyright © 2016 joshua may. All rights reserved.
//

#import "NTJSolidColourView.h"

@implementation NTJSolidColourView

- (void)drawRect:(NSRect)dirtyRect {
    if (self.colour) {
        [self.colour setFill];

        NSRectFill(dirtyRect);
    }

    [super drawRect:dirtyRect];
}

#pragma mark - API

- (void)setColour:(NSColor *)colour {
    if ([self.colour isEqual:colour]) {
        return;
    }
    
    _colour = [colour copy];

    [self setNeedsDisplay:YES];
}

@end
