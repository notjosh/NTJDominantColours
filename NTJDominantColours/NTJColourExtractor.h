//
//  NTJColourExtractor.h
//  NTJDominantColours
//
//  Created by joshua may on 7/06/2016.
//  Copyright © 2016 joshua may. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NTJColourExtractor : NSObject

- (NSCountedSet<NSColor *> *)extractFromImage:(NSImage *)image;

@end
