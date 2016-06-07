//
//  NTJColourExtractor.m
//  NTJDominantColours
//
//  Created by joshua may on 7/06/2016.
//  Copyright © 2016 joshua may. All rights reserved.
//

#import "NTJColourExtractor.h"

@interface NSImage (NTJColourExtractorAdditions)

- (NSBitmapImageRep *)ntj_bitmapImageRepresentation;

@end

@implementation NTJColourExtractor

- (NSCountedSet<NSColor *> *)extractFromImage:(NSImage *)image {
    NSCountedSet *set = [NSCountedSet new];

    NSBitmapImageRep *rep = [image ntj_bitmapImageRepresentation];

    NSAssert([rep isKindOfClass:[NSBitmapImageRep class]], @"HEY, I need bitmap to work.");

    for (NSInteger y = 0; y < rep.size.height; y++) {
        for (NSInteger x = 0; x < rep.size.width; x++) {
            NSColor *colour = [rep colorAtX:x y:y];

            [set addObject:colour];
        }
    }

    return set;
}

@end


@implementation NSImage (NTJColourExtractorAdditions)

- (NSBitmapImageRep *)ntj_bitmapImageRepresentation {
    NSBitmapImageRep *rep = (NSBitmapImageRep *)self.representations.firstObject;

    if (![rep isKindOfClass:[NSBitmapImageRep class]]) {
        int width = self.size.width;
        int height = self.size.height;

        if (width < 1 || height < 1) {
            return nil;
        }

        rep = [[NSBitmapImageRep alloc]
               initWithBitmapDataPlanes: NULL
               pixelsWide: width
               pixelsHigh: height
               bitsPerSample: 8
               samplesPerPixel: 4
               hasAlpha: YES
               isPlanar: NO
               colorSpaceName: NSDeviceRGBColorSpace
               bytesPerRow: width * 4
               bitsPerPixel: 32];

        NSGraphicsContext *ctx = [NSGraphicsContext graphicsContextWithBitmapImageRep: rep];
        [NSGraphicsContext saveGraphicsState];
        [NSGraphicsContext setCurrentContext: ctx];
        [self drawAtPoint: NSZeroPoint fromRect: NSZeroRect operation: NSCompositeCopy fraction: 1.0];
        [ctx flushGraphics];
        [NSGraphicsContext restoreGraphicsState];

        if (![rep isKindOfClass:[NSBitmapImageRep class]]) {
            NSLog(@"Can't create NSBitmapImageRep");
            return nil;
        }
    }
    
    return rep;
}

@end