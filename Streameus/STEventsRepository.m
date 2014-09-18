//
//  STEventsRepository.m
//  Streameus
//
//  Created by Anas Ait Ali on 08/06/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STEventsRepository.h"

@interface STEventsRepository ()

@property (nonatomic, strong, readwrite) NSArray *items;

@end

@implementation STEventsRepository
@synthesize top = _top, skip = _skip, numberOfItems = _numberOfItems;

- (id)init {
    if (self == [super init]) {
        _top = kSTEventDefaultTop;
        _skip = 0;
        _numberOfItems = 0;
    }
    return self;
}

- (NSArray *)getRecommendationsUser {
    if (self.authorId) {
        return nil;
    }
    StreameusAPI *api = [StreameusAPI sharedInstance];
    NSURLRequest *request = [api createUrlController:@"recommendation/users" withVerb:GET];
    NSURLResponse *response;
    NSError *connectionError;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&connectionError];
    NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
    NSLog(@"[%ld] %@", (long)statusCode, [response URL]);
    if (connectionError == nil && statusCode <= 204) {
        NSArray *JSONData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        return JSONData;
    } else if (connectionError != nil){
        NSLog(@"Error happened = %@", connectionError);
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:[connectionError localizedDescription]
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil];
        [alert show];
    }
    return nil;
}

- (NSArray *)getRecommendationsConf {
    if (self.authorId) {
        return nil;
    }
    StreameusAPI *api = [StreameusAPI sharedInstance];
    NSURLRequest *request = [api createUrlController:@"recommendation/conferences" withVerb:GET];
    NSURLResponse *response;
    NSError *connectionError;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&connectionError];
    NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
    NSLog(@"[%ld] %@", (long)statusCode, [response URL]);
    if (connectionError == nil && statusCode <= 204) {
        NSArray *JSONData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        return JSONData;
    } else if (connectionError != nil){
        NSLog(@"Error happened = %@", connectionError);
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:[connectionError localizedDescription]
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil];
        [alert show];
    }
    return nil;
}

- (void)clear {
    self.items = nil;
}

- (void)fetch {
    if (self.dontLoad) {
        return;
    }
    _top = kSTEventDefaultTop;
    _skip = kSTEventDefaultSkip;
    NSDictionary *args = @{@"$top": [NSString stringWithFormat: @"%d", (int)_top], @"$skip" : [NSString stringWithFormat: @"%d", (int)_skip]};
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    StreameusAPI *api = [StreameusAPI sharedInstance];
    NSURLRequest *request;
    if (self.authorId) {
        request = [api createUrlController:[NSString stringWithFormat:@"event/author/%d", self.authorId] withVerb:GET args:args];
    } else {
        request = [api createUrlController:@"event" withVerb:GET args:args];
    }
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                               NSLog(@"URL %@", [response URL]);
                               NSLog(@"Response status code %ld", (long)statusCode);
                               if (connectionError == nil && statusCode <= 204) {
                                   id JSONData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                   NSMutableArray *tmpItems = [NSMutableArray array];
                                   NSLog(@"JSONData [%@] =\n%@", [JSONData class], JSONData);
                                   for (NSDictionary *it in JSONData) {
                                       [tmpItems addObject:it];
                                   }
                                   _numberOfItems = [tmpItems count];
                                   NSArray *recommendations = [self getRecommendationsConf];
                                   if (recommendations != nil) {
                                       int pos = RAND_FROM_TO(0, (int)_numberOfItems + 1);
                                       NSLog(@"Insertion en pos : %d", pos);
                                       pos = (pos > _numberOfItems) ? (int)_numberOfItems : pos;
                                       [tmpItems insertObject:recommendations atIndex:pos];
                                   }
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [self didFetch:tmpItems];
                                   });
                               } else if (connectionError == nil && statusCode == 404){
                                   NSLog(@"No user found");
                                   [self didFetch:nil];
                               } else if (connectionError != nil){
                                   NSLog(@"Error happened = %@", connectionError);
                                   UIAlertView *alert = [[UIAlertView alloc]
                                                         initWithTitle:@"Error"
                                                         message:[connectionError localizedDescription]
                                                         delegate:nil
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles: nil];
                                   [alert show];
                                   [self didFetch:[[NSArray alloc] init]];
                               }
                           }];

}

- (void)fetchMore {
    if (self.dontLoad) {
        return;
    }
    _skip += kSTEventDefaultTop;
    NSDictionary *args = @{@"$top": [NSString stringWithFormat: @"%d", (int)_top], @"$skip" : [NSString stringWithFormat: @"%d", (int)_skip]};
    StreameusAPI *api = [StreameusAPI sharedInstance];
    NSURLRequest *request;
    if (self.authorId) {
        request = [api createUrlController:[NSString stringWithFormat:@"event/author/%d", self.authorId] withVerb:GET args:args];
    } else {
        request = [api createUrlController:@"event" withVerb:GET args:args];
    }
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                               NSLog(@"URL %@", [response URL]);
                               NSLog(@"Response status code %ld", (long)statusCode);
                               if (connectionError == nil && statusCode <= 204) {
                                   id JSONData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                   NSMutableArray *tmpItems = [NSMutableArray arrayWithArray:self.items];
                                   NSLog(@"JSONData [%@] =\n%@", [JSONData class], JSONData);
                                   NSInteger saveNumberOfItems = _numberOfItems;
                                   for (NSDictionary *it in JSONData) {
                                       [tmpItems addObject:it];
                                       _numberOfItems++;
                                   }
                                   int moreRand = RAND_FROM_TO(0, 2);
                                   if (moreRand == 2) {
                                       NSArray *recommendations = [self getRecommendationsUser];
                                       if (recommendations != nil) {
                                           int pos = (int)saveNumberOfItems + RAND_FROM_TO(0, (int)_top);
                                           NSLog(@"Insertion en pos : %d", pos);
                                           pos = (pos > _numberOfItems) ? (int)_numberOfItems : pos;
                                           [tmpItems insertObject:recommendations atIndex:pos];
                                       }
                                   }

                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [self didFetchMore:tmpItems];
                                   });
                               } else if (connectionError == nil && statusCode == 404){
                                   [self didFetchMore:nil];
                               } else if (connectionError != nil){
                                   NSLog(@"Error happened = %@", connectionError);
                                   UIAlertView *alert = [[UIAlertView alloc]
                                                         initWithTitle:@"Error"
                                                         message:[connectionError localizedDescription]
                                                         delegate:nil
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles: nil];
                                   [alert show];
                                   [self didFetchMore:[[NSArray alloc] init]];
                               }
                           }];
}

- (void)didFetch:(NSArray *)items {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.items = items;
    [self.delegate didFetch:self.items];
}

- (void)didFetchMore:(NSArray *)items {
    self.items = items;
    [self.delegate didFetchMore:self.items];
}

@end
