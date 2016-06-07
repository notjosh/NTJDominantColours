//
//  NTJDominantColourResult.h
//  NTJDominantColours
//
//  Created by joshua may on 7/06/2016.
//  Copyright © 2016 joshua may. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NTJDominantColourResult : NSObject

- (instancetype)initWithPrimaryColour:(NSColor *)primaryColour secondaryColour:(NSColor *)secondaryColour backgroundColour:(NSColor *)backgroundColour NS_DESIGNATED_INITIALIZER;

@property (nonatomic, copy, readonly) NSColor *primaryColour;
@property (nonatomic, copy, readonly) NSColor *secondaryColour;
@property (nonatomic, copy, readonly) NSColor *backgroundColour;

@end
