//
//  MasterLoginViewController.m
//  Flattened
//
//  Created by Diego Maye on 07/05/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "MasterLoginViewController.h"
#import "SIAlertView.h"
@interface MasterLoginViewController (){
    CGSize kbSize;
}

@property(strong, nonatomic) UITextField* textFieldFecha;

@end

const int TOOLBAR_HEIGHT_2 = 35;

@implementation MasterLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.toolbarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, TOOLBAR_HEIGHT_2)];
    self.toolbarView.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.view.window];
    UIButton *btnHideKeys = [UIButton buttonWithType:UIButtonTypeCustom];
    btnHideKeys.frame = CGRectMake(self.view.frame.size.width - 36, 9, 26, 26);
    [btnHideKeys setImage:[UIImage imageNamed:@"list-item-detail-hide-keyboard"] forState:UIControlStateNormal];
    [btnHideKeys addTarget:self action:@selector(actionHideKeys:) forControlEvents:UIControlEventTouchUpInside];
    [_toolbarView addSubview:btnHideKeys];
    
    
}

#pragma mark Teclado con boton para esconderlo.
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        //call the method to make the toolbar appear.
    [self loadToolbar];
}

- (void)keyboardWillHide:(NSNotification*)notification {
        //self.txtMessage.text = nil;
    [UIView animateWithDuration:0.25f animations:^{
        self.toolbarView.frame = CGRectMake(0, self.view.frame.size.height - TOOLBAR_HEIGHT_2, self.toolbarView.frame.size.width, TOOLBAR_HEIGHT_2);
    }];
}

- (void)loadToolbar {
    [self.view addSubview:self.toolbarView];
        //setting the position of the toolbar.
    CGRect frameRect = self.view.frame;
    frameRect.size.height -= kbSize.height;
    
    [UIView animateWithDuration:0.25f animations:^{
        self.toolbarView.frame = CGRectMake(0.0, frameRect.size.height - TOOLBAR_HEIGHT_2, 320.0, TOOLBAR_HEIGHT_2);
    }];
}

- (void)actionHideKeys:(id)sender {
    self.toolbarView.hidden = YES;
    [self.view endEditing:YES];
}
#pragma mark Alertas
- (void)showAlert:(NSString*)title andMessage:(NSString*)message{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:title andMessage:message];

    [alertView addButtonWithTitle:@"Ok"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alert) {
                          }];
    
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
    
}

#pragma mark Event up down para bajar y subir textfields

-(void) upTextField:(UITextField *) textField focusOn:(UITextField*) focus{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    if (focus != textField) {
        textField.frame = CGRectMake(textField.frame.origin.x, (focus.frame.origin.y - 70), textField.frame.size.width, textField.frame.size.height);
    }
    else{
        
        textField.frame = CGRectMake(textField.frame.origin.x, (textField.frame.origin.y - 70), textField.frame.size.width, textField.frame.size.height);
    }
    [UIView commitAnimations];
}

-(void) agregarEspacioInterno:(UITextField*) textField{
    UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(10,0,7,26)];
    leftView.backgroundColor = [UIColor clearColor];
    
    
    textField.leftView = leftView;
    
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
}

-(void) downField:(UITextField*) textField withSpace:(NSNumber*) space{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    textField.frame = CGRectMake(textField.frame.origin.x, (textField.frame.origin.y + [space floatValue] + 70), textField.frame.size.width, textField.frame.size.height);
    [UIView commitAnimations];
}

#pragma mark Calendario con boton customizacion UIDate Picker

-(void) customizationUIDatePickerUITextView:(UITextField*)text withButtonDescription:(NSString*) buttonDescription{
    
    _textFieldFecha = text;
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    [keyboardToolbar setBarStyle:UIBarStyleBlackTranslucent];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:buttonDescription style:UIBarButtonItemStyleDone target:self action:@selector(changeDate:)];
    
    [keyboardToolbar setItems:[[NSArray alloc] initWithObjects: flexSpace, done, nil]];
    
    text.inputAccessoryView = keyboardToolbar;
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [datePicker setBounds:CGRectMake(0,0,self.view.bounds.size.width,100)];
    [datePicker setDate:[NSDate date]];
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [text setInputView:datePicker];
}

 -(void)changeDate:(id)sender{
     [self modifyUITextField:_textFieldFecha];
     [self.view endEditing:YES];
 }
 
 -(void)updateTextField:(id)sender
 {
 [self modifyUITextField:_textFieldFecha];
 }
 
 
-(void)modifyUITextField:(UITextField*) _txtFecha{
    
    UIDatePicker *picker = (UIDatePicker*)_txtFecha.inputView;
        //Fecha inicial por defecto fecha de hoy
        //NSDate* fechaInicio = [NSDate new];
        //NSDate* fechaInicio=picker.date;
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = NSLocalizedString(@"MM/dd/yyyy",nil);
    NSString *fecha = [dateFormatter stringFromDate:picker.date];
    dateFormatter.dateFormat = NSLocalizedString(@"HH:mm",nil);
    NSString *hora = [dateFormatter stringFromDate:picker.date];
    NSString *resultado= [NSString stringWithFormat:@"%@ %@ %@ %@",
    NSLocalizedString(@"Starts at ",nil),
    fecha,
    NSLocalizedString(@" on ",nil),
    hora];
    _txtFecha.text = [NSString stringWithFormat:@"%@",resultado];
 
 }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
