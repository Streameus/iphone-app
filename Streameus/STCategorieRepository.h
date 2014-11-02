//
//  STCategorieRepository.h
//  Streameus
//
//  Created by Anas Ait Ali on 02/11/14.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STCategorieRepositoryDelegate <NSObject>

- (void)didFetch:(NSArray *)items;

@end

@interface STCategorieRepository : NSObject

@property (nonatomic, weak) id<STCategorieRepositoryDelegate>delegate;
@property (nonatomic, strong, readonly) NSArray *items;

- (void)fetch;

@end
