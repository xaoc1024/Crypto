//
//  ANMath.m
//  Crypto
//
//  Created by Andriy Zhuk on 10.10.13.
//  Copyright (c) 2013 Andriy Zhuk. All rights reserved.
//

#import "ANMath.h"


@implementation ANMath
+ (NSInteger **) integerMatrixWithRows:(NSInteger)rowsCount columns:(NSInteger)columnsCount; {
    NSInteger ** matrix = calloc(rowsCount, sizeof(NSInteger *));
    
    for (int i = 0; i < rowsCount; ++i){
        matrix[i] = calloc(columnsCount, sizeof(NSInteger));
    }
    
    return matrix;
}

+ (ANFloatMatrix2D) floatMatrixWithRows:(NSInteger)rowsCount columns:(NSInteger)columnsCount {
    ANFloatMatrix2D matrix = calloc(rowsCount, sizeof(float *));
    
    for (int i = 0; i < rowsCount; ++i){
        matrix[i] = calloc(columnsCount, sizeof(float));
    }
    
    return matrix;
}

+ (ANFloatMatrix3D) floatMatrixWithRows:(NSInteger)rowsCount columns:(NSInteger)columnsCount andDepth:(NSInteger)depth {
    ANFloatMatrix3D matrix = calloc(rowsCount, sizeof(float *));
    
    for (int i = 0; i < rowsCount; ++i){
        matrix[i] = calloc(columnsCount, sizeof(float *));
    }
    
    for (int i = 0; i < rowsCount; i++){
        for (int j = 0; j < columnsCount; j++){
            matrix[i][j] = calloc(depth, sizeof(float *));
        }
    }
    
    return matrix;
}

+ (ANFloatMatrix) pointersArrayWithCount:(NSInteger)count {
    return calloc(count, sizeof(float *));
}

+ (void) generateUniqueVector: (float*) vector withVectorLength:(NSInteger) vectorLength valueRange:(NSInteger)range{
    if (vectorLength == 0){
        return;
    }
    srandomdev();
    vector[0] = (float)(random() % range) + 1.0f;
    
    if (vectorLength == 1){
        return;
    }
    srandomdev();
    int i = 1;
    BOOL isPresent;
    while (i < vectorLength){
        float val = (float)(random() % range) + 1.0f;
        isPresent = NO;
        
        for (int j = 0; j < i; ++j){
            if (vector[j] == val){
                isPresent = YES;
                break;
            }
        }
        if (!isPresent){
            vector[i++] = val;
        }
    }
}

#pragma mark - pringting methods
+ (void) printMatrix:(float**)matrix withRows:(NSInteger)rowsCount columns:(NSInteger)columnsCount {
    NSMutableString * str = [NSMutableString stringWithString: @"\n"];
    for (int i = 0; i < rowsCount; i++){
        for (int j = 0; j < columnsCount; j++){
            [str appendFormat:@"%f\t", matrix[i][j]];
        }
        [str appendString:@"\n"];
    }
    NSLog(str, nil);
}

+ (void) printMatrix:(ANFloatMatrix3D)matrix withRows:(NSInteger)rowsCount columns:(NSInteger)columnsCount andDepth:(NSInteger) depth{
    
//    for (int i = 0; i < rowsCount; i++){
//        NSMutableString * str = [NSMutableString stringWithString: @"\n"];
//        for (int j = 0; j < columnsCount; j++){
//            for (int k = 0; k < depth; k++){
//                [str appendFormat:@"%d\t", (int)matrix[i][j][k]];
//            }
//            [str appendString:@"\n"];
//        }
//        NSLog(str, nil);
//    }
}
@end
