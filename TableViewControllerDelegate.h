//
// Created by Oleg Langer on 16.07.14.
// Copyright (c) 2014 Oleg Langer. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TableViewControllerDelegate <NSObject>

@optional
- (void) tableViewWillDisplaySectionAtIndex: (NSInteger)sectionIndex;
- (void) tableViewWillDisplaySectionWithTitle: (NSString*) title;

@end