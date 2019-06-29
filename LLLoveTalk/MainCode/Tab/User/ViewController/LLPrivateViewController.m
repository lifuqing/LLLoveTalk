//
//  LLPrivateViewController.m
//  LLAiLove
//
//  Created by lifuqing on 2019/4/15.
//

#import "LLPrivateViewController.h"

@interface LLPrivateViewController ()

@end

@implementation LLPrivateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"隐私政策";
        
        self.url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"private.docx" ofType:nil]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
