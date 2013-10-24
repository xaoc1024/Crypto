//
//  ANViewController.m
//  Crypto
//
//  Created by Andriy Zhuk on 11.10.13.
//  Copyright (c) 2013 Andriy Zhuk. All rights reserved.
//

#import "ANViewController.h"
#import "ANCollectionViewCell.h"
#import "ANCryptoForLatinSquare.h"
#import "ANMath.h"

@interface ANViewController ()

@property (nonatomic, assign) float ** matrix;
@property (nonatomic, assign) CGSize matrixSize;
@property (nonatomic, assign) ANSystemModes systemMode;
@property (nonatomic, assign) ANTableType tableType;

@property (nonatomic, strong) ANCryptoForLatinSquare * crypto;
@property (nonatomic, strong) ANCryptoForLatinSquare * cryptoSquare;
@property (nonatomic, strong) ANCryptoForLatinSquare * cryptoRectangle;
@property (nonatomic, strong) ANCryptoForLatinSquare * cryptoThirdCase;

@property (nonatomic, weak) IBOutlet UICollectionView * collectionView;
@property (nonatomic, weak) IBOutlet UIView * theView;

@property (nonatomic, weak) IBOutlet UIButton * firstTableButton;
@property (nonatomic, weak) IBOutlet UIButton * secondTableButton;
@property (nonatomic, weak) IBOutlet UIButton * thirdTableButton;
@property (nonatomic, weak) IBOutlet UIButton * fourthTableButton;
@property (nonatomic, weak) IBOutlet UIButton * fifthTableButton;
@property (nonatomic, weak) IBOutlet UIButton * sixthTableButton;
@property (nonatomic, weak) IBOutlet UIButton * seventhTableButton;

@property (nonatomic, weak) IBOutlet UILabel * sumLabel;
@property (nonatomic, weak) IBOutlet UILabel * sumTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel * mainTitleLabe;

@property (nonatomic,assign) BOOL zeroKeyModeFlag;

@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *buttonsCollection;

@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *horizontalLabelsCollection;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *verticalLabelsCollection;

- (IBAction)squareModeButtonAction:(UIButton *)sender;
- (IBAction)rectangleModeButtonAction:(UIButton *)sender;
- (IBAction)thirdCaseModeButtonAction:(UIButton *)sender;

- (IBAction)encryptionTableButtonAction:(UIButton *)sender;
- (IBAction)messagesPrioriProbabilityTableButtonAction:(UIButton *)sender;
- (IBAction)keysPrioriProbabilityTableButtonAction:(UIButton *)sender;
- (IBAction)messagesPosterioriProbabilityTableButtonAction:(UIButton *)sender;
- (IBAction)prioriPosterioriMessagesDifferenceTableButtonAction:(UIButton *)sender;
- (IBAction)keysPosteriotyProbabilityTableButtonAction:(UIButton *)sender;
- (IBAction)zeroKeysButtonAction:(UIButton *)sender;
@end

int const kMessageNumberForSquare = 10;
int const kMessageNumberForRectangle = 4;
int const kMessageNumberForThirdCase = 4;

int const kKeyNumberForSquare = 10;
int const kKeyNumberForRectangle = 12;
int const kKeyNumberForThirdCase = 5;

int const kCryptogramsNumberForSquare = 10;
int const kCryptogramsNumberForRectangle = 4;
int const kCryptogramsNumberForThirdCase = 5;

@implementation ANViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ANCollectionViewCell" bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:@"Identifier"];
    
    UIImage* selection = [[UIImage imageNamed:@"simpleButtonSelection"]
                    resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    
    for (UIButton * but in self.buttonsCollection){
        [but setBackgroundImage:selection forState:UIControlStateNormal];
    }
    
    self.cryptoSquare = [[ANCryptoForLatinSquare alloc] initWithMessagesCount:kMessageNumberForSquare
                                                                     kesCount:kKeyNumberForSquare
                                                             cryptogramsCount:kCryptogramsNumberForSquare
                                                                      andMode:LATIN_SQUARE];
    self.cryptoRectangle = [[ANCryptoForLatinSquare alloc] initWithMessagesCount:kMessageNumberForRectangle
                                                                        kesCount:kKeyNumberForRectangle
                                                                cryptogramsCount:kCryptogramsNumberForRectangle
                                                                         andMode:LATIN_RECTANGLE];
    self.cryptoThirdCase = [[ANCryptoForLatinSquare alloc] initWithMessagesCount:kMessageNumberForThirdCase
                                                                        kesCount:kKeyNumberForThirdCase
                                                                cryptogramsCount:kCryptogramsNumberForThirdCase
                                                                         andMode:M_LESS_THAN_E];
    self.systemMode = LATIN_SQUARE;
    
    self.collectionView.dataSource = self;
    [self cleanAllLabels];
    [self squareModeButtonAction:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UICollecitonViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (NSInteger)self.matrixSize.height * self.matrixSize.width;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ANCollectionViewCell *cell = (ANCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Identifier"
                                                                                                   forIndexPath:indexPath];
    if (cell == nil){
        cell = [[ANCollectionViewCell alloc] init];
        //        cell = [[[UINib nibWithNibName:@"ANCollectionViewCell" bundle:[NSBundle mainBundle]] instantiateWithOwner:self options:nil] lastObject];
        
    }
    
    cell.delegate = self;
    NSInteger row = indexPath.row;
    int i = row / (int)self.matrixSize.width;
    int j = row - (i * self.matrixSize.width);
    cell.indexI = i;
    cell.indexJ = j;
    
    NSInteger si = 5;
    
    switch (self.tableType) {
        case ENCRYPTION_TABLE:
            cell.infoTextField.text = [NSString stringWithFormat:@"%d", (int)self.matrix[i][j]];
            break;
            
        case MESSAGES_PRIORI_PROBABILITY:
            cell.infoTextField.text = [[NSString stringWithFormat:@"%f",self.matrix[0][row]] substringToIndex:si];
            
            break;
            
        case KEYS_PRIORI_PROBABILITY:
            cell.infoTextField.text = [[NSString stringWithFormat:@"%f", self.matrix[0][row]] substringToIndex:si];
            break;
            
        case MESSAGES_POSTERIORI_PROBABILITY:
            cell.infoTextField.text = [[NSString stringWithFormat:@"%f", self.matrix[i][j]] substringToIndex:si];
            break;
            
        case PRIORI_POSTERIORY_MESSAGES_DIFFERENCE:
            cell.infoTextField.text = [[NSString stringWithFormat:@"%f", self.matrix[i][j]] substringToIndex:si];
            break;
            
        case KEYS_POSTERIORI_PROBABILITY:
            cell.infoTextField.text = [[NSString stringWithFormat:@"%f", self.matrix[i][j]] substringToIndex:si];
            break;
            
        case RATIO:
            cell.infoTextField.text = [[NSString stringWithFormat:@"%f", self.matrix[i][j]] substringToIndex:si];
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - button actions
#pragma mark - mode selection
- (IBAction)squareModeButtonAction:(UIButton *)sender {
    self.systemMode = LATIN_SQUARE;
    self.crypto = self.cryptoSquare;
    [self encryptionTableButtonAction:nil];
}

- (IBAction)rectangleModeButtonAction:(UIButton *)sender {
    self.systemMode = LATIN_RECTANGLE;
    self.crypto = self.cryptoRectangle;
    [self encryptionTableButtonAction:nil];
}

- (IBAction)thirdCaseModeButtonAction:(UIButton *)sender {
    self.systemMode = M_LESS_THAN_E;
    self.crypto = self.cryptoThirdCase;
    [self encryptionTableButtonAction:nil];
}


#pragma mark - table selection
- (IBAction)encryptionTableButtonAction:(UIButton *)sender {
    self.mainTitleLabe.text = @"Таблиця шифрування";
    self.tableType = ENCRYPTION_TABLE;
    switch (self.systemMode) {
        case LATIN_RECTANGLE:
            self.matrixSize = CGSizeMake(kMessageNumberForRectangle, kKeyNumberForRectangle);
            break;
        case LATIN_SQUARE:
            self.matrixSize = CGSizeMake(kMessageNumberForSquare, kKeyNumberForSquare);
            break;
        case M_LESS_THAN_E:
            self.matrixSize = CGSizeMake(kMessageNumberForThirdCase, kKeyNumberForThirdCase);
            break;
            
        default:
            break;
    }
    
    [self cleanAllLabels];
    
    for (int i = 0; i < (int)_matrixSize.width; i++){
        UILabel * label = [self getLabelWithTag:i+1 fromArray:self.horizontalLabelsCollection];
        label.text = [NSString stringWithFormat:@"M%d",i + 1];
    }
    
    for (int i = 0; i < (int)_matrixSize.height; i++ ){
        UILabel * label = [self getLabelWithTag:i+1 fromArray:self.verticalLabelsCollection];
        label.text = [NSString stringWithFormat:@"K%d",i + 1];
    }
    
    self.matrix = self.crypto.tables[ENCRYPTION_TABLE];
    
    CGRect frame = self.collectionView.frame;
    frame.size.width = self.matrixSize.width * 65.0f;
    self.collectionView.frame = frame;
    
    [self.collectionView reloadData];
    [self centeringLabels];
    
}

- (IBAction)messagesPrioriProbabilityTableButtonAction:(UIButton *)sender {
        self.mainTitleLabe.text = @"Апріорні імовірності повідомлень.";
    self.tableType = MESSAGES_PRIORI_PROBABILITY;
    
    switch (self.systemMode) {
        case LATIN_RECTANGLE:
            self.matrixSize = CGSizeMake(kMessageNumberForRectangle, 1);
            break;
        case LATIN_SQUARE:
            self.matrixSize = CGSizeMake(kMessageNumberForSquare, 1);
            break;
        case M_LESS_THAN_E:
            self.matrixSize = CGSizeMake(kMessageNumberForThirdCase, 1);
            break;
            
        default:
            break;
    }

    [self cleanAllLabels];
    
    for (int i = 0; i < (int)_matrixSize.width; i++){
        UILabel * label = [self getLabelWithTag:i+1 fromArray:self.horizontalLabelsCollection];
        label.text = [NSString stringWithFormat:@"M%d",i + 1];
    }
    
    UILabel * label = [self getLabelWithTag:1 fromArray:self.verticalLabelsCollection];
    label.text = @"P";
    self.sumTitleLabel.text = @"Sum";
    self.sumLabel.text = [[NSString stringWithFormat:@"%f", self.crypto.messagePrioriProbabilitySum] substringToIndex:4];
    
    self.matrix = self.crypto.tables[MESSAGES_PRIORI_PROBABILITY];
    
    CGRect frame = self.collectionView.frame;
    frame.size.width = self.matrixSize.width * 65.0f;
    self.collectionView.frame = frame;
    
    [self.collectionView reloadData];
       [self centeringLabels];
    
}

- (IBAction)keysPrioriProbabilityTableButtonAction:(UIButton *)sender {
    self.mainTitleLabe.text = @"Апріорні імовірності ключів.";
    self.tableType = KEYS_PRIORI_PROBABILITY;
    
    switch (self.systemMode) {
        case LATIN_RECTANGLE:
            self.matrixSize = CGSizeMake(kKeyNumberForRectangle, 1);
            break;
        case LATIN_SQUARE:
            self.matrixSize = CGSizeMake(kKeyNumberForSquare, 1);
            break;
        case M_LESS_THAN_E:
            self.matrixSize = CGSizeMake(kKeyNumberForThirdCase, 1);
            break;
            
        default:
            break;
    }
    
    
    [self cleanAllLabels];
    
    for (int i = 0; i < (int)_matrixSize.width; i++){
        UILabel * label = [self getLabelWithTag:i+1 fromArray:self.horizontalLabelsCollection];
        label.text = [NSString stringWithFormat:@"K%d",i + 1];
    }
    
    UILabel * label = [self getLabelWithTag:1 fromArray:self.verticalLabelsCollection];
    label.text = @"P";
    
    self.sumTitleLabel.text = @"Sum";
    self.sumLabel.text = [[NSString stringWithFormat:@"%f", self.crypto.keyPrioriProbabilitySum] substringToIndex:4];
    
    self.matrix = self.crypto.tables[KEYS_PRIORI_PROBABILITY];
    
    CGRect frame = self.collectionView.frame;
    frame.size.width = self.matrixSize.width * 65.0f;
    self.collectionView.frame = frame;
    
    [self.collectionView reloadData];
}

- (IBAction)messagesPosterioriProbabilityTableButtonAction:(UIButton *)sender {
        self.mainTitleLabe.text = @"Апостеріорні імовірності повідомлень.";
    self.tableType = MESSAGES_POSTERIORI_PROBABILITY;
    
    switch (self.systemMode) {
        case LATIN_RECTANGLE:
            self.matrixSize = CGSizeMake(kMessageNumberForRectangle, kCryptogramsNumberForRectangle);
            break;
        case LATIN_SQUARE:
            self.matrixSize = CGSizeMake(kMessageNumberForSquare, kCryptogramsNumberForSquare);
            break;
        case M_LESS_THAN_E:
            self.matrixSize = CGSizeMake(kMessageNumberForThirdCase, kCryptogramsNumberForThirdCase);
            break;
            
        default:
            break;
    }    
    
    [self cleanAllLabels];
    
    for (int i = 0; i < (int)_matrixSize.width; i++){
        UILabel * label = [self getLabelWithTag:i+1 fromArray:self.horizontalLabelsCollection];
        label.text = [NSString stringWithFormat:@"M%d",i + 1];
    }
    
    for (int i = 0; i < (int)_matrixSize.height; i++ ){
        UILabel * label = [self getLabelWithTag:i+1 fromArray:self.verticalLabelsCollection];
        label.text = [NSString stringWithFormat:@"E%d",i + 1];
    }

    self.matrix = self.crypto.tables[MESSAGES_POSTERIORI_PROBABILITY];
    
    CGRect frame = self.collectionView.frame;
    frame.size.width = self.matrixSize.width * 65.0f;
    self.collectionView.frame = frame;
    
    [self.collectionView reloadData];
        [self centeringLabels];
}

 

- (IBAction)prioriPosterioriMessagesDifferenceTableButtonAction:(UIButton *)sender {
        self.mainTitleLabe.text = @"Різиця апріорних та апостеріорних імовірностей.";
    self.tableType = PRIORI_POSTERIORY_MESSAGES_DIFFERENCE;
    
    switch (self.systemMode) {
        case LATIN_RECTANGLE:
            self.matrixSize = CGSizeMake(kMessageNumberForRectangle, kCryptogramsNumberForRectangle);
            break;
        case LATIN_SQUARE:
            self.matrixSize = CGSizeMake(kMessageNumberForSquare, kCryptogramsNumberForSquare);
            break;
        case M_LESS_THAN_E:
            self.matrixSize = CGSizeMake(kMessageNumberForThirdCase, kCryptogramsNumberForThirdCase);
            break;
            
        default:
            break;
    }
    
    [self cleanAllLabels];
    
    for (int i = 0; i < (int)_matrixSize.width; i++){
        UILabel * label = [self getLabelWithTag:i+1 fromArray:self.horizontalLabelsCollection];
        label.text = [NSString stringWithFormat:@"M%d",i + 1];
    }
    
    for (int i = 0; i < (int)_matrixSize.height; i++ ){
        UILabel * label = [self getLabelWithTag:i+1 fromArray:self.verticalLabelsCollection];
        label.text = [NSString stringWithFormat:@"E%d",i + 1];
    }
    
    self.matrix = self.crypto.tables[PRIORI_POSTERIORY_MESSAGES_DIFFERENCE];
    
    CGRect frame = self.collectionView.frame;
    frame.size.width = self.matrixSize.width * 65.0f;
    self.collectionView.frame = frame;
    
    [self.collectionView reloadData];
        [self centeringLabels];
}

- (IBAction)keysPosteriotyProbabilityTableButtonAction:(UIButton *)sender {
    self.mainTitleLabe.text = @"Апостеріорні імовірності ключів.";
    self.tableType = KEYS_POSTERIORI_PROBABILITY;
    
    switch (self.systemMode) {
        case LATIN_RECTANGLE:
            self.matrixSize = CGSizeMake(kCryptogramsNumberForRectangle, kKeyNumberForRectangle);
            break;
        case LATIN_SQUARE:
            self.matrixSize = CGSizeMake(kCryptogramsNumberForSquare, kKeyNumberForSquare);
            break;
        case M_LESS_THAN_E:
            self.matrixSize = CGSizeMake(kCryptogramsNumberForThirdCase, kKeyNumberForThirdCase);
            break;
            
        default:
            break;
    }
    
    [self cleanAllLabels];
    
    for (int i = 0; i < (int)_matrixSize.width; i++){
        UILabel * label = [self getLabelWithTag:i+1 fromArray:self.horizontalLabelsCollection];
        label.text = [NSString stringWithFormat:@"E%d",i + 1];
    }
    
    for (int i = 0; i < (int)_matrixSize.height; i++ ){
        UILabel * label = [self getLabelWithTag:i+1 fromArray:self.verticalLabelsCollection];
        label.text = [NSString stringWithFormat:@"K%d",i + 1];
    }
    
    self.matrix = self.crypto.tables[KEYS_POSTERIORI_PROBABILITY];
    
    CGRect frame = self.collectionView.frame;
    frame.size.width = self.matrixSize.width * 65.0f;
    self.collectionView.frame = frame;
    
    [self.collectionView reloadData];
    [self centeringLabels];
}

- (IBAction)ratioButtonAction:(UIButton *)sender {
    self.mainTitleLabe.text = @"Відношення.";
    self.tableType = RATIO;
    
    switch (self.systemMode) {
        case LATIN_RECTANGLE:
            self.matrixSize = CGSizeMake(kMessageNumberForRectangle, kKeyNumberForRectangle);
            break;
        case LATIN_SQUARE:
            self.matrixSize = CGSizeMake(kMessageNumberForSquare, kKeyNumberForSquare);
            break;
        case M_LESS_THAN_E:
            self.matrixSize = CGSizeMake(kMessageNumberForThirdCase, kKeyNumberForThirdCase);
            break;
            
        default:
            break;
    }
    
    [self cleanAllLabels];
    
    for (int i = 0; i < (int)_matrixSize.width; i++){
        UILabel * label = [self getLabelWithTag:i+1 fromArray:self.horizontalLabelsCollection];
        label.text = [NSString stringWithFormat:@"M%d",i + 1];
    }
    
    for (int i = 0; i < (int)_matrixSize.height; i++ ){
        UILabel * label = [self getLabelWithTag:i+1 fromArray:self.verticalLabelsCollection];
        label.text = [NSString stringWithFormat:@"K%d",i + 1];
    }
    
    self.matrix = self.crypto.tables[RATIO];
    
    CGRect frame = self.collectionView.frame;
    frame.size.width = self.matrixSize.width * 65.0f;
    self.collectionView.frame = frame;
    
    [self.collectionView reloadData];
}

#pragma mark - option action
- (IBAction)autoGeneration:(UIButton *)sender {
    switch (self.tableType) {
        case KEYS_PRIORI_PROBABILITY:
            [self.crypto keyAutoGeneration];
            [self keysPrioriProbabilityTableButtonAction:nil];
            break;
            
        case MESSAGES_PRIORI_PROBABILITY:
            [self.crypto messagesAutoGeneration];
            [self messagesPrioriProbabilityTableButtonAction:nil];
            break;
            
        default:
            break;
    }
}

- (IBAction)equalGeneration:(UIButton *)sender{
    switch (self.tableType) {
        case KEYS_PRIORI_PROBABILITY:
            [self.crypto keyEqualsGeneration];
            [self keysPrioriProbabilityTableButtonAction:nil];
            break;
            
        case MESSAGES_PRIORI_PROBABILITY:
            [self.crypto messagesEqualsGeneration];
            [self messagesPrioriProbabilityTableButtonAction:nil];
            break;
            
        default:
            break;
    }
}

- (IBAction)zeroKeysButtonAction:(UIButton *)sender {
    if (self.tableType == KEYS_PRIORI_PROBABILITY){
        self.zeroKeyModeFlag = !self.zeroKeyModeFlag;
        sender.selected = self.zeroKeyModeFlag;
    }
}

#pragma mark - supporting methods
- (UILabel *)getLabelWithTag:(NSInteger) tag fromArray:(NSArray *)array {
    for (UILabel * label in array){
        if (label.tag == tag){
            return label;
        }
    }
    return nil;
}

- (void)centeringLabels {
}
- (void) cleanAllLabels{
    for (UILabel * label in self.horizontalLabelsCollection){
        label.text = @"";
    }
    for (UILabel * label in self.verticalLabelsCollection){
        label.text = @"";
    }
    self.sumLabel.text = @"";
    self.sumTitleLabel.text = @"";
}
#pragma mark - ANCollectionViewCell delegate
- (void) collectionViewCell:(ANCollectionViewCell *)cell didChangeText :(NSString *)text{
    int i = cell.indexI;
    int j = cell.indexJ;
    if (text.length == 0) {
        return;
    }
    if (self.tableType == ENCRYPTION_TABLE){
        self.matrix[i][j] = (float)[text integerValue];
    } else {
        self.matrix[i][j] = [text floatValue];
    }
    
    switch (self.tableType) {
        case ENCRYPTION_TABLE:
            [self.crypto recalculateDataWhenEncryptionTableChanges];
            [self encryptionTableButtonAction:nil];
            break;
            
        case MESSAGES_PRIORI_PROBABILITY:
            [self.crypto recalculateDataWhenMessagesPrioriProbabilityChanges];
            [self messagesPrioriProbabilityTableButtonAction:nil];
            break;
            
        case KEYS_PRIORI_PROBABILITY:
            if (self.zeroKeyModeFlag){
                [self.crypto zeroKeyMode];
            }
            [self.crypto recalculateDataWhenKeysPriotiProbabilityChanges];
            [self keysPrioriProbabilityTableButtonAction:nil];
            break;
            
        case MESSAGES_POSTERIORI_PROBABILITY:
            [self messagesPosterioriProbabilityTableButtonAction:nil];
            break;
            
        case PRIORI_POSTERIORY_MESSAGES_DIFFERENCE:
            [self prioriPosterioriMessagesDifferenceTableButtonAction:nil];
            break;
            
        case KEYS_POSTERIORI_PROBABILITY:
            [self keysPosteriotyProbabilityTableButtonAction:nil];
            break;
            
        default:
            break;
    }
}

#pragma mark - UITextView delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    textField.inputView = dummyView;
    return YES;
}
@end
