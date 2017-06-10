//
//  ViewController.h
//  BAC
//
//  Created by Trent Callan on 8/26/13.
//  Copyright (c) 2013 Trent Callan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Beer.h"
#import "Container.h"
#import "TFHpple.h"

@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;
@property (strong, nonatomic) IBOutlet UITextField *timeTextField;
@property (strong, nonatomic) IBOutlet UILabel *BACLabel;
@property (strong, nonatomic) IBOutlet UILabel *selectedBeerLabel;
@property (strong, nonatomic) IBOutlet UILabel *selectedSizeLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *genderSelectControl;
@property (strong, nonatomic) IBOutlet UITableView *consumedBeerTableView;
@property (strong, nonatomic) IBOutlet UITableView *beerListTableView;
@property (strong, nonatomic) IBOutlet UITableView *sizeTableView;
@property (strong, nonatomic) IBOutlet UITextField *numberTextField;
@property (strong, nonatomic) IBOutlet UIButton *dismissKeyboardButton;
@property (weak, nonatomic) IBOutlet UIButton *setStartTimeBtn;
@property (strong, nonatomic) UIAlertView* alert;
@property (strong, nonatomic) NSArray* descriptionArray;
@property (strong, nonatomic) NSArray* volumeArray;
@property (strong, nonatomic) NSMutableArray* sizeArray;
@property (strong, nonatomic) NSMutableArray* consumedBeerArray;
@property (strong, nonatomic) NSMutableArray* beerListArray;
@property NSDate* timeStarted;
@property (nonatomic) double gramsOfAlcoholConsumed;
@property (nonatomic) double timeToDrive;
@property (nonatomic) double timeToZero ;
@property int selectedBeer;
@property int selectedSize;

- (IBAction)selectBeerButtonPressed:(id)sender;
- (IBAction)selectSizeButtonPressed:(id)sender;
- (IBAction)resetButtonPressed:(id)sender;
- (IBAction)addButtonPressed:(id)sender;
- (IBAction)updateButtonPressed:(id)sender;
- (IBAction)dismissKeyboardBackgroundPressed:(id)sender;
- (IBAction)setStartTimeButtonPressed:(id)sender;
- (void) calculateBAC;
- (void) parseBrand;
- (void) parseOthers;
- (void) sortAZ;
- (void) sizeArrayBuilder;
- (void) checkForDrinkingLevelWithBAC: (double)decimalBAC TimeToDrive:(double)tmeToDrive AndTimeToZero:(double) tmeToZero;
@end
