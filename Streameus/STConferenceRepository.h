//
//  STConferenceRepository.h
//  Streameus
//
//  Created by Anas Ait Ali on 15/05/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STConferenceRepositoryDelegate <NSObject>

- (void)didFetch:(NSArray *)items;

@end

@interface STConferenceRepository : NSObject

@property (nonatomic, weak) id<STConferenceRepositoryDelegate>delegate;
@property (nonatomic, strong, readonly) NSArray *items;
@property (nonatomic, assign) int userId;
@property (nonatomic, assign) int categorieId;

- (void)fetch;

@end
