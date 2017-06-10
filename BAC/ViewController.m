//
//  ViewController.m
//  BAC
//
//  Created by Trent Callan on 8/26/13.
//  Copyright (c) 2013 Trent Callan. All rights reserved.
//

// add ability to delete only some ounces of beer compared to removing entire object
// add connection test to scrape
// add footer for credit to website
// add button to set beginning time and then on update BAC press calculate BAC based on time differential from beginning.******
// on reset button press show alert to confirm reset *********

// offline test is acivated 3 places to un-comment

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize weightTextField;
@synthesize timeTextField;
@synthesize BACLabel;
@synthesize gramsOfAlcoholConsumed;
@synthesize consumedBeerArray;
@synthesize beerListArray;
@synthesize genderSelectControl;
@synthesize consumedBeerTableView;
@synthesize beerListTableView;
@synthesize selectedBeer;
@synthesize selectedSize;
@synthesize selectedBeerLabel;
@synthesize selectedSizeLabel;
@synthesize sizeTableView;
@synthesize sizeArray;
@synthesize descriptionArray;
@synthesize volumeArray;
@synthesize numberTextField;
@synthesize alert;
@synthesize dismissKeyboardButton;
@synthesize timeToDrive;
@synthesize timeToZero;
@synthesize timeStarted;
@synthesize setStartTimeBtn;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // test with no net connection
	// load persistance
    
    NSData* decodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"consumedBeerArray"];
    NSArray* tmpArray = [NSKeyedUnarchiver unarchiveObjectWithData:decodedObject];
    consumedBeerArray = [tmpArray mutableCopy];
    timeStarted = [[NSUserDefaults standardUserDefaults] objectForKey:@"timeStarted"];
    NSString* tmpWeight = [[NSUserDefaults standardUserDefaults] objectForKey:@"weightText"];
    if (!consumedBeerArray) {
        consumedBeerArray = [[NSMutableArray alloc] init];
    }
    if (!tmpWeight) {
        tmpWeight = @"";
    }
    weightTextField.text = tmpWeight;
    
    alert = [[UIAlertView alloc] initWithTitle:@"Required Information" message:@"Please Enter All the Required Information" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [self parseBrand];
    [self parseOthers];
    [self sizeArrayBuilder];
    [self sortAZ];
}

#pragma mark IBAction Methods
- (IBAction)selectBeerButtonPressed:(id)sender {
    self.beerListTableView.hidden = NO;
    [self dismissKeyboardBackgroundPressed:self];
}

- (IBAction)selectSizeButtonPressed:(id)sender {
    self.sizeTableView.hidden = NO;
    [self dismissKeyboardBackgroundPressed:self];
    [sizeTableView reloadData];
}

- (IBAction)resetButtonPressed:(id)sender {
    weightTextField.text = @"";
    numberTextField.text = @"";
    timeTextField.text = @"";
    BACLabel.text = @"";
    selectedBeerLabel.text = @"Please Select a Beer";
    selectedSizeLabel.text = @"Please Select a Size";
    setStartTimeBtn.hidden = NO;
    [[NSUserDefaults standardUserDefaults]setObject:[weightTextField text] forKey:@"weightText"];
    [consumedBeerArray removeAllObjects];
    [consumedBeerTableView reloadData];
    timeStarted = NULL;
    // persist reset
    NSArray* endcodedArray = [NSArray arrayWithArray:consumedBeerArray];
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject:endcodedArray];
    [[NSUserDefaults standardUserDefaults] setObject:encodedData forKey:@"consumedBeerArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)addButtonPressed:(id)sender {
    if ([weightTextField.text isEqualToString:@""] || [timeTextField.text isEqualToString:@""]) {
        [alert show];
    }
    else{
        if ([selectedBeerLabel.text isEqualToString:@"Please Select a Beer"] || [selectedSizeLabel.text isEqualToString:@"Please Select a Size"]) {
            [alert show];
        }
        else{
            int loop = 0;
            double addOunces = [[numberTextField text] doubleValue] * [[sizeArray objectAtIndex:selectedSize] ouncesHeld];
            
            for (int i =0; i<[consumedBeerArray count]; i++) {
                if ([[[beerListArray objectAtIndex:selectedBeer] name] isEqualToString:[[consumedBeerArray objectAtIndex:i] name]]) {
                    [[consumedBeerArray objectAtIndex:i] setOuncesConsumed: ([[consumedBeerArray objectAtIndex:i] ouncesConsumed] + addOunces)];
                    [self sortAZ];
                    [self calculateBAC];
                    loop++;
                    NSArray* endcodedArray = [NSArray arrayWithArray:consumedBeerArray];
                    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject:endcodedArray];
                    [[NSUserDefaults standardUserDefaults] setObject:encodedData forKey:@"consumedBeerArray"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[weightTextField text] forKey:@"weightText"];
                    return;
                }
                else{
                    loop++;
                }
            }
            if (loop == [consumedBeerArray count]){
                Beer* temp = [beerListArray objectAtIndex:selectedBeer];
                temp.ouncesConsumed = addOunces;
                
                [consumedBeerArray addObject: temp];
                [self sortAZ];
                [self calculateBAC];
            }
        }
        // clear number text field
        //numberTextField.text = @"";
    }
    // persist start
    NSArray* endcodedArray = [NSArray arrayWithArray:consumedBeerArray];
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject:endcodedArray];
    [[NSUserDefaults standardUserDefaults] setObject:encodedData forKey:@"consumedBeerArray"];
    [[NSUserDefaults standardUserDefaults] setObject:[weightTextField text] forKey:@"weightText"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
}

- (IBAction)updateButtonPressed:(id)sender {
    [self calculateBAC];
}

- (IBAction)dismissKeyboardBackgroundPressed:(id)sender {
    [weightTextField resignFirstResponder];
    [timeTextField resignFirstResponder];
    [numberTextField resignFirstResponder];
}

- (IBAction)setStartTimeButtonPressed:(id)sender {
    if(!timeStarted){
        timeStarted = timeStarted = [NSDate date];
        setStartTimeBtn.hidden = YES;
        [[NSUserDefaults standardUserDefaults] setObject:timeStarted forKey:@"timeStarted"];
    }
    
}

#pragma mark User Methods

- (void) calculateBAC{
    UIAlertView* emptyArray = [[UIAlertView alloc] initWithTitle:@"No Beers" message:@"You Haven't Drank any Beers. Or Have You Drank too many Beers?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    double weight = (([[weightTextField text] doubleValue])*.453592);
    double time = (([[timeTextField text] doubleValue])/60);
    double alcohol = 0;
    double ratio = 0;
    double decimalBAC;
    
    if ([consumedBeerArray count] == 0) {
        [emptyArray show];
    }
    else{
        
        for (int i =0; i < [consumedBeerArray count]; i++) {
            alcohol = [[consumedBeerArray objectAtIndex:i] totalOuncesOfPureAlcoholConsumed] + alcohol;
        }
        
        ratio = genderSelectControl.selectedSegmentIndex == 0 ? .58 : .5;
        
        decimalBAC=((23.36/(weight*ratio*1000))*(80.6*alcohol))-(0.01789*time);
        // time to drive at .017 metabolized per hour
        
        timeToDrive = (decimalBAC - .079)/.01789;
        timeToZero = decimalBAC/.01789;
        if (timeToZero <= 0) {
            timeToZero = 0;
        }
        if (timeToDrive <= 0) {
            timeToDrive = 0;
        }
        
        NSLog(@"Time to Zero BAC = %.2f", timeToZero);
        
        if (decimalBAC <= 0 ) {
            BACLabel.text = @"BAC is: .001 %";
        }
        else{
            BACLabel.text = [NSString stringWithFormat:@"BAC is: %.3f %%",decimalBAC,nil];
        }
        [self checkForDrinkingLevelWithBAC:decimalBAC TimeToDrive:timeToDrive AndTimeToZero:timeToZero];
    }
}

- (void) checkForDrinkingLevelWithBAC:(double)decimalBAC TimeToDrive:(double)tmeToDrive AndTimeToZero:(double)tmeToZero{
    UIAlertView* dontDrive = [[UIAlertView alloc] initWithTitle:@"Don't Drive" message:[[NSString alloc] initWithFormat: @"Your BAC is Way Above Legal Limits. Call a Cab.                      Time to Drive: %.1f Hours            Time to Zero BAC: %.1f Hours", timeToDrive,timeToZero] delegate:self cancelButtonTitle:@"Call a Cab" otherButtonTitles:nil, nil];
    UIAlertView* suggestedDontDrive = [[UIAlertView alloc] initWithTitle:@"Shouldn't Drive" message: [[NSString alloc] initWithFormat: @"Your BAC is over the Legal Limit. You Should Not Drive Home.               Time to Drive: %.1f Hours         Time to Zero BAC: %.1f Hours", timeToDrive,timeToZero] delegate:self cancelButtonTitle:@"Call a Friend" otherButtonTitles:nil, nil];
    UIAlertView* nearingLimit = [[UIAlertView alloc] initWithTitle:@"Nearing Limit" message: [[NSString alloc]initWithFormat: @"You are Nearing the Legal Limit. Slow Down. You should not Drive.                                Time to Zero BAC: %.1f Hours",timeToZero] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    UIAlertView* halfwayLimit = [[UIAlertView alloc] initWithTitle:@"Halfway Point" message: [[NSString alloc] initWithFormat: @"You Are Over Halfway to the Legal Limit.                                           Time to Zero BAC: %.1f Hours", timeToZero] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    if(decimalBAC < .04){
    }
    else if((decimalBAC >= .08 && decimalBAC < .12)){
        [suggestedDontDrive show];
    }
    else if (decimalBAC >= .06 && decimalBAC < .08){
        [nearingLimit show];
    }
    else if(decimalBAC >= .04 && decimalBAC < .06){
        [halfwayLimit show];
    }
    else{
        [dontDrive show];
    }
}

#pragma mark HTML Scraping Functions

- (void) parseBrand{
    NSURL* beerList = [NSURL URLWithString:@"http://getdrunknotfat.com/beer-list"];
    NSLog(@"Beer List URL = %@", beerList);
    NSData* htmlData = [NSData dataWithContentsOfURL:beerList];
    int count = 0;
    TFHpple* brandParser = [TFHpple hppleWithHTMLData:htmlData];
    
    NSString* brandQueryString = @"//td[@class='brand']";
    NSArray* nodesArray = [brandParser searchWithXPathQuery:brandQueryString];
    beerListArray = [[NSMutableArray alloc] init];
    for (TFHppleElement* element in nodesArray) {
        if (count == 0) {
            count++;
            continue;
        }
        Beer* beer = [[Beer alloc] initWithName:[[element firstChild] content]];
        [beerListArray addObject:beer];
        count++;
    }
    
    
    [self.consumedBeerTableView reloadData];
}
- (void) parseOthers{
    
    NSURL* beerList = [NSURL URLWithString:@"http://getdrunknotfat.com/beer-list"];
    NSData* htmlData = [NSData dataWithContentsOfURL:beerList];
    int count =0;
    TFHpple* otherParser = [TFHpple hppleWithHTMLData:htmlData];
    
    NSString* brandQueryString = @"//td[@class='mytable']";
    NSArray* nodesArray = [otherParser searchWithXPathQuery:brandQueryString];
    
    for (TFHppleElement* element in nodesArray) {
        if (count != 0 && count%3 == 0) {
            
            double tempABV = [[[element firstChild] content] doubleValue]/100;
            
            [[beerListArray objectAtIndex:((count/3)-1)] setAbvDecimal:tempABV];
        }
        count++;
    }
}


- (void) sortAZ{
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSSortDescriptor *sizeSort = [NSSortDescriptor sortDescriptorWithKey:@"information" ascending:YES];
    [beerListArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    [consumedBeerArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    [sizeArray sortUsingDescriptors:[NSArray arrayWithObject:sizeSort]];
    [self.consumedBeerTableView reloadData];
}

-(void) sizeArrayBuilder{
    NSString* descPath = [[NSBundle mainBundle] pathForResource:@"ContainersDescription" ofType:@"plist"];
    NSString* volumePath = [[NSBundle mainBundle] pathForResource:@"ContainersVolume" ofType:@"plist"];
    
    descriptionArray =[[NSArray alloc] initWithContentsOfFile:descPath];
    volumeArray = [[NSArray alloc] initWithContentsOfFile:volumePath];
    sizeArray = [[NSMutableArray alloc] init];
    
    for (int i =0; i < [descriptionArray count]; i++) {
        Container* temp = [[Container alloc] initWithInformation:[descriptionArray objectAtIndex:i] OuncesHeld:[[volumeArray objectAtIndex:i] doubleValue]];
        
        [sizeArray addObject:temp];
    }
    [sizeTableView reloadData];
    
}


#pragma mark UITableView DataSource Functions

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if (tableView == self.consumedBeerTableView) {
        
        cell.textLabel.text = [[consumedBeerArray objectAtIndex:indexPath.row] name];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Total Ounces Consumed = %.1f", [[consumedBeerArray objectAtIndex:indexPath.row] ouncesConsumed]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.image = [[consumedBeerArray objectAtIndex:indexPath.row] img];
        
    }
    else if (tableView == self.beerListTableView){
        
        // offline test
        if([beerListArray count] == 1){
            cell.textLabel.text = [beerListArray objectAtIndex:0];
            cell.detailTextLabel.text = @"Connect To the Internet and Try Again";
            return cell;
        }
        
        cell.textLabel.text = [[beerListArray objectAtIndex:indexPath.row] name];
        cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"ABV is %.1f %%",[[beerListArray objectAtIndex:indexPath.row] abvDecimal] * 100,nil];
        cell.imageView.image = [[beerListArray objectAtIndex:indexPath.row]img];
    }
    else{
        cell.textLabel.text = [[sizeArray objectAtIndex:indexPath.row] information];
        //cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"Ounces Held = %.1f",[[sizeArray objectAtIndex:indexPath.row] ouncesHeld]];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.consumedBeerTableView) {
        return [consumedBeerArray count];
    }
    else if(tableView == self.beerListTableView){
        if([beerListArray count] == 0){
                         [beerListArray addObject:@"Connection Failed"];
        }
        
        return [beerListArray count];
    }
    else{
        return [sizeArray count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(tableView == self.consumedBeerTableView){
        return @"Beers Consumed";
    }
    else if (tableView == self.beerListTableView){
        return @"Beer List";
    }
    else{
        return@"Container List";
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.consumedBeerTableView) {
        return YES;
    }
    return NO;
}
#pragma mark UITableView Delegate Functions
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.consumedBeerTableView){
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            if ([consumedBeerArray count] == 1) {
                BACLabel.text = @"";
            }
            else{
                [self calculateBAC];
            }
            [consumedBeerArray removeObjectAtIndex:indexPath.row];
            [tableView reloadData];
            
            NSArray* endcodedArray = [NSArray arrayWithArray:consumedBeerArray];
            NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject:endcodedArray];
            [[NSUserDefaults standardUserDefaults] setObject:encodedData forKey:@"consumedBeerArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.beerListTableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        self.beerListTableView.hidden = YES;
        // offline test
        if ([beerListArray count]== 1) {
            
        
        
            NSLog(@"Connection Failed on Scrape for Beer List Table View");
            return;
        }
        //else{
            selectedBeer = indexPath.row;
            selectedBeerLabel.text = [[beerListArray objectAtIndex:selectedBeer] name];
        //}
    }
    else if (tableView == self.sizeTableView){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        selectedSize = indexPath.row;
        selectedSizeLabel.text = [[sizeArray objectAtIndex:selectedSize] information];
        self.sizeTableView.hidden = YES;
    }
}

- (void)viewDidUnload {
    [self setConsumedBeerTableView:nil];
    [self setBeerListTableView:nil];
    [self setSelectedBeerLabel:nil];
    [self setSelectedSizeLabel:nil];
    [self setSizeTableView:nil];
    [self setNumberTextField:nil];
    [self setDismissKeyboardButton:nil];
    [super viewDidUnload];
}
@end
