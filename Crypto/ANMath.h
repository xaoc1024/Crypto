//
//  ANMath.h
//  Crypto
//
//  Created by Andriy Zhuk on 10.10.13.
//  Copyright (c) 2013 Andriy Zhuk. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef float * ANFloatMatrix;
typedef float ** ANFloatMatrix2D;
typedef float *** ANFloatMatrix3D;

typedef enum {
    LATIN_SQUARE = 0,
    LATIN_RECTANGLE,
    M_LESS_THAN_E
} ANSystemModes;

@interface ANMath : NSObject
+ (NSInteger **) integerMatrixWithRows:(NSInteger)rowsCount columns:(NSInteger)columnsCount;
+ (ANFloatMatrix2D) floatMatrixWithRows:(NSInteger)rowsCount columns:(NSInteger)columnsCount;

+ (ANFloatMatrix3D) floatMatrixWithRows:(NSInteger)rowsCount columns:(NSInteger)columnsCount andDepth:(NSInteger)depth;

+ (void) generateUniqueVector:(float*)vector withVectorLength:(NSInteger) vectorLength valueRange:(NSInteger)range;

+ (ANFloatMatrix) pointersArrayWithCount:(NSInteger)count;
+ (void) printMatrix:(float**)matrix withRows:(NSInteger)rowsCount columns:(NSInteger)columnsCount;
+ (void) printMatrix:(ANFloatMatrix3D)matrix withRows:(NSInteger)rowsCount columns:(NSInteger)columnsCount andDepth:(NSInteger) depth;

@end
