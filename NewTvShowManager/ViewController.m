//
//  ViewController.m
//  NewTvShowManager
//
//  Created by shucheng on 16/4/5.
//  Copyright © 2016年 shucheng. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"
#import "DataFromDataBase.h"
#import "DetailViewController.h"

static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";
@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *nameArray;
@property(nonatomic,strong)FMDatabase *db;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //添加右上角的『加号』
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self
                                  action:@selector(insertNewObject)];
    self.navigationItem.rightBarButtonItem = addButton;
    

    UITableView *tableView = (id)[self.view viewWithTag:1];
    UIEdgeInsets contentInset = tableView.contentInset;
    contentInset.top = 20;//调整表视图顶部边缘值
    [tableView setContentInset:contentInset];

}

-(void)viewWillAppear:(BOOL)animated{
    //1.获得数据库文件的路径
    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:@"tvShow.sqlite"];
    
    //2.获得数据库
    FMDatabase *db=[FMDatabase databaseWithPath:fileName];
    
    //3.打开数据库
    if ([db open]) {
        //4.创表
        BOOL result=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_show (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, introduction text NOT NULL, lastDate text NOT NULL, allDate text NOT NULL);"];
       
        if (result) {
            NSLog(@"创表成功");
            FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM t_show"];

            if([resultSet next] == NO){
                NSString *defaultName = @"Please add a TV Show name";
                NSString *defaultIntroduction = @"Your show's introduction";
                NSString *defaultLastDate = @"S01E01";
                NSString *defaultAllDate = @"S20E20";
                [db executeUpdate:@"INSERT INTO t_show (name,introduction,lastDate,allDate) VALUES (?,?,?,?);",defaultName,defaultIntroduction,defaultLastDate,defaultAllDate];

            }
            }

        }else
        {
            NSLog(@"创表失败");
        }
    self.db = db;
    [self query];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];//可以重新加载表视图，因为在视图切换的时候，可能有需要更新的东西，例如收藏的内容
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)query{

    self.nameArray = [[NSMutableArray alloc]init];

        // 1.执行查询语句
        FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM t_show"];
        // 2.遍历结果
        while ([resultSet next]) {
            int ID = [resultSet intForColumn:@"id"];
            NSString *name = [resultSet stringForColumn:@"name"];
            NSString *introduction = [resultSet stringForColumn:@"introduction"];
            NSString *lastDate = [resultSet stringForColumn:@"lastDate"];
            NSLog(@"%d %@ %@ %@", ID, name, introduction,lastDate);
            [self.nameArray addObject:name];
        }
        [[DataFromDataBase shareFromDataBase].nameArrayFromClass arrayByAddingObjectsFromArray:self.nameArray];
        NSLog(@"self.nameArray == %@",self.nameArray);

    
}


- (void)alertView:(UIAlertController *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.tableView reloadData];
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
    [self query];
    //[self alertView:alert clickedButtonAtIndex:0];

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


#pragma -
#pragma UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.nameArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SectionsTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:SectionsTableIdentifier];
    }
    NSLog(@"self.nameArray == %@",self.nameArray);

    cell.textLabel.text =self.nameArray[indexPath.row];
    return cell;
}
//-(NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row==0) {
//        return nil;//第一行的时候返回nil
//    }else{
//        return indexPath;//传递即将选中的行对应的索引
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSString *chooseName = self.nameArray[indexPath.row];
    NSLog(@"tag :: %ld",indexPath.row);
    if(indexPath.row != 0){
    [self performSegueWithIdentifier:@"showDetail" sender:indexPath];
}

}


#pragma -
#pragma Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([sender isKindOfClass:[NSIndexPath class]])
    {
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        if ([segue.destinationViewController isKindOfClass:[DetailViewController class]]) {
            DetailViewController *aDetailVC = (DetailViewController*)segue.destinationViewController;
            NSString *name =self.nameArray[indexPath.row];
            aDetailVC.title = name;
            aDetailVC.showName = name;
        }
}
}
@end
