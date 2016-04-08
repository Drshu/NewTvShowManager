//
//  DetailViewController.m
//  NewTvShowManager
//
//  Created by shucheng on 16/4/6.
//  Copyright © 2016年 shucheng. All rights reserved.
//

#import "DetailViewController.h"
#import "FMDB.h"

@interface DetailViewController()
@property(nonatomic,strong)FMDatabase *db;
@property (weak, nonatomic) IBOutlet UIStepper *yourEpisodeStepper;
@property (weak, nonatomic) IBOutlet UIStepper *yourSeasonStepper;
@property (weak, nonatomic) IBOutlet UIStepper *lastedSeasonStepper;
@property (weak, nonatomic) IBOutlet UIStepper *lastedEpisodeStepper;
@property (weak, nonatomic) IBOutlet UITextField *youeEpisode;
@property (weak, nonatomic) IBOutlet UITextField *yourSeason;
@property (weak, nonatomic) IBOutlet UITextField *introductionField;
@property(nonatomic, strong)UILabel * lable;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *lastedSeason;
@property (weak, nonatomic) IBOutlet UITextField *lastedEpisode;
@end

@implementation DetailViewController


-(void)viewDidLoad{
    [super viewDidLoad];
        self.nameField.text = self.showName;
        NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fileName=[doc stringByAppendingPathComponent:@"tvShow.sqlite"];
        FMDatabase *db=[FMDatabase databaseWithPath:fileName];
    // 1.执行查询语句
    NSString *findStr = [NSString stringWithFormat:@"SELECT * FROM t_show where name =%@",self.showName];
        [db open];
    FMResultSet *resultSet = [db executeQuery:findStr];

    if ([db open]) {
    while ([resultSet next]) {
        NSString *name = [resultSet stringForColumn:@"name"];
        NSString *introduction = [resultSet stringForColumn:@"introduction"];
        NSString *lastDate = [resultSet stringForColumn:@"lastDate"];
        NSLog(@"%@ %@ %@", name, introduction,lastDate);
        self.nameField.text = name;
        self.introductionField.text = introduction;
        
         }
    }
}
@end
