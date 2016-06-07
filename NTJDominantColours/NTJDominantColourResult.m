//
//  NTJDominantColourResult.m
//  NTJDominantColours
//
//  Created by joshua may on 7/06/2016.
//  Copyright © 2016 joshua may. All rights reserved.
//

#import "NTJDominantColourResult.h"

@interface NTJDominantColourResult ()

@property (nonatomic, copy, readwrite) NSColor *primaryColour;
@property (nonatomic, copy, readwrite) NSColor *secondaryColour;
@property (nonatomic, copy, readwrite) NSColor *backgroundColour;

@end

@implementation NTJDominantColourResult

- (instancetype)initWithPrimaryColour:(NSColor *)primaryColour secondaryColour:(NSColor *)secondaryColour backgroundColour:(NSColor *)backgroundColour {
    self = [super init];

    if (self) {
        _primaryColour = primaryColour.copy;
        _secondaryColour = secondaryColour.copy;
        _backgroundColour = backgroundColour.copy;
    }

    return self;
}

- (instancetype)init {
    return [self initWithPrimaryColour:nil
                       secondaryColour:nil
                      backgroundColour:nil];
}

@end
