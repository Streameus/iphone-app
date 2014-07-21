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

- (NSArray *)getRecommendations {
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
    if (connectionError == nil && statusCode == 200) {
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

- (void)fetch {
    if (self.dontLoad) {
        return;
    }
    NSString *numberOfItems = @"3";
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    StreameusAPI *api = [StreameusAPI sharedInstance];
    NSURLRequest *request;
    if (self.authorId) {
        request = [api createUrlController:[NSString stringWithFormat:@"event/author/%d", self.authorId] withVerb:GET args:@{@"$top": numberOfItems}];
    } else {
        request = [api createUrlController:@"event" withVerb:GET args:@{@"$top": numberOfItems}];
    }
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                               NSLog(@"URL %@", [response URL]);
                               NSLog(@"Response status code %ld", (long)statusCode);
                               if (connectionError == nil && statusCode == 200) {
                                   id JSONData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                   NSMutableArray *tmpItems = [NSMutableArray array];
                                   NSLog(@"JSONData [%@] =\n%@", [JSONData class], JSONData);
                                   for (NSDictionary *it in JSONData) {
                                       [tmpItems addObject:it];
                                   }
                                   NSArray *recommendations = [self getRecommendations];
                                   if (recommendations != nil) {
                                       int pos = arc4random() % [tmpItems count];
                                       NSLog(@"Insertion en pos : %d", pos);
                                       [tmpItems insertObject:recommendations atIndex:pos];
                                   }
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [self didFetch:tmpItems];
                                   });
                               } else if (connectionError == nil && statusCode == 204){
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

- (void)didFetch:(NSArray *)items {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.items = items;
    [self.delegate didFetch:self.items];
}

@end
