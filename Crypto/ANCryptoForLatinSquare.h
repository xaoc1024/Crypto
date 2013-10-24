//
//  ANCrypto.h
//  Crypto
//
//  Created by Andriy Zhuk on 09.10.13.
//  Copyright (c) 2013 Andriy Zhuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANMath.h"

typedef enum {
    ENCRYPTION_TABLE = 0,
    MESSAGES_PRIORI_PROBABILITY,
    KEYS_PRIORI_PROBABILITY,
    MESSAGES_POSTERIORI_PROBABILITY,
    PRIORI_POSTERIORY_MESSAGES_DIFFERENCE,
    KEYS_POSTERIORI_PROBABILITY,
    RATIO,
    NUM_OF_TABLES
} ANTableType;

@interface ANCryptoForLatinSquare : NSObject
@property(nonatomic, assign) void ** tables;
- (id)initWithSize:(NSInteger)size;
- (id) initWithMessagesCount:(NSInteger) messagesCount
                    kesCount:(NSInteger) keysCount
            cryptogramsCount:(NSInteger) cryptogramsCount
                     andMode:(ANSystemModes) systemMode;

- (float) messagePrioriProbabilitySum;
- (float) keyPrioriProbabilitySum;
- (void) recalculateDataWhenEncryptionTableChanges;
- (void) recalculateDataWhenMessagesPrioriProbabilityChanges;
- (void) recalculateDataWhenKeysPriotiProbabilityChanges;
- (void) zeroKeyMode;

- (void) keyAutoGeneration;
- (void) keyEqualsGeneration;

- (void) messagesAutoGeneration;
- (void) messagesEqualsGeneration;

@end
