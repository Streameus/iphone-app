//
//  STAgendaRepository.h
//  Streameus
//
//  Created by Anas Ait Ali on 09/07/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STAgendaRepositoryDelegate <NSObject>

- (void)didFetch:(NSArray *)items;

@end

@interface STAgendaRepository : NSObject

@property (nonatomic, weak) id<STAgendaRepositoryDelegate>delegate;
@property (nonatomic, strong, readonly) NSArray *items;

- (void)fetch;

@end
