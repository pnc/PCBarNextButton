#import "PCBarNextButton.h"

@interface PCBarNextButtonOffset : UIButton
@end

@interface PCBarNextButton ()
@property (nonatomic) UIColor *appearanceTintColor;
@property (nonatomic) UIImage *tintedImage;
@end

@implementation PCBarNextButtonOffset

- (UIEdgeInsets)alignmentRectInsets {
  return UIEdgeInsetsMake(0, 0, 0, 8);
}

@end

@interface PCBarNextButton()
- (void)initialize;
- (void)tapped:(id)sender;
@end

@implementation PCBarNextButton
- (void)dealloc {
  self.internalButton = nil;
}

- (id)initWithTitle:(NSString *)title {
  if (self = [super init]) {
    self.title = title;
    [self initialize];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    [self initialize];
  }
  return self;
}

- (void)initialize {
  UIBarButtonItem *proxy = [UIBarButtonItem appearanceWhenContainedIn:[PCBarNextButton class], nil];
  self.appearanceTintColor = proxy.tintColor ?: [UIColor
                                                 colorWithRed:.54
                                                 green:.62
                                                 blue:.73
                                                 alpha:1.0];
  if ([self flatStyle]) {
    PCBarNextButtonOffset *rightButton = [PCBarNextButtonOffset buttonWithType:UIButtonTypeSystem];
    UIImage *image = [UIImage imageNamed:@"forward-arrow-ios7"];
    [rightButton setImage:image forState:UIControlStateNormal];
    [rightButton setTitle:self.title forState:UIControlStateNormal];
    UIButton *refButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton.titleLabel setFont:refButton.titleLabel.font];
    rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [rightButton sizeToFit];
    CGRect frame = rightButton.frame;
    frame.size.width += 10;
    frame.size.height += 10;
    rightButton.frame = frame;
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, rightButton.frame.size.width - image.size.width, 0, 0);
    rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, -image.size.width - 10, 0, 0);
    rightButton.enabled = self.enabled;
    self.customView = rightButton;
    self.internalButton = rightButton;
  } else {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    rightButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
    rightButton.titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.05];
    [rightButton setTitle:self.title forState:UIControlStateNormal];
    [rightButton sizeToFit];
    CGRect frame = rightButton.frame;
    rightButton.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width + 20, 32);
    rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    rightButton.enabled = self.enabled;
    self.customView = rightButton;
    self.internalButton = rightButton;
    [self configureColoredButtonImage];
  }
  [self.internalButton addTarget:self
                          action:@selector(tapped:)
                forControlEvents:UIControlEventTouchUpInside];
}

- (void)configureColoredButtonImage {
  UIImage *image = [[self tintedImage] stretchableImageWithLeftCapWidth:6
                                                           topCapHeight:15];
  [self.internalButton setBackgroundImage:image
                                 forState:UIControlStateNormal];
}

- (BOOL)flatStyle {
  NSString *version = [[UIDevice currentDevice] systemVersion];
  return [version compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending;
}

- (void)tapped:(id)sender {
  if (self.target && self.action) {
    NSMethodSignature *signature = [self.target methodSignatureForSelector:self.action];
    if (2 == signature.numberOfArguments) {
      // Just self and _cmd
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
      [self.target performSelector:self.action];
#pragma clang diagnostic pop

    } else if (3 == signature.numberOfArguments) {
      // self, _cmd, and sender
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
      [self.target performSelector:self.action withObject:self];
#pragma clang diagnostic pop
    } else {
      NSAssert(NO, @"Target's action expects too many arguments.");
    }
  }
}

- (UIImage *)tintedImage {
  if (!_tintedImage) {
    UIColor *tintColor = self.tintColor ?: self.appearanceTintColor;
    UIImage *originalImage = [UIImage imageNamed:@"forward-button"];
    CIImage *image = [CIImage imageWithCGImage:[originalImage CGImage]];

    CIContext *context = [CIContext contextWithOptions:nil];

    CIFilter *compensate = [CIFilter filterWithName:@"CIColorControls"];
    [compensate setDefaults];
    [compensate setValue:image forKey:kCIInputImageKey];
    [compensate setValue:[NSNumber numberWithFloat:0.2] forKey:@"inputBrightness"];
    [compensate setValue:[NSNumber numberWithFloat:1.4] forKey:@"inputContrast"];

    CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochrome"];
    [filter setDefaults];
    [filter setValue:[compensate valueForKey:kCIOutputImageKey] forKey:kCIInputImageKey];
    [filter setValue:[CIColor colorWithCGColor:[tintColor CGColor]]
              forKey:@"inputColor"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGRect extent = [result extent];
    CGImageRef cgImage = [context createCGImage:result fromRect:extent];

    _tintedImage = [UIImage imageWithCGImage:cgImage
                                       scale:originalImage.scale
                                 orientation:UIImageOrientationUp];
  }
  return _tintedImage;
}

- (void)setTintColor:(UIColor *)tintColor {
  [super setTintColor:tintColor];
  if (![self flatStyle]) {
    _tintedImage = nil;
    [self configureColoredButtonImage];
  }
}

- (void)setEnabled:(BOOL)enabled {
  [super setEnabled:enabled];
  self.internalButton.enabled = enabled;
}
@end