//
//  STUserRepository.m
//  Streameus
//
//  Created by Anas Ait Ali on 12/02/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STUserRepository.h"
#import "Reachability.h"

@interface STUserRepository ()

@property (nonatomic, strong, readwrite) NSArray *items;

@end

@implementation STUserRepository

- (void)fetch {
    NSURLRequest *urlRequest = [[Streameus sharedInstance] createUrlController:@"user"
                                                                      withVerb:GET];
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                               NSLog(@"URL %@", [response URL]);
                               NSLog(@"Response status code %ld", (long)statusCode);
                               if (connectionError == nil && statusCode == 200) {
                                   id JSONData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                   NSMutableArray *tmpItems = [NSMutableArray array];
                                   NSLog(@"JSONData =\n%@", JSONData);
                                   for (NSDictionary *it in [JSONData objectForKey:@"data"]) {
                                       [tmpItems addObject:it];
                                   }
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [self didFetch:tmpItems];
                                   });
                               } else if (connectionError == nil && statusCode == 204){
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
