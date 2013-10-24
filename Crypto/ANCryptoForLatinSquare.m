
//
//  ANCrypto.m
//  Crypto
//
//  Created by Andriy Zhuk on 09.10.13.
//  Copyright (c) 2013 Andriy Zhuk. All rights reserved.
//

#import "ANCryptoForLatinSquare.h"



@interface ANCryptoForLatinSquare () {
//    void ** _tables;
    ANFloatMatrix3D _feeMatrix3D;
}
@property (nonatomic, assign) NSInteger squareSize;
@property (nonatomic, assign) NSInteger messagesCount;
@property (nonatomic, assign) NSInteger keysCount;
@property (nonatomic, assign) NSInteger cryptogramsCount;

@property (nonatomic, assign) float messagePrioriProbabilitySum;
@property (nonatomic, assign) float keyPrioriProbabilitySum;

@end

@implementation ANCryptoForLatinSquare
- (id) initWithMessagesCount:(NSInteger) messagesCount
                    kesCount:(NSInteger) keysCount
            cryptogramsCount:(NSInteger) cryptogramsCount
                     andMode:(ANSystemModes) systemMode
{
    self = [super init];
    if (self){
        _messagesCount = messagesCount;
        _keysCount = keysCount;
        _cryptogramsCount = cryptogramsCount;
        _tables = (void *)[ANMath pointersArrayWithCount:NUM_OF_TABLES];
        
        _tables[ENCRYPTION_TABLE] = [ANMath floatMatrixWithRows:keysCount columns:messagesCount];
        _tables[MESSAGES_PRIORI_PROBABILITY] = [ANMath floatMatrixWithRows:1 columns:messagesCount];
        _tables[KEYS_PRIORI_PROBABILITY] = [ANMath floatMatrixWithRows:1 columns:keysCount];
        _tables[MESSAGES_POSTERIORI_PROBABILITY] = [ANMath floatMatrixWithRows:cryptogramsCount columns:messagesCount];
        _tables[PRIORI_POSTERIORY_MESSAGES_DIFFERENCE] = [ANMath floatMatrixWithRows:cryptogramsCount columns:messagesCount];
        _tables[KEYS_POSTERIORI_PROBABILITY] = [ANMath floatMatrixWithRows:keysCount columns:cryptogramsCount];
        
        _tables[RATIO] = [ANMath floatMatrixWithRows:keysCount columns:messagesCount];
        
        switch (systemMode) {
            case LATIN_SQUARE:
                [self generateEncryptionTableForLatinSquare];
                break;
            case LATIN_RECTANGLE:
                [self generateEncryptionTableForLatinRectangle];
                break;
                
            case M_LESS_THAN_E:
                [self generateEncryptionTableForThirdCase];
                break;
                
            default:
                break;
        }
        
        [self createFeeFunctionArray];
        
        [self generateMessagesPriorTableWithEqualsProbability];
        [self generateKeysPrioriTableWithEqualsProbability];
        [self generateMessagesPosterioriProbability];
        [self generatePrioriAndPosterioriMessagesProbabilityDifference];
        [self generatePosterioriKeysProbability];
        [self generateRatio];

    }
    return self;
}

- (id)initWithSize: (NSInteger) squareSize {
    self = [super init];
    
    if (self){
        _squareSize = squareSize;
        _tables = (void *)[ANMath pointersArrayWithCount:NUM_OF_TABLES];
        for (int i = 0; i < NUM_OF_TABLES; i++){
            _tables[i] = [ANMath floatMatrixWithRows:squareSize columns:squareSize];
        }
        [self generateEncryptionTableForLatinSquare];
        [self createFeeFunctionArray];
//        [self generateMessagesPriorTableAutomatically];
        [self generateMessagesPriorTableWithEqualsProbability];
        [self generateKeysPrioriTableWithEqualsProbability];
        [self generateMessagesPosterioriProbability];
        [self generatePrioriAndPosterioriMessagesProbabilityDifference];
        [self generatePosterioriKeysProbability];
    }
    
    return self;
}

#pragma mark - support
#pragma mark - fee func
- (void) createFeeFunctionArray {
    ANFloatMatrix3D feeMatrix = [ANMath floatMatrixWithRows:_messagesCount columns:_keysCount andDepth:_cryptogramsCount];
    ANFloatMatrix2D encryptionTable = _tables[ENCRYPTION_TABLE];
    
    int E = 0;
    for (int i = 0; i < _messagesCount; ++i) {
        for (int j = 0; j < _keysCount; ++j){
            E = (int)encryptionTable[j][i];
            feeMatrix[i][j][E - 1] = 1;
        }
    }
    
//    E = 0;
//    for (int i = 0; i < _keysCount; ++i) {
//        for (int j = 0; j < _messagesCount; ++j){
//            E = (int)encryptionTable[i][j];
//            feeMatrix[i][j][E - 1] = 1;
//        }
//    }
    [ANMath printMatrix:feeMatrix withRows:_messagesCount columns:_keysCount andDepth:_cryptogramsCount];
    _feeMatrix3D = feeMatrix;
}

#pragma mark - 1 - ENCRYPTION_TABLE

- (void) generateEncryptionTableForLatinSquare {
    ANFloatMatrix2D matrix = _tables[ENCRYPTION_TABLE];
    matrix[0][0] = self.cryptogramsCount;
    
    for (int i = 1; i < self.messagesCount; i++){
        matrix[0][i] = i;
    }
    // make shift left
    for (int i = 1; i < self.keysCount; i++){
        for (int j = 0; j < self.messagesCount - 1; j++){
            matrix[i][j] = matrix[i - 1][j + 1];
        }
        float lastVal = matrix[i - 1][self.messagesCount-1];
        matrix[i][self.messagesCount - 1] = (lastVal < self.cryptogramsCount) ? (lastVal + 1) : 1;
    }
    NSLog(@"Encryption Table:");
    [ANMath printMatrix:matrix withRows: self.keysCount columns: self.messagesCount];
}

- (void) generateEncryptionTableForLatinRectangle {
    ANFloatMatrix2D matrix = _tables[ENCRYPTION_TABLE];
    [ANMath generateUniqueVector:matrix[0] withVectorLength:self.messagesCount valueRange:self.messagesCount];
    
    // make shift left
    int thirsPartOfRows = self.keysCount / 3;
    for (int i = 1; i < thirsPartOfRows; i++){
        float firstVal = matrix[i-1][0];
        for (int j = 0; j < self.messagesCount - 1; j++){
            matrix[i][j] = matrix[i - 1][j + 1];
        }
        matrix[i][self.messagesCount - 1] = firstVal;
    }
    
    [ANMath generateUniqueVector:matrix[thirsPartOfRows] withVectorLength:self.messagesCount valueRange:self.messagesCount];
    for (int i = thirsPartOfRows + 1; i < 2*thirsPartOfRows; i++){
        float firstVal = matrix[i-1][0];
        for (int j = 0; j < self.messagesCount - 1; j++){
            matrix[i][j] = matrix[i - 1][j + 1];
        }
        matrix[i][self.messagesCount - 1] = firstVal;
    }
    
    [ANMath generateUniqueVector:matrix[2 * thirsPartOfRows] withVectorLength:self.messagesCount valueRange:self.messagesCount];
    for (int i = 2 * thirsPartOfRows + 1; i < self.keysCount; i++){
        float firstVal = matrix[i-1][0];
        for (int j = 0; j < self.messagesCount - 1; j++){
            matrix[i][j] = matrix[i - 1][j + 1];
        }
        matrix[i][self.messagesCount - 1] = firstVal;
    }
    
    NSLog(@"Encryption Table:");
    [ANMath printMatrix:matrix withRows: self.keysCount columns: self.messagesCount];
}

- (void) generateEncryptionTableForThirdCase {
    ANFloatMatrix2D matrix = _tables[ENCRYPTION_TABLE];
    float vec[self.cryptogramsCount];
    [ANMath generateUniqueVector:vec withVectorLength:self.cryptogramsCount valueRange:self.cryptogramsCount];
    
    for (int i = 0; i < self.keysCount; i++){
        for (int j = 0; j < self.messagesCount; j++){
            matrix[i][j] = vec[j];
        }
        // shifting array
        float firstVal = vec[0];
        for (int ii = 0; ii < self.cryptogramsCount - 1; ii++){
            vec[ii] = vec[ii+1];
        }
        vec[self.cryptogramsCount - 1] = firstVal;
    }

    NSLog(@"Encryption Table:");
    [ANMath printMatrix:matrix withRows: self.keysCount columns: self.messagesCount];
}

#pragma mark - 2 - MESSAGES_PRIORI_PROBABILITY
- (void) generateMessagesPriorTableAutomatically {
    ANFloatMatrix2D matrix = _tables[MESSAGES_PRIORI_PROBABILITY];
    float line [self.messagesCount];
    float sum = 0;
    
    for (int j = 0; j < self.messagesCount; j++){
        line[j] = (float)(rand() % 16384) + 1.0f;
        sum += line[j];
    }
    float sum2 = 0; 
    for (int j = 0; j < self.messagesCount; j++) {
        matrix[0][j] = line[j] / sum;
        sum2 += matrix[0][j];
    }
    _messagePrioriProbabilitySum = sum2;
    NSLog(@"sum = %f", sum2);
}

- (void) generateMessagesPriorTableWithEqualsProbability {
    ANFloatMatrix2D matrix = _tables[MESSAGES_PRIORI_PROBABILITY];
    float sum2 = 0;
    for (int j = 0; j < self.messagesCount; j++) {
        matrix[0][j] = 1.0f / (float) self.messagesCount;
        sum2 += matrix[0][j];
    }
    _messagePrioriProbabilitySum = sum2;
}

- (float) messagePrioriProbabilitySum {
    ANFloatMatrix2D matrix = _tables[MESSAGES_PRIORI_PROBABILITY];
    float sum2 = 0;
    for (int j = 0; j < self.messagesCount; j++) {
        sum2 += matrix[0][j];
    }
    return sum2;
}

#pragma mark - 3 - KEYS_PRIORI_PROBABILITY
- (void) generateKeysPrioriTableWithEqualsProbability {
    float sum2 = 0;
    ANFloatMatrix2D matrix = _tables[KEYS_PRIORI_PROBABILITY];
    for (int j = 0; j < self.keysCount; j++) {
        matrix[0][j] = 1.0f / (float) self.keysCount;
        sum2 += matrix[0][j];
    }
     _keyPrioriProbabilitySum = sum2;
}

- (void) generateKeysPriorTableAutomatically {
    float sum = 0;
    ANFloatMatrix2D matrix = _tables[KEYS_PRIORI_PROBABILITY];
    float line [self.keysCount];
    
    for (int j = 0; j < self.keysCount; j++){
        sum += line[j] = (float)(rand() % 200) + 1.0f;
    }
    
    float sum2 = 0;
    for (int j = 0; j < self.keysCount; j++) {
        sum2 += matrix[0][j] = line[j] / sum;
    }
    _keyPrioriProbabilitySum = sum2;
    NSLog(@"sum = %f", sum2);
}

- (void) zeroKeyMode {
    ANFloatMatrix2D matrix = _tables[KEYS_PRIORI_PROBABILITY];
    BOOL zerosArray[self.keysCount];
    int zeroCounter = 0;
    
    for (int i = 0; i < self.keysCount; i++) {
        if (matrix[0][i] == 0.0f){
            zerosArray[i] = YES;
            zeroCounter++;
        } else {
            zerosArray[i] = NO;
        }
    }
    
    int diff = self.keysCount - zeroCounter;
    for (int j = 0; j < self.keysCount; j++) {
        if (!zerosArray[j]){
            matrix[0][j] = 1.0f / (float) diff;
        }
    }
}

- (float)keyPrioriProbabilitySum {
    ANFloatMatrix2D matrix = _tables[KEYS_PRIORI_PROBABILITY];
    float sum2 = 0;
    for (int j = 0; j < self.keysCount; j++) {
        sum2 += matrix[0][j];
    }
    return sum2;
}

#pragma mark - 4 - MESSAGES_POSTERIORI_PROBABILITY
- (void) generateMessagesPosterioriProbability{
    ANFloatMatrix2D matrix = _tables[MESSAGES_POSTERIORI_PROBABILITY];
    
    ANFloatMatrix2D messagePrioriMatrix = _tables[MESSAGES_PRIORI_PROBABILITY];
    ANFloatMatrix2D keyMatrix = _tables[KEYS_PRIORI_PROBABILITY];
    
    float PMiEs = 0;
    float PEs = 0;
    
    for (int s = 0; s < self.cryptogramsCount; s++)
    {
        for (int i = 0; i < self.messagesCount; i++)
        {
            float PMi = messagePrioriMatrix[0][i];// priori probability
            // calculating PMiEs
            PMiEs = 0;
            for (int j = 0; j < self.keysCount; j++) {
                PMiEs += keyMatrix[0][j] * _feeMatrix3D[i][j][s];
            }
            PEs = 0;
            for (int internalI = 0; internalI < self.messagesCount; internalI++){
                for (int j = 0; j < self.keysCount; j++){
                    PEs += keyMatrix[0][j] * (messagePrioriMatrix [ 0 ] [ internalI ]) * (_feeMatrix3D [ internalI ] [j] [s]);
                }
            }
            matrix[s][i] = (PMi * PMiEs) / PEs; // PEsMi
        }
    }
    NSLog(@"4 - MESSAGES_POSTERIORI_PROBABILITY");
    [ANMath printMatrix:matrix withRows:self.cryptogramsCount columns:self.messagesCount];
}

#pragma mark - 5 - PRIORI_POSTERIORY_MESSAGES_DIFFERENCE
- (void) generatePrioriAndPosterioriMessagesProbabilityDifference {
    ANFloatMatrix2D matrix = _tables[PRIORI_POSTERIORY_MESSAGES_DIFFERENCE];
    ANFloatMatrix2D messagesPrioriMatrix = _tables[MESSAGES_PRIORI_PROBABILITY];
    ANFloatMatrix2D messagesPosterioriMatrix = _tables[MESSAGES_POSTERIORI_PROBABILITY];
    
    for (int i = 0; i < self.cryptogramsCount; i++){
        for (int j = 0; j < self.messagesCount; j++){
            matrix[i][j] = messagesPosterioriMatrix[i][j] - messagesPrioriMatrix[0][j];
        }
    }
    NSLog(@"5 - PRIORI_POSTERIORY_MESSAGES_DIFFERENCE");
    [ANMath printMatrix:matrix withRows:self.cryptogramsCount columns:self.messagesCount];
}

#pragma mark - 6 - KEYS_POSTERIORI_PROBABILITY
- (void) generatePosterioriKeysProbability {
    ANFloatMatrix2D matrix = _tables[KEYS_POSTERIORI_PROBABILITY];
    ANFloatMatrix2D messagesPrioriMatrix = _tables[MESSAGES_PRIORI_PROBABILITY];
    ANFloatMatrix2D keyPrioriMatrix = _tables[KEYS_PRIORI_PROBABILITY];
    
    float PKjEs = 0;
    float PEs = 0;
    for (int j = 0; j < self.keysCount; j++)
    {
        for (int s = 0; s < self.cryptogramsCount; s++)
        {
            PKjEs = 0;
            for (int i = 0; i < self.messagesCount; i++){
                PKjEs += messagesPrioriMatrix[0][i] * _feeMatrix3D[i][j][s];
            }
            
            PEs = 0;
            for (int internalI = 0; internalI < self.messagesCount; internalI++){
                for (int j = 0; j < self.keysCount; j++){
                    PEs += keyPrioriMatrix[0][j] * (messagesPrioriMatrix [ 0 ] [ internalI ]) * (_feeMatrix3D [ internalI ] [j] [s]);
                }
            }
         matrix[j][s] = (keyPrioriMatrix[0][j] * PKjEs) / PEs;
        }
    }
    NSLog(@"6 - KEYS_POSTERIORI_PROBABILITY");
    [ANMath printMatrix:matrix withRows:self.keysCount columns:self.cryptogramsCount];
}

#pragma mark - additional task
- (void) generateRatio {
    ANFloatMatrix2D matrix = _tables[RATIO];
    ANFloatMatrix2D messagesPrioriMatrix = _tables[MESSAGES_PRIORI_PROBABILITY];
    ANFloatMatrix2D keyPosterioriMatrix = _tables[KEYS_POSTERIORI_PROBABILITY];
    ANFloatMatrix2D encryptionMatrix = _tables[ENCRYPTION_TABLE];
    
    for (int i = 0; i < self.keysCount; i++){
        for (int j = 0; j < self.messagesCount; j++){
            int E = (int)encryptionMatrix[i][j];
            float PeK = keyPosterioriMatrix[i][E-1];
            float Pm = messagesPrioriMatrix[0][j];
            matrix[i][j] = PeK / Pm;
        }
    }
    NSLog(@"RATIO");
    [ANMath printMatrix:matrix withRows:self.keysCount columns:self.messagesCount];
}

#pragma mark -
#pragma mark - recalculation
- (void) recalculateDataWhenEncryptionTableChanges {
    [self createFeeFunctionArray];
    
    [self generateMessagesPosterioriProbability];
    [self generatePrioriAndPosterioriMessagesProbabilityDifference];
    [self generatePosterioriKeysProbability];
    [self generateRatio];
}

- (void) recalculateDataWhenMessagesPrioriProbabilityChanges {
    [self generateMessagesPosterioriProbability];
    [self generatePrioriAndPosterioriMessagesProbabilityDifference];
    [self generatePosterioriKeysProbability];
}

- (void) recalculateDataWhenKeysPriotiProbabilityChanges {
    [self generateMessagesPosterioriProbability];
    [self generatePrioriAndPosterioriMessagesProbabilityDifference];
    [self generatePosterioriKeysProbability];
    [self generateRatio];
}

#pragma mark - options
- (void) keyAutoGeneration {
    [self generateKeysPriorTableAutomatically];
    [self recalculateDataWhenKeysPriotiProbabilityChanges];
    [self generateRatio];
}
- (void) keyEqualsGeneration{
    [self generateKeysPrioriTableWithEqualsProbability];
    [self recalculateDataWhenKeysPriotiProbabilityChanges];
    [self generateRatio];
}

- (void) messagesAutoGeneration{
    [self generateMessagesPriorTableAutomatically];
    [self recalculateDataWhenMessagesPrioriProbabilityChanges];
    [self generateRatio];
}
- (void) messagesEqualsGeneration{
    [self generateMessagesPriorTableWithEqualsProbability];
    [self recalculateDataWhenMessagesPrioriProbabilityChanges];
    [self generateRatio];
}

@end
