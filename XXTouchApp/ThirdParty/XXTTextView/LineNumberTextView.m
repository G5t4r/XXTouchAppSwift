//
//  LineNumberTextView.m
//  TextKit_LineNumbers
//
//  Created by Mark Alldritt on 2013-10-11.
//  Copyright (c) 2013 Late Night Software Ltd. All rights reserved.
//

#import "LineNumberTextView.h"
#import "LineNumberLayoutManager.h"

static const float kCursorVelocity = 1.0f/8.0f;

@implementation LineNumberTextView
{
  NSRange startRange;
  
  UIPanGestureRecognizer *singleFingerPanRecognizer;
  UIPanGestureRecognizer *doubleFingerPanRecognizer;
}

//- (id)initWithCoder:(NSCoder *)aDecoder {
//  self = [super initWithCoder:aDecoder];
//  [self setupGestureRecognizers];
//  [self setupHighlighting];
//  return self;
//}

- (id)initWithFrame:(CGRect) frame {
  NSTextStorage* ts = [[NSTextStorage alloc] init];
  LineNumberLayoutManager* lm = [[LineNumberLayoutManager alloc] init];
  NSTextContainer* tc = [[NSTextContainer alloc] initWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
  
  //  Wrap text to the text view's frame
  //  tc.widthTracksTextView = YES;
  
  //  Exclude the line number gutter from the display area available for text display.
  tc.exclusionPaths = @[[UIBezierPath bezierPathWithRect:CGRectMake(0.0, 0.0, 35.0, CGFLOAT_MAX)]];
  
  [lm addTextContainer:tc];
  [ts addLayoutManager:lm];
  
  if ((self = [super initWithFrame:frame textContainer:tc])) {
    self.contentMode = UIViewContentModeRedraw; // cause drawRect: to be called on frame resizing and divice rotation
    
    
    //    [self setupGestureRecognizers];
    //    [self setupHighlighting];
  }
  return self;
}

- (void)setupHighlighting {
  
  self.textStorage.delegate = self;
  _highlightDefinition = [LineNumberTextView defaultHighlightDefinition];
  _highlightTheme      = [LineNumberTextView defaultHighlightTheme];
  
}

- (void)textStorageDidProcessEditing:(id)sender {
  
  NSRange paragaphRange = [self.textStorage.string paragraphRangeForRange: self.textStorage.editedRange];
  
  [self.textStorage removeAttribute:NSForegroundColorAttributeName range:paragaphRange];
  
  for (NSString* key in _highlightDefinition) {
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:[_highlightDefinition objectForKey:key]
                                                                           options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    
    [regex enumerateMatchesInString:self.textStorage.string options:0 range:paragaphRange
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                           [self.textStorage addAttribute:NSForegroundColorAttributeName value:[_highlightTheme objectForKey:key] range:result.range];
                         }];
    
  }
  
}

+ (NSDictionary *)defaultHighlightDefinition {
  
  NSString *path = [NSBundle.mainBundle pathForResource:@"Syntax" ofType:@"plist"];
  return [NSDictionary dictionaryWithContentsOfFile:path];
  
}

+ (NSDictionary *)defaultHighlightTheme {
  
  return @{@"text":                          [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1],
           @"background":                    [UIColor colorWithRed: 40.0/255 green: 43.0/255 blue: 52.0/255 alpha:1],
           @"comment":                       [UIColor colorWithRed: 72.0/255 green:190.0/255 blue:102.0/255 alpha:1],
           @"documentation_comment":         [UIColor colorWithRed: 72.0/255 green:190.0/255 blue:102.0/255 alpha:1],
           @"documentation_comment_keyword": [UIColor colorWithRed: 72.0/255 green:190.0/255 blue:102.0/255 alpha:1],
           @"string":                        [UIColor colorWithRed:230.0/255 green: 66.0/255 blue: 75.0/255 alpha:1],
           @"character":                     [UIColor colorWithRed:139.0/255 green:134.0/255 blue:201.0/255 alpha:1],
           @"number":                        [UIColor colorWithRed:139.0/255 green:134.0/255 blue:201.0/255 alpha:1],
           @"keyword":                       [UIColor colorWithRed:195.0/255 green: 55.0/255 blue:149.0/255 alpha:1],
           @"preprocessor":                  [UIColor colorWithRed:211.0/255 green:142.0/255 blue: 99.0/255 alpha:1],
           @"url":                           [UIColor colorWithRed: 35.0/255 green: 63.0/255 blue:208.0/255 alpha:1],
           @"attribute":                     [UIColor colorWithRed:103.0/255 green:135.0/255 blue:142.0/255 alpha:1],
           @"project":                       [UIColor colorWithRed:146.0/255 green:199.0/255 blue:119.0/255 alpha:1],
           @"other":                         [UIColor colorWithRed:  0.0/255 green:175.0/255 blue:199.0/255 alpha:1]};
  
}

#pragma mark Gestures

- (void)setupGestureRecognizers {
  
  singleFingerPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(singleFingerPanHappend:)];
  singleFingerPanRecognizer.maximumNumberOfTouches = 1;
  [self addGestureRecognizer:singleFingerPanRecognizer];
  
  doubleFingerPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(doubleFingerPanHappend:)];
  doubleFingerPanRecognizer.minimumNumberOfTouches = 2;
  [self addGestureRecognizer:doubleFingerPanRecognizer];
  
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
  
  // Only accept horizontal pans for the code navigation to preserve correct scrolling behaviour.
  if (gestureRecognizer == singleFingerPanRecognizer || gestureRecognizer == doubleFingerPanRecognizer) {
    CGPoint translation = [gestureRecognizer translationInView:self];
    return fabs(translation.x) > fabs(translation.y);
  }
  
  return YES;
  
}

- (void)requireGestureRecognizerToFail:(UIGestureRecognizer *)gestureRecognizer {
  
  [singleFingerPanRecognizer requireGestureRecognizerToFail:gestureRecognizer];
  [doubleFingerPanRecognizer requireGestureRecognizerToFail:gestureRecognizer];
  
}

- (void)singleFingerPanHappend:(UIPanGestureRecognizer *)sender {
  
  if (sender.state == UIGestureRecognizerStateBegan) {
    startRange = self.selectedRange;
  }
  
  CGFloat cursorLocation = MAX(startRange.location + [sender translationInView:self].x * kCursorVelocity, 0);
  
  self.selectedRange = NSMakeRange(cursorLocation, 0);
  
}

- (void)doubleFingerPanHappend:(UIPanGestureRecognizer *)sender {
  
  if (sender.state == UIGestureRecognizerStateBegan) {
    startRange = self.selectedRange;
  }
  
  CGFloat cursorLocation = MAX(startRange.location + [sender translationInView:self].x * kCursorVelocity, 0);
  
  if (cursorLocation > startRange.location) {
    self.selectedRange = NSMakeRange(startRange.location, fabs(startRange.location - cursorLocation));
  } else {
    self.selectedRange = NSMakeRange(cursorLocation, fabs(startRange.location - cursorLocation));
  }
  
}

- (void) drawRect:(CGRect)rect {
  
  //  Drag the line number gutter background.  The line numbers them selves are drawn by LineNumberLayoutManager.
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGRect bounds = self.bounds;
  
  CGContextSetFillColorWithColor(context, _lineBackgroundColor.CGColor);
  CGContextFillRect(context, CGRectMake(bounds.origin.x, bounds.origin.y, kLineNumberGutterWidth, bounds.size.height));
  
  CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
  CGContextSetLineWidth(context, 0.2);
  CGContextStrokeRect(context, CGRectMake(bounds.origin.x + 35, bounds.origin.y, 0.1, CGRectGetHeight(bounds)));
  
  [super drawRect:rect];
}

@end
