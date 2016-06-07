//
//  NTJDominantColourProcessor.h
//  NTJDominantColours
//
//  Created by joshua may on 7/06/2016.
//  Copyright © 2016 joshua may. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class NTJDominantColourResult;

typedef void (^NTJDominantColourProcessingCompletionHandler)(NTJDominantColourResult *__nonnull result, NSError * __nullable error);

@interface NTJDominantColourProcessor : NSObject

- (void)process:(nonnull NSImage *)image withCompletionHandler:(nullable NTJDominantColourProcessingCompletionHandler)handler;

@end
