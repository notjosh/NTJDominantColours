//
//  NTJImageFilterer.m
//  NTJDominantColours
//
//  Created by joshua may on 9/06/2016.
//  Copyright © 2016 joshua may. All rights reserved.
//

#import "NTJImageFilterer.h"

@import CoreImage;
@import NTJBilateralCIFilter;

@implementation NTJImageFilterer

- (NSImage *)filter:(NSImage *)image {
    static CGFloat Sigma_R = 2.f;
    static CGFloat Sigma_S = 0.3f;

    CIImage *inCIImage = [[CIImage alloc] initWithData:image.TIFFRepresentation];

    CIFilter *filter = [CIFilter filterWithName:NSStringFromClass([NTJBilateralCIFilter class])];
    [filter setDefaults];
    [filter setValuesForKeysWithDictionary:@{
                                             kCIInputImageKey: inCIImage,
                                             NSStringFromSelector(@selector(sigma_R)): @(Sigma_R),
                                             NSStringFromSelector(@selector(sigma_S)): @(Sigma_S),
                                             }];

    CIImage *outCIImage = [filter valueForKey:kCIOutputImageKey];

    NSCIImageRep *rep = [NSCIImageRep imageRepWithCIImage:outCIImage];
    NSImage *nsImage = [[NSImage alloc] initWithSize:rep.size];
    [nsImage addRepresentation:rep];

    return nsImage;
}

@end
