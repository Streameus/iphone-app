//
//  STAgendaRepository.h
//  Streameus
//
//  Created by Anas Ait Ali on 09/07/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    AGENDA,
    LIVE,
    SOON
} STAgendaType;

@protocol STAgendaRepositoryDelegate <NSObject>

- (void)didFetch:(NSArray *)items forType:(STAgendaType)type;

@end

@interface STAgendaRepository : NSObject

@property (nonatomic, weak) id<STAgendaRepositoryDelegate>delegate;
@property (nonatomic, strong, readonly) NSArray *agenda;
@property (nonatomic, strong, readonly) NSArray *live;
@property (nonatomic, strong, readonly) NSArray *soon;

- (void)fetch:(STAgendaType)type;

@end
