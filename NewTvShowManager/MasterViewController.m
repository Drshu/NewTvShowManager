//
//  MasterViewController.m
//  NewTvShowManager
//
//  Created by shucheng on 16/4/5.
//  Copyright © 2016年 shucheng. All rights reserved.
//

#import "MasterViewController.h"
#import "ViewController.h"
#import "FMDB.h"

@interface MasterViewController ()
@property(nonatomic,strong)FMDatabase *db;
@end
 
@implementation MasterViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    //添加右上角的『加号』
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self
                                  action:@selector(insertNewObject)];
    self.navigationItem.rightBarButtonItem = addButton;

}

-(void)insertNewObject{
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"请输入您的电视剧名字"
                                        message:@"对，就是输在这里"
                                 preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *nameField){
        nameField.placeholder = @"剧名";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *introductionField){
        introductionField.placeholder = @"简单的介绍";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *seasonField){
        seasonField.placeholder = @"你看到第几季啦~";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *episodeField){
        episodeField.placeholder = @"你看到第几集啦~";
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不玩了！"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    UIAlertAction *creatAction = [UIAlertAction  actionWithTitle:@"我要添加！"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action){
                                                             UITextField *nameField = (UITextField*)alert.textFields[0];
                                                             UITextField *introductionField = (UITextField*)alert.textFields[1];
                                                             UITextField *seasonField = (UITextField*)alert.textFields[2];
                                                             UITextField *episodeField = (UITextField*)alert.textFields[3];
                                                             NSString *name = nameField.text;
                                                             NSString *introduction = introductionField.text;
                                                             NSString *season = [NSString stringWithFormat:@"S%@",seasonField.text];
                                                             NSString *episode = [NSString stringWithFormat:@"E%@",episodeField.text];
                                                             NSString *lastDate;
                                                             lastDate = [season stringByAppendingString:episode];
                                                             [self creatData:name
                                                           creatIntroduction:introduction
                                                                   creatDate:lastDate];
                                                             
                                                         }];
    [alert addAction:cancelAction];
    [alert addAction:creatAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)creatData:(NSString*)name creatIntroduction:(NSString*)introduction creatDate:(NSString *) lastDate{
    NSString *trimmedShowName = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(trimmedShowName >0){
        NSString *allDate = @"S20E20";
        [self.db executeUpdate:@"INSERT INTO t_show (name,introduction,lastDate,allDate) VALUES (?,?,?,?)",name,
         introduction,lastDate,allDate];
        NSLog(@"储存成功！");
    }else{
        NSLog(@"储存失败！");
    }
}


@end
