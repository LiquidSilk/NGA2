//
//  DetailViewController.m
//  NGA
//
//  Created by 陈 忠杰 on 13-10-16.
//  Copyright (c) 2013年 陈 忠杰. All rights reserved.
//

#import "DetailViewController.h"
#import "MsgModel.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    [[SubscribeModel sharedModel] pushObserver:self];
    [[MsgModel sharedModel] sendMsg:1002 withUrl:@"/read.php?tid=6624310&page=1&lite=js&v2&noprefix"];
    
    //不会<br/>虽然很想 但是不会<br/>只可惜配音的人估计也不是当年的原班人马了<br/><br/>SD是激励着我的动画 也是我为数不多非常喜欢迷恋的动画片
    [_webView loadHTMLString:@"<b><font color='#888'>[大漩涡万能系列]</font> <font color='#888'>[起名服务]</font> 喜闻乐见的取名服务</b>     <br/>     10-21 13:33:17.578: I/TopicListAdapter(1355): <font color='#1D2A63'><font color='#F00'>[大漩涡万能系列]</font> 喜闻乐见的购物咨询贴~ 是关于海淘的！ 我要把优惠做到底！不服来战 10月21日更新<font color='#F00'>[硬件贴]</font> 这不是广告贴！</font>   <br/>10-21 13:34:56.000: I/TopicListAdapter(1870): <font color='#D00'><b><font color='#888'>[3DS]</font> <font color='#888'>[攻略研究]</font>口袋妖怪xy育儿指南，如何培养一只满意的极品精灵。更新关于使用红线获得高个体精灵方法。</b></font>" baseURL:nil];
}

-(void)receiveData:(DataVO*)dataVO
{
    if (dataVO.module == 1002)
    {

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
