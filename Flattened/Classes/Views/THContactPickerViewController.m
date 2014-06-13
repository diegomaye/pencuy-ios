//
//  ContactPickerViewController.m
//  ContactPicker
//
//  Created by Tristan Himmelman on 11/2/12.
//  Copyright (c) 2012 Tristan Himmelman. All rights reserved.
//

#import "THContactPickerViewController.h"
#import <AddressBook/AddressBook.h>
#import "THContact.h"
#import "Utils.h"
#import "PencuyFetcher.h"
#import "GraphicUtils.h"
#import "SIAlertView.h"

UIBarButtonItem *barButton;

@interface THContactPickerViewController ()

@property (nonatomic, assign) ABAddressBookRef addressBookRef;

@end

//#define kKeyboardHeight 216.0
#define kKeyboardHeight 0.0

@implementation THContactPickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStyleBordered target:self action:@selector(removeAllContacts:)];
    
    if(![Utils isVersion6AndBelow])
        self.navigationController.navigationBar.translucent = NO;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:17];
    
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame = CGRectMake(0, 0, 40, 30);
    [btnCancel setImage:[UIImage imageNamed:@"navigation-btn-cancel"] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(actionCancel:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnCancel];
    
    UIButton *btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSend.frame = CGRectMake(0, 0, 40, 30);
    [btnSend setImage:[UIImage imageNamed:@"navigation-btn-send"] forState:UIControlStateNormal];
    [btnSend addTarget:self action:@selector(actionSend:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSend];
    
    titleLabel.text = NSLocalizedString(@"INVITE FRIENDS",nil);
    
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    // Initialize and add Contact Picker View
    self.contactPickerView = [[THContactPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    self.contactPickerView.delegate = self;
    [self.contactPickerView setPlaceholderString:NSLocalizedString(@"Type your buddy name",nil)];
    [self.view addSubview:self.contactPickerView];
    self.lblDescripcionInvitarFacebook = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.view.frame.size.width - 40, 100)];
    self.lblDescripcionInvitarFacebook.layer.zPosition = 1;
    self.lblDescripcionInvitarFacebook.lineBreakMode = NSLineBreakByWordWrapping;
    self.lblDescripcionInvitarFacebook.numberOfLines = 3;
    self.lblDescripcionInvitarFacebook.text = NSLocalizedString(@"If you not found your friends in the list you can invite them play My Prediction with facebook with our web app ;)", nil);
    self.lblDescripcionInvitarFacebook.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:14];
    self.lblDescripcionInvitarFacebook.textAlignment = NSTextAlignmentCenter;
    self.lblDescripcionInvitarFacebook.textColor = [GraphicUtils colorPumpkin];
    [self.view addSubview:self.lblDescripcionInvitarFacebook];
    
    self.btnInvitarAmigosFacebook = [[UIButton alloc] initWithFrame:CGRectMake(20, 300, self.view.frame.size.width-40, 50)];
    self.btnInvitarAmigosFacebook.layer.zPosition = 1;
    [self.btnInvitarAmigosFacebook setBackgroundImage:[UIImage imageNamed:@"button-green"] forState:UIControlStateNormal] ;
    [self.btnInvitarAmigosFacebook setTitle:NSLocalizedString(@"FACEBOOK FRIENDS",nil) forState:UIControlStateNormal];
    self.btnInvitarAmigosFacebook.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:14];
    self.btnInvitarAmigosFacebook.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.btnInvitarAmigosFacebook.hidden=YES;
    [self.view addSubview:self.btnInvitarAmigosFacebook];
    
    
    // Fill the rest of the view with the table view
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.contactPickerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.contactPickerView.frame.size.height - kKeyboardHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.layer.zPosition = 2;
    self.contactPickerView.layer.zPosition = 3;
    [self.tableView registerNib:[UINib nibWithNibName:@"THContactPickerTableViewCell" bundle:nil] forCellReuseIdentifier:@"ContactCell"];
    self.tableView.hidden = YES;
    [self.view insertSubview:self.tableView belowSubview:self.contactPickerView];
}


- (void)actionCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)actionSend:(id)sender {
 
    NSMutableString* errorMessage = [NSMutableString string];
    NSMutableString* successMessage = [NSMutableString string];
    for (THContact* contact in self.selectedContacts) {
        NSError *error;
        NSMutableDictionary *diccionario= [NSMutableDictionary new];
        [diccionario setValue:[NSNumber numberWithInt:[self.idPenca intValue]] forKey:@"idPenca"];
        [diccionario setValue:contact.idUsuario forKey:@"invitado"];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:diccionario
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        NSDictionary *devolucion = [PencuyFetcher multiFetcherSync:[PencuyFetcher URLtoCreateInvitacion]
                                                          withHTTP:@"POST"
                                                          withData:jsonData];
        if ([devolucion valueForKey:@"status"] && [[devolucion valueForKey:@"status"] isEqualToString:@"ERROR"]) {
            [errorMessage appendString:[NSString stringWithFormat:@"%@%@\n",NSLocalizedString([devolucion valueForKey:@"message"], nil),contact.firstName]];
        }
        else{
            [successMessage appendString:[NSString stringWithFormat:@"%@%@%@\n",NSLocalizedString(@"Your buddy ", nil),contact.firstName, NSLocalizedString(@" was invited successfully", nil)]];
        }
    }
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:NSLocalizedString(@"Invitations", nil) andMessage:[NSString stringWithFormat:@"%@%@",successMessage, errorMessage]];
    
    [alertView addButtonWithTitle:@"Ok"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              [self actionCancel:sender];
                          }];
    
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat topOffset = 0;
    if ([self respondsToSelector:@selector(topLayoutGuide)]){
        topOffset = self.topLayoutGuide.length;
    }
    CGRect frame = self.contactPickerView.frame;
    frame.origin.y = topOffset;
    self.contactPickerView.frame = frame;
    [self adjustTableViewFrame:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)adjustTableViewFrame:(BOOL)animated {
    CGRect frame = self.tableView.frame;
    // This places the table view right under the text field
    frame.origin.y = self.contactPickerView.frame.size.height;
    // Calculate the remaining distance
    frame.size.height = self.view.frame.size.height - self.contactPickerView.frame.size.height - kKeyboardHeight;
    
    if(animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        self.tableView.frame = frame;
        
        [UIView commitAnimations];
    }
    else{
        self.tableView.frame = frame;
    }
}



#pragma mark - UITableView Delegate and Datasource functions

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredContacts.count;
}

- (CGFloat)tableView: (UITableView*)tableView heightForRowAtIndexPath: (NSIndexPath*) indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get the desired contact from the filteredContacts array
    THContact *contact = [self.filteredContacts objectAtIndex:indexPath.row];
    
    // Initialize the table view cell
    NSString *cellIdentifier = @"ContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Get the UI elements in the cell;
    UILabel *contactNameLabel = (UILabel *)[cell viewWithTag:101];
    UILabel *mobilePhoneNumberLabel = (UILabel *)[cell viewWithTag:102];
    UIImageView *contactImage = (UIImageView *)[cell viewWithTag:103];
    UIImageView *checkboxImageView = (UIImageView *)[cell viewWithTag:104];
    
    // Assign values to to US elements
    contactNameLabel.text = [contact fullName];
    mobilePhoneNumberLabel.text = contact.email;
    if(contact.image) {
        contactImage.image = contact.image;
    }
    contactImage.layer.masksToBounds = YES;
    contactImage.layer.cornerRadius = 20;
    
    // Set the checked state for the contact selection checkbox
    UIImage *image;
    if ([self.selectedContacts containsObject:[self.filteredContacts objectAtIndex:indexPath.row]]){
        //cell.accessoryType = UITableViewCellAccessoryCheckmark;
        image = [UIImage imageNamed:@"icon-checkbox-selected-green-25x25"];
    } else {
        //cell.accessoryType = UITableViewCellAccessoryNone;
        image = [UIImage imageNamed:@"icon-checkbox-unselected-25x25"];
    }
    checkboxImageView.image = image;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Hide Keyboard
    [self.contactPickerView resignKeyboard];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // This uses the custom cellView
    // Set the custom imageView
    THContact *user = [self.filteredContacts objectAtIndex:indexPath.row];
    UIImageView *checkboxImageView = (UIImageView *)[cell viewWithTag:104];
    UIImage *image;
    
    if ([self.selectedContacts containsObject:user]){ // contact is already selected so remove it from ContactPickerView
        //cell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectedContacts removeObject:user];
        [self.contactPickerView removeContact:user];
        // Set checkbox to "unselected"
        image = [UIImage imageNamed:@"icon-checkbox-unselected-25x25"];
    } else {
        // Contact has not been selected, add it to THContactPickerView
        //cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedContacts addObject:user];
        [self.contactPickerView addContact:user withName:user.fullName];
        // Set checkbox to "selected"
        image = [UIImage imageNamed:@"icon-checkbox-selected-green-25x25"];
    }
    
    // Enable Done button if total selected contacts > 0
    if(self.selectedContacts.count > 0) {
        barButton.enabled = TRUE;
    }
    else
    {
        barButton.enabled = FALSE;
    }
    
    // Update window title
    self.title = [NSString stringWithFormat:@"Add Members (%lu)", (unsigned long)self.selectedContacts.count];
    
    // Set checkbox image
    checkboxImageView.image = image;
    // Reset the filtered contacts
    self.filteredContacts = [NSArray new];
    self.tableView.hidden = YES;
    // Refresh the tableview
    [self.tableView reloadData];
}

#pragma mark - THContactPickerTextViewDelegate

- (void)contactPickerTextViewDidChange:(NSString *)textViewText {
    if ([textViewText isEqualToString:@""]){
        self.tableView.hidden = YES;
        self.contacts = [NSArray new];
        self.filteredContacts = self.contacts;
    } else {
        //PencuyFetcher
        [PencuyFetcher multiFetcher:[PencuyFetcher URLtoQuerySystemUsers:self.idPenca withSuggest:textViewText] withHTTP:@"GET" withHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if ([data length] > 0 && connectionError==nil) {
                NSArray *users= [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                NSMutableArray *mutableContacts = [NSMutableArray arrayWithCapacity:users.count];
                for (NSDictionary* usuario in users) {
                    THContact *contact = [[THContact alloc] init];
                    NSString* firstName = [usuario valueForKeyPath:@"nombreCompleto"];
                    NSString* email = [usuario valueForKeyPath:@"email"];
                    NSNumber* idUsuario = [usuario valueForKeyPath:@"idUsuario"];
                    
                    contact.firstName = firstName;
                    contact.email = email;
                    contact.idUsuario = idUsuario;
                    [mutableContacts addObject:contact];
                }
                self.contacts = [NSArray arrayWithArray:mutableContacts];
                self.selectedContacts = [NSMutableArray array];
                self.filteredContacts = self.contacts;
                self.tableView.hidden = NO;
                [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }
            else if([data length]==0 && connectionError==nil){
                NSLog(@"No hay info");
            }
            else if(connectionError!=nil){
                NSLog(@"Sucedio un error: %@",connectionError);
            }
        }];
        
    }
}

- (void)contactPickerDidResize:(THContactPickerView *)contactPickerView {
    [self adjustTableViewFrame:YES];
}

- (void)contactPickerDidRemoveContact:(id)contact {
    [self.selectedContacts removeObject:contact];
    
    NSUInteger index = [self.contacts indexOfObject:contact];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    //cell.accessoryType = UITableViewCellAccessoryNone;
    
    // Enable Done button if total selected contacts > 0
    if(self.selectedContacts.count > 0) {
        barButton.enabled = TRUE;
    }
    else
    {
        barButton.enabled = FALSE;
    }
    
    // Set unchecked image
    UIImageView *checkboxImageView = (UIImageView *)[cell viewWithTag:104];
    UIImage *image;
    image = [UIImage imageNamed:@"icon-checkbox-unselected-25x25"];
    checkboxImageView.image = image;
    
    // Update window title
    self.title = [NSString stringWithFormat:@"Add Members (%lu)", (unsigned long)self.selectedContacts.count];
}

- (void)removeAllContacts:(id)sender
{
    [self.contactPickerView removeAllContacts];
    [self.selectedContacts removeAllObjects];
    self.filteredContacts = self.contacts;
    [self.tableView reloadData];
}
#pragma mark ABPersonViewControllerDelegate

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return YES;
}


@end
