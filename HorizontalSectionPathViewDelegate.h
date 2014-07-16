//
// Created by Oleg Langer on 16.07.14.
// Copyright (c) 2014 Oleg Langer. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HorizontalSectionPathViewDelegate <NSObject>

@optional
- (void) sectionPathViewSelectedSectionAtIndex: (NSInteger) sectionIndex;
- (void) sectionPathViewSelectedSectionWithTitle: (NSString*) title;

@end