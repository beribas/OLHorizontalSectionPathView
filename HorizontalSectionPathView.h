//
//  HorizontalSectionPathView.h
//  SectionPathScroll
//
//  Created by Oleg Langer on 26.03.14.
//  Copyright (c) 2014 Oleg Langer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TableViewControllerDelegate.h"
#import "HorizontalSectionPathViewDelegate.h"

@interface HorizontalSectionPathView : UIView <UIScrollViewDelegate, TableViewControllerDelegate>

@property (weak, nonatomic) id<HorizontalSectionPathViewDelegate> delegate;

- (void)setupWithTitles:(NSArray *)titles delegate:(id<HorizontalSectionPathViewDelegate>) delegate;
@end
