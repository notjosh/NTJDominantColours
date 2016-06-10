//
//  NTJDominantColourProcessor.m
//  NTJDominantColours
//
//  Created by joshua may on 7/06/2016.
//  Copyright © 2016 joshua may. All rights reserved.
//

#import "NTJDominantColourProcessor.h"

#import "NTJColourExtractor.h"
#import "NTJDominantColourResult.h"
#import "NTJImageFilterer.h"
#import "NTJImageResizer.h"

NSSize sizeToAspectFitDimension(NSSize size, CGFloat dimension) {
    CGFloat ratio = size.width / size.height;

    if (ratio > 0.0) {
        // landscape
        return NSMakeSize(dimension, dimension / ratio);
    } else {
        // portrait
        return NSMakeSize(dimension / ratio, dimension);
    }

    return NSMakeSize(dimension, dimension);
}

static CGFloat const NTJDominantColourProcessorMaxDimension = 30.f;

@implementation NTJDominantColourProcessor

- (void)process:(NSImage *)image withCompletionHandler:(nullable NTJDominantColourProcessingCompletionHandler)handler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSImage *workImage = image.copy;
        // if config.resize:
        // image = [self.resizer resizeImage:image toFit:size];

        // if config.smoothen
        // image = [self.bilateralFilter filterImage:image sigma_R,sigma_S];

        // extract colours
        // borderColours = [self.extractor coloursAtEdge:NSEdgeInsets(1px)]
        // centreColours = [self.extractor coloursInsideEdge:NSEdgeInsets(1px)]

        // classify colours. shy away from black/white because that's boring.
        // backgroundColour = [self.classifier classify:borderColours threshold: stopAt:1];
        // primaryAndSecondaryColours = [self.classifier classify:centreColours threshold: stopAt:2];

        // make sure there's sufficient contrast
        // while() {
        //   if contrast < enough()
        //     primaryAndSecondaryColours = // fetch deeper
        //   }
        // }

        // if nothing, then default to black/white
        // if (background.isDark) {
        //   colour = white
        // } else {
        //   colour = dark
        // }

        // process:

        NSSize size = sizeToAspectFitDimension(image.size, NTJDominantColourProcessorMaxDimension);

        NTJImageFilterer *filterer = [NTJImageFilterer new];
        workImage = [filterer filter:workImage];

        NTJImageResizer *resizer = [NTJImageResizer new];
        workImage = [resizer resize:workImage
                          toFitSize:size];

        NTJColourExtractor *extractor = [NTJColourExtractor new];
        NSCountedSet <NSColor *> *colours = [extractor extractFromImage:workImage];

        NTJDominantColourResult *result = [self countedSetToResult:colours];

//        usleep(0.5 * USEC_PER_SEC);
//        NTJDominantColourResult *result = [[NTJDominantColourResult alloc] initWithPrimaryColour:[NSColor redColor]
//                                                                                 secondaryColour:[NSColor yellowColor]
//                                                                                backgroundColour:[NSColor blueColor]];
//

        if (handler) {
            handler(result, nil);
        }

    });
}

- (NTJDominantColourResult *)countedSetToResult:(NSCountedSet<NSColor *> *)set {
    NSArray *sorted = [set.allObjects sortedArrayUsingComparator:^(NSColor *obj1, NSColor *obj2) {
        NSUInteger a = [set countForObject:obj1];
        NSUInteger b = [set countForObject:obj2];
        return (a <= b) ? (a < b) ? NSOrderedAscending : NSOrderedSame : NSOrderedDescending;
    }];

    NSAssert(sorted.count >= 3, @"There needs to be at least three colours to return a meaningful value! :(");

    return [[NTJDominantColourResult alloc] initWithPrimaryColour:sorted[0]
                                                  secondaryColour:sorted[1]
                                                 backgroundColour:sorted[2]];
}

@end
