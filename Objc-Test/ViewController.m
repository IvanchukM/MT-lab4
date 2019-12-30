#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *playAgainButton;
@property (nonatomic) IBOutletCollection(UIButton) NSArray *fieldButtons;

@end

@implementation ViewController

short player = 1;
short state[9];
bool playing = true;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startGame];
}

- (IBAction)fieldTapped:(UIButton *)sender {
    if (!playing) {
        return;
    }
    if ([sender titleForState:UIControlStateNormal] != nil) {
        return;
    }
    NSInteger tag = [sender tag];
    state[tag] = player;
    if (player == 1) {
        [sender setTitle:@"X" forState:UIControlStateNormal];
    } else {
        [sender setTitle:@"O" forState:UIControlStateNormal];
    }
    [self evaluate];
    player = player == 1 ? 2 : 1;
}

- (IBAction)playAgainButtonTapped:(UIButton *)sender {
    for (int i = 0; i < 9; i++) {
        [_fieldButtons[i] setTitle:NULL forState:UIControlStateNormal];
        state[i] = 0;
    }
    [self startGame];
}

-(void)startGame {
    [[self playAgainButton] setHidden:true];
    playing = true;
}

-(void)evaluate {
    short winner = [self getWinner];
    if (winner != 0) {
        [[self playAgainButton] setHidden:false];
        [self showWinnerAlert:winner];
        playing = false;
        return;
    }
    if ([self isFieldFull]) {
        [[self playAgainButton] setHidden:false];
        [self showDrawAlert];
        return;
    }
}

-(BOOL)isFieldFull {
    for (int i = 0; i < 9; i++) {
        if (state[i] == 0) {
            return false;
        }
    }
    return true;
}

-(short)getWinner {
    short first, second, third;
    for(int i = 0; i < 3; i++) {
        // horizontal
        first = state[i + i * 2];
        second = state[i + i * 2 + 1];
        third =  state[i + i * 2 + 2];
        if (first != 0 && first == second && second == third) {
            return first;
        }
        // vertical
        first = state[i];
        second = state[i + 3];
        third =  state[i + 6];
        if (first != 0 && first == second && second == third) {
            return first;
        }
        // diagonal
        if (i == 2) {
            continue;
        }
        first = state[i * 2];
        second = state[4];
        third = state[8 - 2 * i];
        if (first != 0 && first == second && second == third) {
            return first;
        }
    }
    return 0;
}

-(void)showWinnerAlert:(short)winner {
    NSString *winnerLabel = winner == 1 ? @"X" : @"O";
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Win"
                                          message:[NSString stringWithFormat:@"%@ is winner!", winnerLabel]
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:NULL];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:true completion:NULL];
}

-(void)showDrawAlert {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Drow"
                                          message:@"Drow is occured."
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:NULL];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:true completion:NULL];
}

@end
