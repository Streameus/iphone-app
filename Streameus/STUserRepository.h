//
//  STUserRepository.h
//  Streameus
//
//  Created by Anas Ait Ali on 12/02/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STUserRepositoryDelegate <NSObject>

- (void)didFetch:(NSArray *)items;

@end

@interface STUserRepository : NSObject

@property (nonatomic, weak) id<STUserRepositoryDelegate>delegate;
@property (nonatomic, strong, readonly) NSArray *items;

- (void)fetch;

@end
