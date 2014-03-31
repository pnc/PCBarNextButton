#import "PCBarNextButton.h"

@interface PCBarNextButtonOffset : UIButton

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
  NSString *version = [[UIDevice currentDevice] systemVersion];
  if ([version compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
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
    UIImage *image = [[UIImage imageNamed:@"forward-button"] stretchableImageWithLeftCapWidth:6 topCapHeight:15];
    [rightButton setBackgroundImage:image forState:UIControlStateNormal];
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
  }
  [self.internalButton addTarget:self
                          action:@selector(tapped:)
                forControlEvents:UIControlEventTouchUpInside];
}

- (void)tapped:(id)sender {
  if (self.target && self.action) {
    NSMethodSignature *signature =[self.target methodSignatureForSelector:self.action];
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

- (void)setEnabled:(BOOL)enabled {
  [super setEnabled:enabled];
  self.internalButton.enabled = enabled;
}
@end