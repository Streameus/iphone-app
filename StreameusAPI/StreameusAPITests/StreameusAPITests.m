//
//  StreameusAPITests.m
//  StreameusAPITests
//
//  Created by Anas Ait Ali on 28/03/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "STApiConstants.h"

@interface StreameusAPITests : XCTestCase

@end

@implementation StreameusAPITests

- (void)setUp
{
    [super setUp];
    [[StreameusAPI sharedInstance] initializeWithBaseUrl:kSTStreameusAPIURL];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testApiIsOnline
{
    NSURLRequest *request = [[StreameusAPI sharedInstance] createUrlController:@""
                                                                  withVerb:GET];
    NSURLResponse *response;
    NSError *error;
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&response
                                      error:&error];
    NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
    XCTAssertFalse(error, @"There is a connection error : %@", [error localizedDescription]);
    XCTAssertTrue(statusCode == 500, @"Bad status code returned : %ld", (long)statusCode);
}

@end
