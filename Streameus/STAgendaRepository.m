//
//  STAgendaRepository.m
//  Streameus
//
//  Created by Anas Ait Ali on 09/07/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STAgendaRepository.h"

@interface STAgendaRepository ()

@property (nonatomic, strong, readwrite) NSArray *items;

@end

@implementation STAgendaRepository

- (void)fetch {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    StreameusAPI *api = [StreameusAPI sharedInstance];
    NSURLRequest *request = [api createUrlController:@"Agenda" withVerb:GET];
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