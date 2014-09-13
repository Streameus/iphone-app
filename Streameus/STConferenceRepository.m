//
//  STConferenceRepository.m
//  Streameus
//
//  Created by Anas Ait Ali on 15/05/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STConferenceRepository.h"
#import "Reachability.h"
#import "StreameusAPI.h"

@interface STConferenceRepository ()

@property (nonatomic, strong, readwrite) NSArray *items;

@end

@implementation STConferenceRepository

- (void)fetch {
    StreameusAPI *api = [StreameusAPI sharedInstance];
    NSURLRequest *request;
    if (self.userId) {
        request = [api createUrlController:[NSString stringWithFormat:@"user/%d/conferences", self.userId] withVerb:GET];
    } else {
        request = [api createUrlController:@"conference" withVerb:GET];
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
                                   NSLog(@"JSONData =\n%@", JSONData);
                                   for (NSDictionary *it in JSONData) {
                                       [tmpItems addObject:it];
                                   }
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [self didFetch:tmpItems];
                                   });
                               } else if (connectionError == nil && statusCode == 404){
                                   NSLog(@"No user found");
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
    self.items = items;
    [self.delegate didFetch:self.items];
}

@end
