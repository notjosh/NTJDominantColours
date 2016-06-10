//
//  ViewController.m
//  NTJDominantColoursDemo
//
//  Created by joshua may on 7/06/2016.
//  Copyright © 2016 joshua may. All rights reserved.
//

#import "ViewController.h"

@import NTJDominantColours;

#import "NTJSolidColourView.h"

@interface ViewController ()

@property (nonatomic, strong) IBOutlet NSImageView *imageView;
@property (nonatomic, strong) IBOutlet NSPopUpButton *fileURLPopUpButton;

@property (nonatomic, strong) IBOutlet NTJSolidColourView *primaryColourPreviewView;
@property (nonatomic, strong) IBOutlet NTJSolidColourView *secondaryColourPreviewView;
@property (nonatomic, strong) IBOutlet NTJSolidColourView *backgroundColourPreviewView;
@property (nonatomic, strong) IBOutlet NSTextField *primaryColourLabel;
@property (nonatomic, strong) IBOutlet NSTextField *secondaryColourLabel;
@property (nonatomic, strong) IBOutlet NSTextField *backgroundColourLabel;

@property (nonatomic, strong) IBOutlet NTJSolidColourView *previewBackground;
@property (nonatomic, strong) IBOutlet NSTextField *previewPrimary;
@property (nonatomic, strong) IBOutlet NSTextField *previewSecondary;

@property (nonatomic, strong) NSArray<NSURL *> *jpgs;

@property (nonatomic, strong) NTJDominantColourProcessor *dominantColourProcessor;

@end

#pragma mark - Class extension helpers

@interface NSString (NTJDebug)

+ (NSString *)ntj_dunno;

@end

@interface NSColor (NTJDebug)

- (NSString *)ntj_hexString;

@end

@interface NSAttributedString (NTJDebug)

- (NSAttributedString *)ntj_attributedStringWithColour:(NSColor *)colour;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURL *resources = [[NSBundle bundleForClass:[self class]] resourceURL];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:resources
                                                   includingPropertiesForKeys:nil
                                                                      options:0
                                                                        error:nil];
    self.jpgs = [files filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"path ENDSWITH[c] '.jpg'"]];

    [self.fileURLPopUpButton removeAllItems];
    [self.fileURLPopUpButton addItemsWithTitles:[self.jpgs valueForKey:@"lastPathComponent"]];

    self.dominantColourProcessor = [[NTJDominantColourProcessor alloc] init];

    // TODO: configure processor (size, buckets, thresholds, contrast, etc)

    [self whoaNewFile:nil];
}

#pragma mark - Actions

- (IBAction)whoaNewFile:(id)sender {
    NSURL *url = self.jpgs[self.fileURLPopUpButton.indexOfSelectedItem];

    NSImage *image = [[NSImage alloc] initByReferencingURL:url];
    self.imageView.image = image;

    [self.dominantColourProcessor process:image withCompletionHandler:^(NTJDominantColourResult * _Nonnull result, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"%@", error);
                return;
            }

            self.primaryColourPreviewView.colour = result.primaryColour;
            self.secondaryColourPreviewView.colour = result.secondaryColour;
            self.backgroundColourPreviewView.colour = result.backgroundColour;
            self.primaryColourLabel.stringValue = [NSString stringWithFormat:@"Primary: %@", [result.primaryColour ntj_hexString] ?: [NSString ntj_dunno]];
            self.secondaryColourLabel.stringValue = [NSString stringWithFormat:@"Secondary: %@", [result.secondaryColour ntj_hexString] ?: [NSString ntj_dunno]];
            self.backgroundColourLabel.stringValue = [NSString stringWithFormat:@"Background: %@", [result.backgroundColour ntj_hexString] ?: [NSString ntj_dunno]];

            self.previewBackground.colour = result.backgroundColour;
            self.previewPrimary.attributedStringValue = [self.previewPrimary.attributedStringValue ntj_attributedStringWithColour:result.primaryColour];
            self.previewSecondary.attributedStringValue = [self.previewSecondary.attributedStringValue ntj_attributedStringWithColour:result.secondaryColour];
        });
    }];
}

@end

@implementation NSString (NTJDebug)

+ (NSString *)ntj_dunno {
    return @"¯\\_(ツ)_/¯";
}

@end

@implementation NSColor (NTJDebug)

// https://developer.apple.com/library/mac/qa/qa1576/_index.html
- (NSString *)ntj_hexString {
    CGFloat redFloatValue, greenFloatValue, blueFloatValue;
    int redIntValue, greenIntValue, blueIntValue;
    NSString *redHexValue, *greenHexValue, *blueHexValue;

    //Convert the NSColor to the RGB color space before we can access its components
    NSColor *convertedColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];

    if (convertedColor)
    {
        // Get the red, green, and blue components of the color
        [convertedColor getRed:&redFloatValue green:&greenFloatValue blue:&blueFloatValue alpha:NULL];

        // Convert the components to numbers (unsigned decimal integer) between 0 and 255
        redIntValue = redFloatValue*255.99999f;
        greenIntValue = greenFloatValue*255.99999f;
        blueIntValue = blueFloatValue*255.99999f;

        // Convert the numbers to hex strings
        redHexValue = [NSString stringWithFormat:@"%02x", redIntValue];
        greenHexValue = [NSString stringWithFormat:@"%02x", greenIntValue];
        blueHexValue = [NSString stringWithFormat:@"%02x", blueIntValue];

        // Concatenate the red, green, and blue components' hex strings together with a "#"
        return [NSString stringWithFormat:@"#%@%@%@", redHexValue, greenHexValue, blueHexValue];
    }

    return nil;
}

@end

@implementation NSAttributedString (NTJDebug)

- (NSAttributedString *)ntj_attributedStringWithColour:(NSColor *)colour {
    NSMutableAttributedString *mas = self.mutableCopy;
    NSRange range = NSMakeRange(0, self.length);

    [mas setAttributes:@{
                         NSForegroundColorAttributeName: colour,
                         }
                 range:range];

    return mas.copy;
}

@end