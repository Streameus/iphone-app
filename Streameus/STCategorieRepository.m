//
//  STCategorieRepository.m
//  Streameus
//
//  Created by Anas Ait Ali on 02/11/14.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STCategorieRepository.h"

@interface STCategorieRepository ()

@property (nonatomic, strong, readwrite) NSArray *items;

@end

@implementation STCategorieRepository

- (void)fetch {
    StreameusAPI *api = [StreameusAPI sharedInstance];
    NSURLRequest *req = [api createUrlController:@"conference/categories" withVerb:GET];
    [api sendAsynchronousRequest:req
                           queue:nil
                          before:^{
                              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:true];
                          } success:^(NSURLResponse *response, NSData *data, NSError *connectionError, id Json) {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self didFetch:Json];
                              });
                          } failure:^(NSURLResponse *response, NSData *data, NSError *connectionError, id Json) {
                              UIAlertView *alert = [[UIAlertView alloc]
                                                    initWithTitle:@"Oops!"
                                                    message:[connectionError localizedDescription]
                                                    delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
                              [alert show];
                              [self didFetch:[[NSArray alloc] init]];
                          } after:^(NSURLResponse *response, NSData *data, NSError *connectionError, id Json) {
                              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:false];
                          }];
}

- (void)didFetch:(NSArray *)items {
    self.items = items;
    [self.delegate didFetch:self.items];
}

@end
