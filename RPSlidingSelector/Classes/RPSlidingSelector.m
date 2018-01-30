/*
 * (c) Ramon Poca - 2013
 *
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

#import "RPSlidingSelector.h"

const CGFloat kButtonSpacing = 40.0;
const CGFloat kButtonPadding = 10.0;

NSInteger tagSort(id num1, id num2, void *context) {
  NSInteger v1 = [num1 tag];
  NSInteger v2 = [num2 tag];
  if (v1 < v2)
    return NSOrderedAscending;
  else if (v1 > v2)
    return NSOrderedDescending;
  else
    return NSOrderedSame;
}


@implementation RPSlidingSelector {
  NSArray *_buttons;
  UIScrollView *_scrollView;
  BOOL _ignoreClick;
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _buttons = [[NSArray alloc] init];
    _scrollView = [[UIScrollView alloc] initWithFrame:frame];
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _ignoreClick = NO;
  }

  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    _buttons = [[NSArray alloc] init];

    if (![[self.subviews firstObject] isKindOfClass:[UIScrollView class]]) {
      _scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
      [self addSubview:_scrollView];
    } else {
      _scrollView = (UIScrollView *) [self.subviews firstObject];
      NSInteger count = 0;
      for (UIView *subview in _scrollView.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
          UIButton *button = (UIButton *) subview;
          if (button.hidden)
            continue;
          [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
          if (count == 0)
              button.selected = YES;
          if (button.tag == 0) {
            button.tag = count++;
          }
          _buttons = [_buttons arrayByAddingObject:button];
        }
      }
      _buttons = [_buttons sortedArrayUsingFunction:tagSort context:nil];
    }
    _scrollView.autoresizingMask |= UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _ignoreClick = NO;
    _scrollView.delegate = self;
    _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
  }
  return self;
}

- (void)layoutSubviews {
  CGFloat halfScrollWidth = _scrollView.frame.size.width / 2;
  CGFloat x = halfScrollWidth;
  CGFloat selectedX = x;
  for (UIButton *button in _buttons) {
    [button setTitle:[[button titleForState:UIControlStateNormal] uppercaseString] forState:UIControlStateNormal];
    [button sizeToFit];
    button.frame = CGRectMake(x, 0, button.frame.size.width + 2 * kButtonPadding, _scrollView.frame.size.height);
    if (button.tag == self.selectedItem) {
      selectedX = x + button.frame.size.width / 2.0;
    }
    x += (button.frame.size.width + kButtonSpacing);
  }
  _scrollView.contentSize = CGSizeMake(x - kButtonSpacing + halfScrollWidth, _scrollView.frame.size.height);
  _scrollView.contentOffset = CGPointMake(selectedX - halfScrollWidth, 0);
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
  if (!scrollView.tracking)
    return;
  CGFloat halfScrollViewWidth = scrollView.frame.size.width / 2.0;
  CGFloat targetX = targetContentOffset->x + halfScrollViewWidth;
  UIButton *target = [self getNearestButtonInScrollView:scrollView toX:targetX];
  if (target) {
    CGFloat origin = target.frame.origin.x + target.frame.size.width / 2.0 - halfScrollViewWidth;
    targetContentOffset->x = origin;
    if (target.tag != _selectedItem)
      [target sendActionsForControlEvents:UIControlEventTouchUpInside];
  }
}

- (UIButton *)getNearestButtonInScrollView:(UIScrollView *)scrollView toX:(CGFloat)targetX {
  CGFloat distance = INFINITY;
  UIButton *target = nil;
  for (UIButton *subview in _buttons) {
      if (target == nil) {
        target = subview;
      }
      CGFloat subviewMidX = subview.frame.origin.x + subview.frame.size.width / 2.0;
      float d = fabs(targetX - subviewMidX);
      if (d < distance) {
        distance = d;
        target = subview;
      }
  }
  return target;
}


- (void)unselectAllButtons {
  for (UIView *subview in _scrollView.subviews) {
    if ([subview isKindOfClass:[UIButton class]]) {
      ((UIButton *) subview).selected = NO;
    }
  }
}

- (void)clearAllButtons {
  for (UIView *subview in _scrollView.subviews) {
    if ([subview isKindOfClass:[UIButton class]]) {
      [((UIButton *) subview) removeFromSuperview];
    }
  }
  _buttons = [[NSArray alloc] init];
  _selectedItem = 0;
}

- (void)selectItemAnimated:(NSInteger)item {
  [self layoutSubviews];
  for (UIButton *button in _buttons) {
    if (button.tag == item) {
      _selectedItem = item;
      [self unselectAllButtons];
      button.selected = YES;
      CGFloat x = button.frame.origin.x + button.frame.size.width/2.0;
      [_scrollView setContentOffset:CGPointMake(x, 0) animated:NO];
      break;
    }
  }
}

- (UIButton *)addButtonWithLabel:(NSString *)label {
  UIButton *button = [self newButton];
  [button setTitle:label forState:UIControlStateNormal];
  [button setTitleColor:[UIColor colorWithWhite:0.302 alpha:1.000] forState:UIControlStateNormal];
  [button setTitleColor:[UIColor colorWithRed:0.597 green:0.000 blue:0.066 alpha:1.000] forState:UIControlStateSelected];
  [self setNeedsLayout];
  return button;
}

- (UIButton *)newButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
  [button setBackgroundImage:[UIImage imageNamed:@"slider_select"] forState:UIControlStateSelected];
  button.selected = _buttons.count == 0;
  button.tag = _buttons.count;
  [_scrollView addSubview:button];
  _buttons = [_buttons arrayByAddingObject:button];
  [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
  return button;
}

- (void)didClickButton:(UIButton *)button {
  self.selectedItem = button.tag;
  [self unselectAllButtons];
  button.selected = YES;
  if (self.delegate) {
    [self.delegate slidingSelector:self didSelectIndex:self.selectedItem];
  }
  CGFloat halfScrollViewWidth = _scrollView.frame.size.width / 2.0;
  CGFloat origin = button.frame.origin.x + button.frame.size.width / 2.0 - halfScrollViewWidth;
  if (_scrollView.contentOffset.x != origin) {
    [_scrollView setContentOffset:CGPointMake(origin, 0) animated:YES];
  }
}

- (UIButton *)addButtonWithImage:(UIImage *)image selectedImage:(UIImage *) selectedImage{
  UIButton *button = [self newButton];
  [button setImage:image forState:UIControlStateNormal];
  [button setImage:selectedImage forState:UIControlStateSelected];
  [self setNeedsLayout];
  return button;
}

@end
