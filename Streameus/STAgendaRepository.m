//
//  STAgendaRepository.m
//  Streameus
//
//  Created by Anas Ait Ali on 09/07/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STAgendaRepository.h"

@interface STAgendaRepository ()

@property (nonatomic, strong, readwrite) NSArray *agenda;
@property (nonatomic, strong, readwrite) NSArray *live;
@property (nonatomic, strong, readwrite) NSArray *soon;

@end

@implementation STAgendaRepository

- (void)fetch:(STAgendaType)type {
    StreameusAPI *api = [StreameusAPI sharedInstance];
    NSURLRequest *request;
    
    switch (type) {
        case LIVE:
            request = [api createUrlController:@"Agenda/Live" withVerb:GET];
            break;
        case SOON:
            request = [api createUrlController:@"Agenda/Soon" withVerb:GET];
            break;
        default:
            request = [api createUrlController:@"Agenda" withVerb:GET];
            break;
    }
    
    [api sendAsynchronousRequest:request queue:nil
                          before:^{
                              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                          }
                         success:^(NSURLResponse *response, NSData *data, NSError *connectionError, id Json) {
                             id JSONData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                             NSMutableArray *tmpItems = [NSMutableArray array];
                             NSLog(@"JSONData [%@] =\n%@", [JSONData class], JSONData);
                             for (NSDictionary *it in JSONData) {
                                 [tmpItems addObject:it];
                             }
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 [self didFetch:tmpItems forType:type];
                             });
                         }
                         failure:^(NSURLResponse *response, NSData *data, NSError *connectionError, id Json) {
                             if (connectionError != nil) {
                                 UIAlertView *alert = [[UIAlertView alloc]
                                                       initWithTitle:@"Error"
                                                       message:[connectionError localizedDescription]
                                                       delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles: nil];
                                 [alert show];
                             }
                             [self didFetch:[[NSArray alloc] init] forType:type];
                         } after:^(NSURLResponse *response, NSData *data, NSError *connectionError, id Json) {
                             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                         }];
}

- (void)didFetch:(NSArray *)items forType:(STAgendaType)type {
    switch (type) {
        case LIVE:
            self.live = items;
            break;
        case SOON:
            self.soon = items;
            break;
        default:
            self.agenda = items;
            break;
    }
    [self.delegate didFetch:items forType:type];
}

@end
