// Protocol Buffers for Objective C
//
// Copyright 2010 Booyah Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "ArrayTests.h"

#import "PBArray.h"

@implementation ArrayTests

#pragma mark PBArray

- (void)testCount
{
	const int32_t kValues[3] = { 1, 2, 3 };
	PBArray *array = [[PBArray alloc] initWithValues:kValues count:3 valueType:PBArrayValueTypeInt32];
	XCTAssertEqual([array count], (NSUInteger)3);
	XCTAssertEqual(array.count, (NSUInteger)3);
	[array release];
}

- (void)testValueType
{
	const int32_t kValues[3] = { 1, 2, 3 };
	PBArray *array = [[PBArray alloc] initWithValues:kValues count:3 valueType:PBArrayValueTypeInt32];
	XCTAssertEqual(array.valueType, PBArrayValueTypeInt32);
	[array release];
}

- (void)testPrimitiveAccess
{
	const int32_t kValues[3] = { 1, 2, 3 };
	PBArray *array = [[PBArray alloc] initWithValues:kValues count:3 valueType:PBArrayValueTypeInt32];
	XCTAssertEqual([array int32AtIndex:1], 2);
	[array release];
}

- (void)testObjectAccess
{
	const id kValues[1] = { [NSString stringWithFormat:@"Test"] };
	PBArray *array = [[PBArray alloc] initWithValues:kValues count:1 valueType:PBArrayValueTypeObject];
	XCTAssertTrue([[array objectAtIndex:0] isEqualToString:@"Test"]);
	[array release];
}

- (void)testEmpty
{
	PBArray *array = [[PBArray alloc] init];
	XCTAssertEqual(array.count, (NSUInteger)0);
	XCTAssertEqual(array.valueType, PBArrayValueTypeObject);
	XCTAssertEqual(array.data, (const void *)nil);
	XCTAssertThrowsSpecificNamed([array objectAtIndex:0], NSException, NSRangeException);
	[array release];
}

- (void)testCopy
{
	const int32_t kValues[3] = { 1, 2, 3 };
	PBArray *original = [[PBArray alloc] initWithValues:kValues count:3 valueType:PBArrayValueTypeInt32];
	PBArray *copy = [original copy];
	XCTAssertEqual(original.valueType, copy.valueType);
	XCTAssertEqual(original.count, copy.count);
	XCTAssertEqual([original int32AtIndex:1], [copy int32AtIndex:1]);
	[copy release];
	[original release];
}

- (void)testCopyObjects
{
	const id kValues[1] = { [NSString stringWithFormat:@"Test"] };
	PBArray *original = [[PBArray alloc] initWithValues:kValues count:1 valueType:PBArrayValueTypeObject];
	PBArray *copy = [original copy];
	XCTAssertEqual(original.valueType, copy.valueType);
	XCTAssertEqual(original.count, copy.count);
	XCTAssertEqual([original objectAtIndex:0], [copy objectAtIndex:0]);
	[copy release];
	[original release];
}

- (void)testFastEnumeration
{
	const id kValues[2] = { [NSString stringWithFormat:@"1"], [NSString stringWithFormat:@"2"] };
	PBArray *array = [[PBArray alloc] initWithValues:kValues count:2 valueType:PBArrayValueTypeObject];

	NSUInteger count = 0;
	for (NSString *s in array)
	{
		XCTAssertTrue([s isEqualToString:kValues[count++]]);
	}
	XCTAssertEqual(count, (NSUInteger)2);

	[array release];
}

- (void)testArrayAppendingArray
{
	const int32_t kValues[3] = { 1, 2, 3 };
	PBArray *a = [[PBArray alloc] initWithValues:kValues count:3 valueType:PBArrayValueTypeInt32];
	PBArray *b = [[PBArray alloc] initWithValues:kValues count:3 valueType:PBArrayValueTypeInt32];

	PBArray *copy = [[a arrayByAppendingArray:b] retain];
	XCTAssertEqual(copy.valueType, a.valueType);
	XCTAssertEqual(copy.count, a.count + b.count);

	[copy release];
	[a release];
	[b release];
}

- (void)testArrayAppendingArrayObjects
{
	const id kValues[1] = { [NSString stringWithFormat:@"Test"] };
	PBArray *a = [[PBArray alloc] initWithValues:kValues count:1 valueType:PBArrayValueTypeObject];
	PBArray *b = [[PBArray alloc] initWithValues:kValues count:1 valueType:PBArrayValueTypeObject];

	PBArray *copy = [[a arrayByAppendingArray:b] retain];
	XCTAssertEqual(copy.valueType, a.valueType);
	XCTAssertEqual(copy.count, a.count + b.count);

	[copy release];
	[a release];
	[b release];
}

- (void)testAppendArrayTypeException
{
	const int32_t kValuesA[3] = { 1, 2, 3 };
	const int64_t kValuesB[3] = { 1, 2, 3 };
	PBArray *a = [[PBArray alloc] initWithValues:kValuesA count:3 valueType:PBArrayValueTypeInt32];
	PBArray *b = [[PBArray alloc] initWithValues:kValuesB count:3 valueType:PBArrayValueTypeInt64];
	XCTAssertThrowsSpecificNamed([a arrayByAppendingArray:b], NSException, PBArrayTypeMismatchException);
	[a release];
	[b release];
}

- (void)testRangeException
{
	const int32_t kValues[3] = { 1, 2, 3 };
	PBArray *array = [[PBArray alloc] initWithValues:kValues count:3 valueType:PBArrayValueTypeInt32];
	XCTAssertThrowsSpecificNamed([array objectAtIndex:10], NSException, NSRangeException);
	[array release];
}

- (void)testTypeMismatchException
{
	const int32_t kValues[3] = { 1, 2, 3 };
	PBArray *array = [[PBArray alloc] initWithValues:kValues count:3 valueType:PBArrayValueTypeInt32];
	XCTAssertThrowsSpecificNamed([array objectAtIndex:0], NSException, PBArrayTypeMismatchException);
	[array release];
}

- (void)testNumberExpectedException
{
	NSArray *objects = [[NSArray alloc] initWithObjects:@"Test", nil];
	XCTAssertThrowsSpecificNamed([[PBArray alloc] initWithArray:objects valueType:PBArrayValueTypeInt32],
								NSException, PBArrayNumberExpectedException);
	[objects release];
}

#pragma mark PBAppendableArray

- (void)testAddValue
{
	PBAppendableArray *array = [[PBAppendableArray alloc] initWithValueType:PBArrayValueTypeInt32];
	[array addInt32:1];
	[array addInt32:4];
	XCTAssertEqual(array.count, (NSUInteger)2);
	XCTAssertThrowsSpecificNamed([array addBool:NO], NSException, PBArrayTypeMismatchException);
	[array release];
}

- (void)testAddObject
{
	PBAppendableArray *array = [[PBAppendableArray alloc] initWithValueType:PBArrayValueTypeObject];
	[array addObject:[NSString stringWithFormat:@"One"]];
	[array addObject:[NSString stringWithFormat:@"Two"]];
	XCTAssertEqual(array.count, (NSUInteger)2);
	XCTAssertThrowsSpecificNamed([array addBool:NO], NSException, PBArrayTypeMismatchException);
	[array release];
}

- (void)testAppendArray
{
	const int32_t kValues[3] = { 1, 2, 3 };
	PBArray *source = [[PBArray alloc] initWithValues:kValues count:3 valueType:PBArrayValueTypeInt32];
	PBAppendableArray *array = [[PBAppendableArray alloc] initWithValueType:PBArrayValueTypeInt32];
	[array appendArray:source];
	XCTAssertEqual(array.count, source.count);
	XCTAssertEqual([array int32AtIndex:1], 2);
	[array release];
	[source release];
}

- (void)testAppendValues
{
	const int32_t kValues[3] = { 1, 2, 3 };
	PBAppendableArray *array = [[PBAppendableArray alloc] initWithValueType:PBArrayValueTypeInt32];
	[array appendValues:kValues count:3];
	XCTAssertEqual(array.count, (NSUInteger)3);
	XCTAssertEqual([array int32AtIndex:1], 2);
	[array release];
}

- (void)testEqualValues
{
	const int32_t kValues[3] = { 1, 2, 3 };
	PBArray *array1 = [[PBArray alloc] initWithValues:kValues count:2 valueType:PBArrayValueTypeInt32];

	// Test self equality.
	XCTAssertEqualObjects(array1, array1);

	PBArray *array2 = [[PBArray alloc] initWithValues:kValues count:2 valueType:PBArrayValueTypeInt32];
	// Test other equality.
	XCTAssertEqualObjects(array1, array2);

	// Test non equality of nil.
	XCTAssertFalse([array1 isEqual:nil]);

	// Test non equality of other object type.
	XCTAssertFalse([array1 isEqual:@""]);

	// Test non equality of arrays of different sizes with same prefix.
	PBArray *array3 = [[PBArray alloc] initWithValues:kValues count:3 valueType:PBArrayValueTypeInt32];
	XCTAssertFalse([array1 isEqual:array3]);

	// Test non equality of arrays of same sizes with different contents.
	const int32_t kValues2[2] = { 2, 1 };
	PBArray *array4 = [[PBArray alloc] initWithValues:kValues2 count:2 valueType:PBArrayValueTypeInt32];
	XCTAssertFalse([array1 isEqual:array4]);

	[array1 release];
	[array2 release];
	[array3 release];
	[array4 release];
}

@end