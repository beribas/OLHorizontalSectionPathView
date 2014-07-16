//
//  HorizontalSectionPathView.m
//  SectionPathScroll
//
//  Created by Oleg Langer on 26.03.14.
//  Copyright (c) 2014 Oleg Langer. All rights reserved.
//

#import "HorizontalSectionPathView.h"

#define buttonTagOffset 10

@interface HorizontalSectionPathView()

@property (strong, nonatomic) UIView *contentView;
@property (weak, nonatomic) UIButton *currentlySelectedButton;
@property (strong, nonatomic) NSTimer *contentOffsetResetTimer;
@property (strong, nonatomic) NSArray *titles;

@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation HorizontalSectionPathView 

-(void)awakeFromNib
{
    [self initialSetup];
}

- (void)setupWithTitles:(NSArray *)titles delegate:(id<HorizontalSectionPathViewDelegate>) delegate {
    self.titles = titles;
    self.delegate = delegate;
    [self setupContentView];
}

- (void) initialSetup {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    self.scrollView.delegate = self;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
}

- (void) setupContentView {
    CGFloat xPosOfCurrentSubview = 0;
    CGFloat widthOfSubView = 100;
    CGFloat heightOfSubview = CGRectGetHeight(self.scrollView.frame);
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.titles.count * widthOfSubView, heightOfSubview)];
    for (NSString *title in self.titles) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(xPosOfCurrentSubview, 0, widthOfSubView, heightOfSubview)];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        button.tag = [self.titles indexOfObject:title] + buttonTagOffset;
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        UIColor *color = [UIColor colorWithRed: (((int)button >> 0) & 0xFF) / 255.0
                                         green: (((int)button >> 8) & 0xFF) / 255.0
                                          blue: (((int)button >> 16) & 0xFF) / 255.0
                                         alpha: 1.0];
        [button setBackgroundColor:color];
        [self.contentView addSubview:button];
        xPosOfCurrentSubview += widthOfSubView;
    }
    [self.scrollView addSubview:self.contentView];
    [self.scrollView setContentSize:self.contentView.frame.size];
}

- (void) buttonPressed: (UIButton*) button {
    [self markButtonSelected:button];
    [self updateContentOffsetForSelectedButton: button];
    
    if ([self.delegate respondsToSelector:@selector(sectionPathViewSelectedSectionAtIndex:)]) {
        [self.delegate sectionPathViewSelectedSectionAtIndex:button.tag - buttonTagOffset];
    }
    else if ([self.delegate respondsToSelector:@selector(sectionPathViewSelectedSectionWithTitle:)]) {
        [self.delegate sectionPathViewSelectedSectionWithTitle:self.titles[button.tag = buttonTagOffset]];
    }
    else {
        NSLog(@"the delegate does not respond to any selector");
    }
}

- (void) markButtonSelected: (UIButton*) button {
    self.currentlySelectedButton.selected = NO;
    button.selected = YES;
    self.currentlySelectedButton = button;
}

- (void) updateContentOffsetForSelectedButton: (UIButton*) button {
    CGPoint buttonCenter = button.center;
    CGPoint desiredContentOffset = CGPointMake(buttonCenter.x - CGRectGetMidX(self.scrollView.frame), 0);
    if (desiredContentOffset.x <= 0)
        desiredContentOffset.x = 0;
    else if (desiredContentOffset.x >= self.scrollView.contentSize.width - CGRectGetWidth(self.scrollView.frame))
        desiredContentOffset.x = self.scrollView.contentSize.width - CGRectGetWidth(self.scrollView.frame);
    [self.scrollView setContentOffset:desiredContentOffset animated:YES];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialSetup];
    }
    return self;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.contentOffsetResetTimer invalidate];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.contentOffsetResetTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(resetContentOffset:) userInfo:nil repeats:NO];
}

- (void) resetContentOffset: (id) sender {
    [self updateContentOffsetForSelectedButton:self.currentlySelectedButton];
}

- (void)tableViewWillDisplaySectionAtIndex:(NSInteger)sectionIndex {
    UIButton *button = (UIButton*) [self.contentView viewWithTag:sectionIndex + buttonTagOffset];
    [self markButtonSelected:button];
    [self updateContentOffsetForSelectedButton:button];
}

@end
