//
//  TeletypeViewControllerViewController.m
//  Moonlqander
//
//  Created by Rick Naro on 5/10/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import "TeletypeViewController.h"


@interface TeletypeViewController ()

@property (nonatomic) dispatch_queue_t loopQueue;

@property (nonatomic) BOOL traceEnabled;

@property (nonatomic) BOOL killBlock;
@property (nonatomic) BOOL onSurface;
@property (nonatomic) BOOL autopilotEnabled;

@property (nonatomic) double T;
@property (nonatomic) double K;
@property (nonatomic) double W;
@property (nonatomic) double S;
@property (nonatomic) double A;
@property (nonatomic) double V;
@property (nonatomic) double M;
@property (nonatomic) double N;
@property (nonatomic) double G;
@property (nonatomic) double Z;
@property (nonatomic) double I;
@property (nonatomic) double L;
@property (nonatomic) double Q;
@property (nonatomic) double J;

@end


@implementation TeletypeViewController

@synthesize teletype, debugger;
@synthesize traceEnabled, killBlock, onSurface, autopilotEnabled;

@synthesize loopQueue;

// Model variables right from the Focal source code
@synthesize A;
@synthesize V;
@synthesize M;
@synthesize N;
@synthesize G;
@synthesize Z;
@synthesize I;
@synthesize L;
@synthesize Q;
@synthesize J;
@synthesize S;
@synthesize T;
@synthesize K;
@synthesize W;


#pragma mark -
#pragma mark View lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Enable autopilot mode
        //self.autopilotEnabled = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    // Load the other views
    [super viewDidLoad];

    // Hide the navigation bar
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
#if defined(TESTFLIGHT_SDK_VERSION) && defined(USE_TESTFLIGHT)
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@:%@", NSStringFromClass([self class]), @""]];
#endif
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    
    // Notification setup
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(debugTraceSwitchChange:) name:@"debugTraceSwitchChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userQuitEvent:) name:@"ttyQuit" object:nil];

    // Create queue to run the loop so not to block the main queue
    self.loopQueue = dispatch_queue_create("com.devtools.teletype.queue", NULL);

    // Dim the background in autopilot mode
    if (self.autopilotEnabled) {
        self.view.alpha = 0.25;
    }
    
    // Set trace control options from settinbgs
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.traceEnabled = self.debugger.debugControls.stepEnabled.on = [defaults floatForKey:@"optionStepEnabled"];
    self.debugger.debugControls.stepInterval.value = [defaults floatForKey:@"optionStepInterval"];
    self.debugger.debugControls.stepInterval.enabled = self.debugger.debugControls.stepEnabled.on;
    self.debugger.debugControls.teletypeVolume.value = [defaults floatForKey:@"optionAudioVolume"];
    
    // Make sure the frame sizes are correct
    [self updateViewFrameForOrientation:self.interfaceOrientation withDuration:0];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Setup autopilot trace view controls
    if (self.autopilotEnabled) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"debugSetTraceEnable" object:[NSNumber numberWithBool:YES]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"debugSetTraceInterval" object:[NSNumber numberWithFloat:2.0]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"autopilotMode" object:[NSNumber numberWithBool:YES]];
    }
    
    // Now create a dispatch event to make the view visible
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
    dispatch_after(popTime, self.loopQueue, ^{[self lunarLander];});
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Release notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // Release the dispatch queue
    if (self.loopQueue) {
        dispatch_release(self.loopQueue);
        self.loopQueue = nil;
    }
    
    // Release the class objects
    self.teletype = nil;
    self.debugger = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


#pragma mark -
#pragma mark Notifications

- (void)userQuitEvent:(NSNotification *)notification
{
    self.killBlock = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"debugTraceSwitchChange" object:[NSNumber numberWithBool:NO]];
}


- (void)debugTraceSwitchChange:(NSNotification *)notification
{
    NSNumber *traceState = notification.object;
    self.traceEnabled = [traceState boolValue];

#if defined(TESTFLIGHT_SDK_VERSION) && defined(USE_TESTFLIGHT)
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@:%@", NSStringFromClass([self class]), [NSString stringWithFormat:@"debugTrace: %@", (self.traceEnabled) ? @"ON" : @"OFF"]]];
#endif
    
    // Redo the window layouts and animate the trace view open/close
    [self updateViewFrameForOrientation:self.interfaceOrientation withDuration:1.0];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self updateViewFrameForOrientation:toInterfaceOrientation withDuration:0];
}

- (void)updateViewFrameForOrientation:(UIInterfaceOrientation)newInterfaceOrientation withDuration:(float)duration
{
    CGRect debuggerFrame, debuggerControls, debuggerConsole, teletypeFrame, printerFrame, keyboardFrame;
    if (self.traceEnabled) {
        debuggerFrame = CGRectMake(0, 0, 1024, 300);
        debuggerControls = CGRectMake(0, 0, 1024, 50);
        debuggerConsole = CGRectMake(0, 50, 1024, 250);
        teletypeFrame = CGRectMake(0, 300, 1024, 468);
        printerFrame = CGRectMake(0, 0, 1024, 344);
        keyboardFrame = CGRectMake(0, 344, 1024, 124);
    }
    else {
        debuggerFrame = CGRectMake(0, 0, 1024, 50);
        debuggerControls = CGRectMake(0, 0, 1024, 50);
        debuggerConsole = CGRectMake(0, 50, 1024, 0);
        teletypeFrame = CGRectMake(0, 50, 1024, 718);
        printerFrame = CGRectMake(0, 0, 1024, 594);
        keyboardFrame = CGRectMake(0, 594, 1024, 124);
    }
    
    // Save control state and disable during animations
    BOOL traceControlsState = self.debugger.userInteractionEnabled;
    self.debugger.userInteractionEnabled = NO;
    
    // Reset content sizes
    self.debugger.debugConsole.contentSize = CGSizeZero;
    self.teletype.printer.scrollView.contentSize = CGSizeZero;
    
    // View animation blocks
    void (^completionBlock)(BOOL) = ^(BOOL f) {
        self.debugger.frame = debuggerFrame;
        self.debugger.debugControls.frame = debuggerControls;
        self.debugger.debugConsole.frame = debuggerConsole;
        self.debugger.userInteractionEnabled = traceControlsState;
        
        // Resets content offset and size
        [self.teletype printBuffer:[self.teletype printBuffer]];
    };
    void (^teletypeBlock)(void) = ^{
        self.teletype.frame = teletypeFrame;
        self.teletype.printer.frame = printerFrame;
        self.teletype.keyboard.frame = keyboardFrame;
    };
    
    // Animation option selection
    UIViewAnimationOptions curlDown = UIViewAnimationCurveLinear | UIViewAnimationOptionTransitionCurlDown;
    UIViewAnimationOptions curlUp = UIViewAnimationCurveLinear | UIViewAnimationOptionTransitionCurlUp;
    
    // Animate the trace view open/close
    if (self.traceEnabled) {
        // Update the view frames for the debugger
        self.debugger.frame = debuggerFrame;
        self.debugger.debugControls.frame = debuggerControls;
        self.debugger.debugConsole.frame = debuggerConsole;
        
        // Animate the teletype move
        [UIView animateWithDuration:duration delay:0.0 options:curlDown animations:teletypeBlock completion:completionBlock];
    }
    else {
        // Animate the teletype move
        [UIView animateWithDuration:duration delay:0.0 options:curlUp animations:teletypeBlock completion:completionBlock];
    }
}


#pragma mark -
#pragma mark Teletype input/output methods

- (void)print:(NSString *)text
{
    // Check if we have been killed
    if (self.killBlock == YES)   {
        return;
    }
    [self.teletype printString:text];
}

- (NSString *)ask
{
    NSString *askKeys = @"";
    if (self.autopilotEnabled == NO) {
        keycode_t code;
        NSString *echoKeys;
        do {
            // Read a keycode from the teletype
            code = [self.teletype getKeycode];
            
            // Decide what to do
            if (code == K_YES) {
                echoKeys = @"YES";
            }
            else if (code == K_NO) {
                echoKeys = @"NO";
            }
            else if (code == K_RUBOUT) {
                if (askKeys.length > 0) {
                    askKeys = [askKeys substringToIndex:askKeys.length-1];
                }
                echoKeys = @"\\";
            }
            else if (code == K_RETURN) {
                echoKeys = @"\n";
            }
            else if (code == K_QUIT) {
                echoKeys = @"QUIT";
            }
            else {
                unichar numericKey = code + '0';
                echoKeys = [NSString stringWithCharacters:&numericKey length:1];
            }
            
            // Append the key to the buffer
            if (code != K_RUBOUT && code != K_RETURN) {
                askKeys = [askKeys stringByAppendingString:echoKeys];
            }
            
            // Echo the keyboard input
            [self print:echoKeys];
        } while (code != K_RETURN && code != K_KILLED);
    }
    else {
        if (self.onSurface) {
            // Keep running forever
            askKeys = @"YES";
        }
        else {
            // Generate a random number between 0-200
            long fuel = random() % 201;
            askKeys = [NSString stringWithFormat:@"%ld", fuel];
        }
        [self print:askKeys];
        [self print:@"\n"];
    }
    
    // Return the string
    return askKeys;
}



#pragma mark -
#pragma mark Main controller loop

- (void)do_block_6
{
_06_10:
    //06.10 S L=L+S;S T=T-S;S M=M-S*K;S A=I;S V=J
#ifdef DEBUG_LOG
    NSLog(@"6.10");
#endif
    [self.debugger stepWait:@"06.10.01"];
    L = L + S;
    
    [self.debugger stepWait:@"06.10.02"];
    T = T - S;
    
    [self.debugger stepWait:@"06.10.03"];
    M = M - S * K;
    
    [self.debugger stepWait:@"06.10.04"];
    A = I;
    
    [self.debugger stepWait:@"06.10.05"];
    V = J;
}

- (void)do_block_9
{
_09_10:
    //09.10 S Q=S*K/M;S J=V+G*S+Z*(-Q-Q^2/2-Q^3/3-Q^4/4-Q^5/5)
#ifdef DEBUG_LOG
    NSLog(@"9.10");
#endif
    [self.debugger stepWait:@"09.10.01"];
    Q = S * K / M;
    
    [self.debugger stepWait:@"09.10.02"];
    J = V + G * S + Z * (-Q - pow(Q, 2) / 2 - pow(Q, 3) / 3 - pow(Q, 4) / 4 - pow(Q, 5) / 5);
    
_09_40:
    //09.40 S I=A-G*S*S/2-V*S+Z*S*(Q/2+Q^2/6+Q^3/12+Q^4/20+Q^5/30)
    [self.debugger stepWait:@"09.40.01"];
    I = A - G * S * S / 2 - V * S + Z * S * (Q / 2 + pow(Q, 2) / 6 + pow(Q, 3) / 12 + pow(Q, 4) / 20 + pow(Q, 5) / 30);
}

- (void)lunarLander
{
    self.killBlock = NO;
#ifdef DEBUG_LOG
    NSLog(@"lunarLander");
#endif
    
_01_04:
    //01.04 T "CONTROL CALLING LUNAR MODULE. MANUAL CONTROL IS NECESSARY"!
    [self.debugger step:@"01.04.01"];
    [self print:@"CONTROL CALLING LUNAR MODULE. MANUAL CONTROL IS NECESSARY\n"];
    
_01_06:
    //01.06 T "YOU MAY RESET FUEL RATE K EACH 10 SECS TO 0 OR ANY VALUE"!
    [self.debugger step:@"01.06.01"];
    [self print:@"YOU MAY RESET FUEL RATE K EACH 10 SECS TO 0 OR ANY VALUE\n"];
    
_01_08:
    //01.08 T "BETWEEN 8 & 200 LBS/SEC. YOU'VE 16000 LBS FUEL. ESTIMATED"!
    [self.debugger step:@"01.08.01"];
    [self print:@"BETWEEN 8 & 200 LBS/SEC. YOU'VE 16000 LBS FUEL. ESTIMATED\n"];
    
_01_11:
    //01.11 T "FREE FALL IMPACT TIME-120 SECS. CAPSULE WEIGHT-32500 LBS"!
    [self.debugger step:@"01.11.01"];
    [self print:@"FREE FALL IMPACT TIME-120 SECS. CAPSULE WEIGHT-32500 LBS\n"];
    
_01_20:
    //01.20 T "FIRST RADAR CHECK COMING UP"!!!;E
    [self.debugger step:@"01.20.01"];
    [self print:@"FIRST RADAR CHECK COMING UP\n\n\n"];
    
    // E
    [self.debugger stepWait:@"01.20.02"];
    
_01_30:
    //01.30 T "COMMENCE LANDING PROCEDURE"!"TIME,SECS   ALTITUDE,"
    [self.debugger step:@"01.30.01"];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self print:@"COMMENCE LANDING PROCEDURE\nTIME,SECS   ALTITUDE,"];
    }
    else {
        [self print:@"COMMENCE LANDING PROCEDURE\nTIME,S  ALT,"];
    }
    
_01_40:
    //01.40 T "MILES+FEET   VELOCITY,MPH   FUEL,LBS   FUEL RATE"!
    [self.debugger step:@"01.40.01"];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self print:@"MILES+FEET   VELOCITY,MPH   FUEL,LBS   FUEL RATE\n"];
    }
    else {
        [self print:@"MILES+FT  VELOCITY,MPH  FUEL,LBS  FUEL RATE\n"];
    }
    
_01_50:
#ifdef DEBUG_LOG
    NSLog(@"1.50");
#endif
    // We are flying
    self.onSurface = NO;

    //01.50 S A=120; S V=1;S M=32500;S N=16500;S G=.001;S Z=1.8
    [self.debugger stepWait:@"01.50.01"];
    A = 120;
    
    [self.debugger stepWait:@"01.50.02"];
    V = 1;
    
    [self.debugger stepWait:@"01.50.03"];
    M = 32500;
    
    [self.debugger stepWait:@"01.50.04"];
    N = 16500;
    
    [self.debugger stepWait:@"01.50.05"];
    G = 0.001;
    
    [self.debugger stepWait:@"01.50.06"];
    Z = 1.8;
    
    // Bug Fix
    [self.debugger stepWait:@"01.50.07"];
    L = 0;
    
_02_10:
    // Check if we have been killed
    if (self.killBlock)   {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        return;
    }
    
    //02.10 T "    ",%3,L,"           "FITR(A),"  "%4,5280*(A-FITR(A))
    //02.20 T %6.02,"       "3600*V,"    "%6.01,M-N,"      K=";A K;S T=10
#ifdef DEBUG_LOG
    NSLog(@"2.10");
#endif
    {
        NSString *iPadFormat_02_10 = @"    %4.0f            %3.0f   %4.0f";
        NSString *iPhoneFormat_02_10 = @"  %4.0f      %3.0f %4.0f";
        NSString *iPadFormat_02_20 = @"        %c%7.2f    %7.1f      K=:";
        NSString *iPhoneFormat_02_20 = @"     %c%7.2f   %7.1f     K=:";
        
        float Ami;
        float Aft = 5280 * modff(A, &Ami);
        float absV = 3600 * fabs(V);
        char signV = (V < 0) ? '-' : ' ';
        NSString *formatSim_02_10 = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? iPadFormat_02_10 : iPhoneFormat_02_10;
        NSString *formatSim_02_20 = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? iPadFormat_02_20 : iPhoneFormat_02_20;

        [self.debugger step:@"02.10.01"];
        NSString *simLine_02_10 = [NSString stringWithFormat:formatSim_02_10, L, Ami, Aft];
        [self print:simLine_02_10];
        
        [self.debugger step:@"02.20.01"];
        NSString *simLine_02_20 = [NSString stringWithFormat:formatSim_02_20, signV, absV, (M - N)];
        [self print:simLine_02_20];

#ifdef DEBUG_LOG
        NSLog(@"%@", simLine);
#endif
        // ASK K
        [self.debugger step:@"02.20.02"];
        NSString *stringK = [self ask];
        // Check if we have been killed
        if (self.killBlock)   {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            return;
        }

        NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc] init];
        [numberFormat setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *burnRate = [numberFormat numberFromString:stringK];
        if (burnRate == nil) {
            // Check for the QUIT key
            if ([stringK isEqualToString:@"QUIT"]) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
                return;
            }

            K = -1;
            goto _02_70;
        }
        K = [burnRate doubleValue];
        
        [self.debugger stepWait:@"02.20.03"];
        T = 10;
    }
    
_02_70:
    //02.70 T %7.02;I (200-K)2.72;I (8-K)3.1,3.1;I (K)2.72,3.1
    //T %7.02;set format %7.2f
#ifdef DEBUG_LOG
    NSLog(@"2.70");
#endif
    //02.70 T %7.02;
    [self.debugger stepWait:@"02.70.01"];
    
    [self.debugger stepWait:@"02.70.02"];
    if ((200 - K) < 0) {
        [self.debugger stepWait:@"02.70.03"];
        goto _02_72;
    }
    
    [self.debugger stepWait:@"02.70.04"];
    if ((8 - K) < 0) {
        [self.debugger stepWait:@"02.70.05"];
        goto _03_10;
    }
    else if ((8 - K) == 0) {
        [self.debugger stepWait:@"02.70.06"];
        goto _03_10;
    }
    
    [self.debugger stepWait:@"02.70.07"];
    if (K < 0) {
        [self.debugger stepWait:@"02.70.08"];
        goto _02_72;
    }
    else if (K == 0) {
        [self.debugger stepWait:@"02.70.09"];
        goto _03_10;
    }
    
_02_72:
    //02.72 T "NOT POSSIBLE";F X=1,51;T "."
    [self.debugger step:@"02.72.01"];
    [self print:@"NOT POSSIBLE"];
    short nPeriods = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 51 : 36;
    for (int X = 0; X < nPeriods;X++) {
        [self.debugger stepWait:@"02.72.02"];
        [self.debugger stepWait:@"02.72.03"];
        [self print:@"."];
    }
    
_02_73:
    //02.73 T "K=";A K;G 2.7
    {
        // Check if we have been killed
        if (self.killBlock)   {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            return;
        }
        [self.debugger step:@"02.73.01"];
        [self print:@"K=:"];
        
        [self.debugger stepWait:@"02.73.02"];
        NSString *stringK = [self ask];
        // Check if we have been killed
        if (self.killBlock)   {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            return;
        }
        
        NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc] init];
        [numberFormat setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *burnRate = [numberFormat numberFromString:stringK];

        [self.debugger stepWait:@"02.73.03"];
        if (burnRate == nil) {
            if ([stringK isEqualToString:@"QUIT"]) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
                return;
            }

            K = -1;
            goto _02_70;
        }
        K = [burnRate doubleValue];
        T = 10;
        goto _02_70;
    }
    
_03_10:
    //03.10 I (M-N-.001)4.1;I (T-.001)2.1;S S=T
#ifdef DEBUG_LOG
    NSLog(@"3.10");
#endif
    [self.debugger stepWait:@"03.10.01"];
    if ((M - N - 0.001) < 0) {
        [self.debugger stepWait:@"03.10.02"];
        goto _04_10;
    }
    
    [self.debugger stepWait:@"03.10.03"];
    if ((T - 0.001) < 0) {
        [self.debugger stepWait:@"03.10.04"];
        goto _02_10;
    }

    [self.debugger stepWait:@"03.10.05"];
    S = T;
    
_03_40:
    //03.40 I (N+S*K-M)3.5,3.5;S S=(M-N)/K
#ifdef DEBUG_LOG
    NSLog(@"3.40");
#endif
    [self.debugger stepWait:@"03.40.01"];
    if ((N + S * K - M) < 0) {
        [self.debugger stepWait:@"03.40.02"];
        goto _03_50;
    }
    else if ((N + S * K - M) == 0) {
        [self.debugger stepWait:@"03.40.03"];
        goto _03_50;
    }

    [self.debugger stepWait:@"03.40.04"];
    S = (M - N) /K;
    
_03_50:
    //03.50 D 9;I (I)7.1,7.1;I (V)3.8,3.8;I (J)8.1
#ifdef DEBUG_LOG
    NSLog(@"3.50");
#endif
    [self.debugger stepWait:@"03.50.01"];
    [self do_block_9];
    
    [self.debugger stepWait:@"03.50.02"];
    if (I < 0) {
        [self.debugger stepWait:@"03.50.03"];
        goto _07_10;
    }
    else if (I == 0) {
        [self.debugger stepWait:@"03.50.04"];
        goto _07_10;
    }
    
    [self.debugger stepWait:@"03.50.05"];
    if (V < 0) {
        [self.debugger stepWait:@"03.50.06"];
        goto _08_30;
    }
    else if (V == 0) {
        [self.debugger stepWait:@"03.50.07"];
        goto _08_30;
    }
    
    [self.debugger stepWait:@"03.50.08"];
    if (J < 0) {
        [self.debugger stepWait:@"03.50.09"];
        goto _08_10;
    }
    
_03_80:
    //03.80 D 6;G 3.1
#ifdef DEBUG_LOG
    NSLog(@"3.80");
#endif
    [self.debugger stepWait:@"03.80.01"];
    [self do_block_6];
    
    [self.debugger stepWait:@"03.80.02"];
    goto _03_10;
    
_04_10:
    //04.10 T "FUEL OUT AT",L," SECS"!
#ifdef DEBUG_LOG
    NSLog(@"4.10");
#endif
    [self.debugger step:@"04.10.01"];
    [self print:@"FUEL OUT AT"];
    [self print:[NSString stringWithFormat:@"%9.2f", L]];
    [self print:@" SECS\n"];
    
_04_40:
    //04.40 S S=(FSQT(V*V+2*A*G)-V)/G;S V=V+G*S;S L=L+S
#ifdef DEBUG_LOG
    NSLog(@"4.40");
#endif
    [self.debugger stepWait:@"04.40.01"];
    S = (sqrt(V * V + 2 * A * G) - V) / G;

    [self.debugger stepWait:@"04.40.02"];
    V = V + G * S;
    
    [self.debugger stepWait:@"04.40.03"];
    L = L + S;
    
_05_10:
    // We are landed
    self.onSurface = YES;

    //05.10 T "ON THE MOON AT",L," SECS"!;S W=3600*V
#ifdef DEBUG_LOG
    NSLog(@"5.10");
#endif
    [self.debugger stepWait:@"05.10.01"];
    [self print:@"ON THE MOON AT"];
    [self print:[NSString stringWithFormat:@"%9.2f", L]];
    [self print:@" SECS\n"];
    
    [self.debugger stepWait:@"05.10.02"];
    W = 3600 * V;
    
_05_20:
    //05.20 T "IMPACT VELOCITY OF",W,"M.P.H."!,"FUEL LEFT:"M-N," LBS:"!
    [self.debugger step:@"05.20.01"];
    [self print:@"IMPACT VELOCITY OF"];
    [self print:[NSString stringWithFormat:@"%9.2f", W]];
    [self print:@" M.P.H.\n"];
    [self print:@"FUEL LEFT:"];
    [self print:[NSString stringWithFormat:@"%9.2f", M - N]];
    [self print:@" LBS\n"];
    
    // Post the score for all listeners
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scorePosted" object:[NSNumber numberWithFloat:W]];
    
    //05.40 I (1-W)5.5,5.5;T "PERFECT LANDING !-(LUCKY)"!;G 5.9
_05_40:
    // I (1-W)
    [self.debugger stepWait:@"05.40.01"];
    if ((1 - W) < 0) {
        // 5.5,
        [self.debugger stepWait:@"05.40.02"];
        goto _05_50;
    }
    else if ((1 - W) == 0) {
        // 5.5
        [self.debugger stepWait:@"05.40.03"];
        goto _05_50;
    }
    
    // T "PERFECT LANDING !-(LUCKY)"!;
    [self.debugger step:@"05.40.04"];
    [self print:@"PERFECT LANDING !-(LUCKY)\n"];
    
    // G 5.9
    [self.debugger stepWait:@"05.40.05"];
    goto _05_90;
    
    //05.50 I (10-W)5.6,5.6;T "GOOD LANDING-(COULD BE BETTER)"!;G 5.90
_05_50:
    // I (10-W)
    [self.debugger stepWait:@"05.50.01"];
    if ((10 - W) < 0) {
        // 5.6,
        [self.debugger stepWait:@"05.50.02"];
        goto _05_60;
    }
    else if ((10 - W) == 0) {
        // 5.6;
        [self.debugger stepWait:@"05.50.03"];
        goto _05_60;
    }
    
    // T "GOOD LANDING-(COULD BE BETTER)"!;
    [self.debugger step:@"05.50.04"];
    [self print:@"GOOD LANDING-(COULD BE BETTER)\n"];
    
    // G 5.9
    [self.debugger stepWait:@"05.50.05"];
    goto _05_90;

    //05.60 I (22-W)5.7,5.7;T "CONGRATULATIONS ON A POOR LANDING"!;G 5.9
_05_60:
    // I (22-W)
    [self.debugger stepWait:@"05.60.01"];
    if ((22 - W) < 0) {
        // 5.7,
        [self.debugger stepWait:@"05.60.02"];
        goto _05_70;
    }
    else if ((22 - W) == 0) {
        // 5.7,
        [self.debugger stepWait:@"05.60.03"];
        goto _05_70;
    }

    // T "CONGRATULATIONS ON A POOR LANDING"!;
    [self.debugger step:@"05.60.04"];
    [self print:@"CONGRATULATIONS ON A POOR LANDING\n"];

    // G 5.9
    [self.debugger stepWait:@"05.60.05"];
    goto _05_90;
    
    //05.70 I (40-W)5.81,5.81;T "CRAFT DAMAGE. GOOD LUCK"!;G 5.9
_05_70:
    [self.debugger stepWait:@"05.70.01"];
    if ((40 - W) < 0) {
        // 5.81,
        [self.debugger stepWait:@"05.70.02"];
        goto _05_81;
    }
    else if ((40 - W) == 0) {
        // 5.81;
        [self.debugger stepWait:@"05.70.03"];
        goto _05_81;
    }
    
    // T "CRAFT DAMAGE. GOOD LUCK"!;
    [self.debugger step:@"05.70.04"];
    [self print:@"CRAFT DAMAGE. GOOD LUCK\n"];

    // G 5.9
    [self.debugger stepWait:@"05.70.05"];
    goto _05_90;
    
    //05.81 I (60-W)5.82,2.82;T "CRASH LANDING-YOU'VE 5 HRS OXYGEN";G 5.90
_05_81:
    [self.debugger stepWait:@"05.81.01"];
    if ((60 - W) < 0) {
        // 5.82,
        [self.debugger stepWait:@"05.81.02"];
        goto _05_82;
    }
    else if ((60 - W) == 0) {
        // 5.82;
        [self.debugger stepWait:@"05.81.03"];
        goto _05_82;
    }
    
    // T "CRASH LANDING-YOU'VE 5 HRS OXYGEN";
    [self.debugger step:@"05.81.04"];
    [self print:@"CRASH LANDING-YOU'VE 5 HRS OXYGEN\n"];
    
    // G 5.90
    [self.debugger stepWait:@"05.81.05"];
    goto _05_90;
    
_05_82:
    //05.82 T "SORRY,BUT THERE WERE NO SURVIVORS-YOU BLEW IT!"!"IN"
    [self.debugger step:@"05.82.01"];
    [self print:@"SORRY,BUT THERE WERE NO SURVIVORS-YOU BLEW IT!\nIN "];
    
    //05.83 T "FACT YOU BLASTED A NEW LUNAR CRATER",W*.277777,"FT. DEEP."!
    [self.debugger step:@"05.83.01"];
    [self print:@"FACT YOU BLASTED A NEW LUNAR CRATER"];
    [self print:[NSString stringWithFormat:@"%9.2f", W * 0.277777]];
    [self print:@" FT. DEEP.\n"];
    
_05_90:
    //05.90 T !!!!"TRY AGAIN?"!
    [self.debugger step:@"05.90.01"];
    [self print:@"\n\n\n\nTRY AGAIN?\n"];
    
    //05.92 A "(ANS. YES OR NO)"P;I (P-0NO)5.94,5.98
_05_92:
    {
        //05.92 A "(ANS. YES OR NO)"P;
        [self.debugger step:@"05.92.01"];
        [self print:@"(ANS. YES OR NO):"];
        NSString *stringP = [self ask];
        // Check if we have been killed
        if (self.killBlock)   {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            return;
        }

        // Check for the QUIT key
        if ([stringP isEqualToString:@"QUIT"]) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            return;
        }

        // I (P-0NO)5.94,5.98
        [self.debugger stepWait:@"05.92.02"];
        if ([stringP isEqual:@"NO"]) {
            [self.debugger stepWait:@"05.92.03"];
            goto _05_98;
        }
            
_05_94:
        //05.94 I (P-0YES)5.92,1.2,5.92
        [self.debugger stepWait:@"05.94.01"];
        if ([stringP isEqual:@"YES"] == NO) {
            [self.debugger stepWait:@"05.94.02"];
            goto _05_92;
        }

        // 1.2
        [self.debugger stepWait:@"05.94.03"];
        goto _01_20;

        //05.98 T "CONTROL OUT"!!!;Q
_05_98:
        // T "CONTROL OUT"!!!
        [self.debugger step:@"05.98.01"];
        [self print:@"CONTROL OUT"];
        
        // Q
        [self.debugger stepWait:@"05.98.02"];

        // Exit the game ### could use small delay
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.navigationController popViewControllerAnimated:YES];
        });
        return;
    }
    
_07_10:
    //07.10 I (S-.005)5.1;S S=2*A/(V+FSQT(V*V+2*A*(G-Z*K/M)))
#ifdef DEBUG_LOG
    NSLog(@"7.10");
#endif
    [self.debugger stepWait:@"07.10.01"];
    if (S - 0.005 < 0) {
        [self.debugger stepWait:@"07.10.02"];
        goto _05_10;
    }
    
    [self.debugger stepWait:@"07.10.03"];
    S = 2 * A / (V + sqrt(V * V + 2 * A * (G - Z * K / M)));
    
_07_30:
    //07.30 D 9;D 6;G 7.1
#ifdef DEBUG_LOG
    NSLog(@"7.30");
#endif
    [self.debugger stepWait:@"07.30.01"];
    [self do_block_9];
    
    [self.debugger stepWait:@"07.30.02"];
    [self do_block_6];

    [self.debugger stepWait:@"07.30.03"];
    goto _07_10;

_08_10:
    //08.10 S W=(1-M*G/Z*K)/2;S S=M*V/(Z*K*(W+FSQT(W*W+V/Z)))+.05;D 9
    [self.debugger stepWait:@"08.10.01"];
    W = (1 - (M * G) / (Z * K)) / 2;
    
    [self.debugger stepWait:@"08.10.02"];
    S = M * V / (Z * K * (W + sqrt(W * W + V / Z))) + 0.05;
    
#ifdef DEBUG_LOG
    NSLog(@"8.10  S=%9.2f  M=%9.2f  V=%9.4f  Z=%9.4f  W=%9.4f  K=%9.4f",S,M,V,Z,W,K);
#endif
    
_08_20:
#ifdef DEBUG_LOG
    NSLog(@"8.20");
#endif
    [self.debugger stepWait:@"08.20.01"];
    [self do_block_9];
    
_08_30:
    //08.30 I (I)7.1,7.1;D 6;I (-J)3.1,3.1;I (V)3.1,3.1,8.1
#ifdef DEBUG_LOG
    NSLog(@"8.30");
#endif
    [self.debugger stepWait:@"08.30.01"];
    if (I < 0) {
        [self.debugger stepWait:@"08.30.02"];
        goto _07_10;
    }
    else if (I == 0) {
        [self.debugger stepWait:@"08.30.03"];
        goto _07_10;
    }

    [self.debugger stepWait:@"08.30.04"];
    [self do_block_6];
    
    [self.debugger stepWait:@"08.30.05"];
    if (-J < 0) {
        [self.debugger stepWait:@"08.30.06"];
        goto _03_10;
    }
    else if (-J == 0) {
        [self.debugger stepWait:@"08.30.07"];
        goto _03_10;
    }
    
    [self.debugger stepWait:@"08.30.08"];
    if (V < 0) {
        [self.debugger stepWait:@"08.30.09"];
        goto _03_10;
    }
    else if (V == 0) {
        [self.debugger stepWait:@"08.30.10"];
        goto _03_10;
    }
    else {
        [self.debugger stepWait:@"08.30.11"];
        goto _08_10;
    }

    // In case we fall off
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

@end
