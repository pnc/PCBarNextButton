@interface PCBarNextButton : UIBarButtonItem <UIAppearanceContainer>
@property (nonatomic, retain) UIButton *internalButton;
- (id)initWithTitle:(NSString *)title;
@end
