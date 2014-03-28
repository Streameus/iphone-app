//
//  StreameusAPI.h
//  StreameusAPI
//
//  Created by Anas Ait Ali on 28/03/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    GET,
    POST,
    PUT,
    DELETE,
    OPTIONS,
    HEAD
} STHttpVerbs;

@interface StreameusAPI : NSObject

@property (nonatomic, strong, readonly) NSString *baseUrl;

+ (StreameusAPI *) sharedInstance;

#pragma mark - Initialisation - run this on startup
- (void) initializeWithBaseUrl:(NSString *)baseUrl;

#pragma mark -
- (NSURLRequest *)createUrlController:(NSString *)controller withVerb:(STHttpVerbs)verb;
- (NSURLRequest *)createUrlController:(NSString *)controller withVerb:(STHttpVerbs)verb args:(NSDictionary *)args;

/**
 * Create a request with a controller, http verb, args and http body.
 *
 * @param controller The controller in the api http://api.vm/controller
 * @param verb It the http verb to use for the request (GET, POST,...)
 * @param args Dictionnary of args will resul int http://api.vm/controller?arg1=value1&arg2=value2...
 * @param body HTTP Body of the request can be a json or whatever
 *
 */
- (NSURLRequest *)createUrlController:(NSString *)controller withVerb:(STHttpVerbs)verb args:(NSDictionary *)args andBody:(NSString *)body;

@end
