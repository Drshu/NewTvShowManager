//
//  DetailViewController.h
//  NewTvShowManager
//
//  Created by shucheng on 16/4/6.
//  Copyright © 2016年 shucheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong,nonatomic) NSString *showName;
@property(strong,nonatomic)  NSString *showIntroduction;
@property(strong,nonatomic) NSString *lastDate;
@property(strong,nonatomic) NSString *allDate;
@end
