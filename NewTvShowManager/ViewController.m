//
//  ViewController.m
//  NewTvShowManager
//
//  Created by shucheng on 16/4/5.
//  Copyright © 2016年 shucheng. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"

static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";
@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *nameArray;
@property(nonatomic,strong)FMDatabase *db;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITableView *tableView = (id)[self.view viewWithTag:1];
    UIEdgeInsets contentInset = tableView.contentInset;
    contentInset.top = 20;//调整表视图顶部边缘值
    [tableView setContentInset:contentInset];
    
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)query{
    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:@"tvShow.sqlite"];
    FMDatabase *db=[FMDatabase databaseWithPath:fileName];
    self.nameArray = [[NSMutableArray alloc]init];
    if([db open]){
        // 1.执行查询语句
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM t_show"];
        // 2.遍历结果
        while ([resultSet next]) {
            int ID = [resultSet intForColumn:@"id"];
            NSString *name = [resultSet stringForColumn:@"name"];
            NSString *introduction = [resultSet stringForColumn:@"introduction"];
            NSString *lastDate = [resultSet stringForColumn:@"lastDate"];
            NSLog(@"%d %@ %@ %@", ID, name, introduction,lastDate);
            [self.nameArray addObject:name];
        }
        NSLog(@"self.nameArray == %@",self.nameArray);
    }
}
#pragma -
#pragma UITableView
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return nil;
    }else
    {
        return indexPath;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.nameArray.count+1;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SectionsTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:SectionsTableIdentifier];
    }
    cell.textLabel.text = [self.nameArray objectAtIndex:indexPath.row-1];
    return cell;
}
-(NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return nil;//第一行的时候返回nil
    }else{
        return indexPath;//传递即将选中的行对应的索引
    }
}


@end
