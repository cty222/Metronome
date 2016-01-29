#import "SubPropertySelector.h"
#import "TimeSignatureType.h"
#import "TwoDigitsValuePicker.h"

@interface TimeSignaturePickerView : SubPropertySelector<ValuePickerTemplateProtocol>

+ (UIColor *) TextFontColor;

- (void) DisplayPropertyCell : (NSArray *) FillInData : (UIView *) TriggerButton;

@end
