//
//  STEventsRepository.h
//  Streameus
//
//  Created by Anas Ait Ali on 08/06/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STEventsRepositoryDelegate <NSObject>

- (void)didFetch:(NSArray *)items;

@end

@interface STEventsRepository : NSObject

@property (nonatomic, weak) id<STEventsRepositoryDelegate>delegate;
@property (nonatomic, strong, readonly) NSArray *items;
@property (nonatomic, assign) int authorId;

- (void)fetch;

@end
