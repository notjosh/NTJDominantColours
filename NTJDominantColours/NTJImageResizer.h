//
//  NTJImageResizer.h
//  NTJDominantColours
//
//  Created by joshua may on 7/06/2016.
//  Copyright © 2016 joshua may. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NTJImageResizer : NSObject

- (NSImage *)resize:(NSImage *)image toFitSize:(NSSize)size;

@end
