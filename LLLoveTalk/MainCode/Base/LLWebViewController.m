//
//  LLWebViewController.m
//  LLAiLove
//
//  Created by lifuqing on 2019/4/16.
//

#import "LLWebViewController.h"

@interface LLWebViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation LLWebViewController


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
    // Do any additional setup after loading the view.
    [self addBackBarItemWithTitle:self.title];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    _webView.backgroundColor =LLTheme.mainBackgroundColor;
    [self.view addSubview:_webView];
    
    if (_url) {
        [self loadWithURL:_url];
    }
}

- (void)dealloc
{
    [self removeLoading];
    [_webView stopLoading];
}

- (void)loadWithURL:(NSURL *)url
{
    [LLErrorView hideErrorViewInView:self.view];
    [self addLoading];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:20];
    [_webView loadRequest:request];
}

- (void)removeLoading{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
}

- (void)addLoading{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self removeLoading];
    WEAKSELF();
    [LLErrorView showErrorViewInView:self.view withErrorType:LLErrorTypeFailed withClickBlock:^{
        [weakSelf loadWithURL:weakSelf.url];
    }];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [LLErrorView hideErrorViewInView:self.view];
    [self removeLoading];
    if (!self.title) {
        [self setTitle:[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
    }
    
}
@end
