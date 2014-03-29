//
//  STApiUserTests.m
//  StreameusAPI
//
//  Created by Anas Ait Ali on 29/03/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "STApiUser.h"
#import "STApiConstants.h"

@interface STApiUserTests : XCTestCase

@end

@implementation STApiUserTests

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

- (void)testGetUser
{
    StartBlock();
    [STApiUser getUserWithCompletionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        EndBlock();
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        XCTAssertTrue(error == nil && (statusCode == 200 || statusCode == 204), @"Unable to GET /user from API. statusCode : %ld, error : %@", (long)statusCode, [error localizedDescription]);
        id JSONData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        XCTAssertTrue([JSONData isKindOfClass:[NSArray class]], @"Returned data is not an NSArray, data class : %@", [JSONData class]);
        if (statusCode != 204) {
            NSArray *receivedKeys = [[[JSONData objectAtIndex:0] allKeys] sortedArrayUsingSelector:@selector(compare:)];
            NSArray *expected = @[@"FirstName",
                                  @"Id",
                                  @"Reputation",
                                  @"City",
                                  @"Country",
                                  @"Gender",
                                  @"Address",
                                  @"Email",
                                  @"BirthDay",
                                  @"Description",
                                  @"Pseudo",
                                  @"LastName",
                                  @"Profession",
                                  @"Phone",
                                  @"Website"];
            expected = [expected sortedArrayUsingSelector:@selector(compare:)];
            XCTAssertTrue([receivedKeys isEqualToArray:expected], @"Object keys are different, received keys : %@", receivedKeys);
        }
    }];
    WaitUntilBlockCompletes();
}

@end
