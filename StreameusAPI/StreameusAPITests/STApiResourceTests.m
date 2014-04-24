//
//  STApiResourceTests.m
//  StreameusAPI
//
//  Created by Anas Ait Ali on 29/03/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "STApiConstants.h"
#import "STApiResource.h"

@interface STApiResourceTests : XCTestCase

@end

@implementation STApiResourceTests

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

- (void)testGetResourceAbout
{
    NSURLResponse *response;
    NSError *error;
    NSURLRequest *request = [STApiResource getAboutWithReturningResponse:&response error:&error];
    if ([request URL]) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        XCTAssertTrue(error == nil && statusCode == 200, @"Unable to GET /resource/about from API. statusCode : %ld, error : %@", (long)statusCode, [error localizedDescription]);
        NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:[request URL]];
        [mutableRequest setHTTPMethod:@"HEAD"];
        request = [mutableRequest copy];
        [NSURLConnection sendSynchronousRequest:request
                              returningResponse:&response
                                          error:&error];
        statusCode = [(NSHTTPURLResponse *)response statusCode];
        XCTAssertTrue(error == nil && statusCode == 200, @"Unable to GET about resource. statusCode : %ld, error : %@", (long)statusCode, [error localizedDescription]);
    }
}

- (void)testGetResourceTeam
{
    NSURLResponse *response;
    NSError *error;
    NSURLRequest *request = [STApiResource getTeamWithReturningResponse:&response error:&error];
    if ([request URL]) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        XCTAssertTrue(error == nil && statusCode == 200, @"Unable to GET /resource/about from API. statusCode : %ld, error : %@", (long)statusCode, [error localizedDescription]);
        NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:[request URL]];
        [mutableRequest setHTTPMethod:@"HEAD"];
        request = [mutableRequest copy];
        [NSURLConnection sendSynchronousRequest:request
                              returningResponse:&response
                                          error:&error];
        statusCode = [(NSHTTPURLResponse *)response statusCode];
        XCTAssertTrue(error == nil && statusCode == 200, @"Unable to GET about resource. statusCode : %ld, error : %@", (long)statusCode, [error localizedDescription]);
    }
}

- (void)testGetResourceFaq
{
    NSURLResponse *response;
    NSError *error;
    NSURLRequest *request = [STApiResource getFaqWithReturningResponse:&response error:&error];
    if ([request URL]) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        XCTAssertTrue(error == nil && statusCode == 200, @"Unable to GET /resource/about from API. statusCode : %ld, error : %@", (long)statusCode, [error localizedDescription]);
        NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:[request URL]];
        [mutableRequest setHTTPMethod:@"HEAD"];
        request = [mutableRequest copy];
        [NSURLConnection sendSynchronousRequest:request
                              returningResponse:&response
                                          error:&error];
        statusCode = [(NSHTTPURLResponse *)response statusCode];
        XCTAssertTrue(error == nil && statusCode == 200, @"Unable to GET about resource. statusCode : %ld, error : %@", (long)statusCode, [error localizedDescription]);
    }
}


@end
