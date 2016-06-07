//
//  NTJImageResizer.m
//  NTJDominantColours
//
//  Created by joshua may on 7/06/2016.
//  Copyright © 2016 joshua may. All rights reserved.
//

#import "NTJImageResizer.h"

@implementation NTJImageResizer

#pragma mark - API

- (NSImage *)resize:(NSImage *)image toFitSize:(NSSize)size {
    if (image.isValid){
        NSImage *dest = [[NSImage alloc] initWithSize:size];

        [dest lockFocus];

        image.size = size;

        [NSGraphicsContext currentContext].imageInterpolation = NSImageInterpolationHigh;
        [image drawAtPoint:NSZeroPoint fromRect:NSMakeRect(0.f, 0.f, size.width, size.height) operation:NSCompositeCopy fraction:1.f];

        [dest unlockFocus];

        return dest;
    }

    return nil;
}

@end
