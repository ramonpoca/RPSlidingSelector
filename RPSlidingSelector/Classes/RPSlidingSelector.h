/*
 * (c) Ramon Poca - 2013
 *
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

#import <Foundation/Foundation.h>

@class RPSlidingSelector;
@protocol RPSlidingSelectorDelegate <NSObject>
- (void) slidingSelector: (RPSlidingSelector *) selector didSelectIndex: (NSInteger) index;
@end

@interface RPSlidingSelector : UIView <UIScrollViewDelegate>
@property (assign, nonatomic) NSInteger selectedItem;
@property (assign, nonatomic) NSUInteger count;

@property(nonatomic, weak) id<RPSlidingSelectorDelegate> delegate;
- (void) selectItemAnimated: (NSInteger) item;
- (UIButton *) addButtonWithLabel: (NSString *) label;
- (UIButton *)addButtonWithImage:(UIImage *)image selectedImage:(UIImage *) selectedImage;
- (void) clearAllButtons;
@end
