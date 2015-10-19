//
//  DLTestListTableViewController.m
//  DLGenTechBuildup
//
//  Created by denglong on 15/9/28.
//  Copyright © 2015年 denglong. All rights reserved.
//

#import "DLTestListTableViewController.h"
#import "DLButtonTestViewController.h"
#import "AFNetworking.h"
#import "DLHttpHelper.h"

@interface DLTestListTableViewController ()
@property (nonatomic,strong) NSMutableArray *dataList;/**< 数据容器 */
@end

@implementation DLTestListTableViewController
- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}


- (void)viewDidLoad {
    [super viewDidLoad];
     self.clearsSelectionOnViewWillAppear = NO;
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self initData];
    [self.tableView reloadData];
    
//    [self testRequest];
//    [self testRequestTwo];
//    [self testLogin];
    [self testMineHttp];
    
    [self testActionListRequest];
}

- (void)initData{
    [self.dataList addObject:@(1)];
    [self.dataList addObject:@(2)];
    [self.dataList addObject:@(3)];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    cell.textLabel.text = @"测试";
//    return cell;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"测试";
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        DLButtonTestViewController *btnTestVC = [[DLButtonTestViewController alloc] init];
        [self.navigationController pushViewController:btnTestVC animated:YES];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)testRequest{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json",nil];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript",@"text/plain",nil];
//    NSDictionary *parameters = @{@"appCategory":@"1",@"pageSize":@"20",@"appType":@"2",@"requestKey":@"116444BC70489A89075A5B1226F297C1",@"serviceVersion":@"V1.0.0.0",@"requestTime":@"20151016093603"};
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"2" forKey:@"appCategory"];
    [parameters setObject:@"2" forKey:@"pageSize"];
    
    [parameters setObject:@"2" forKey:@"appType"];
    [parameters setObject:@"116444BC70489A89075A5B1226F297C1" forKey:@"requestKey"];
    [parameters setObject:@"V1.0.0.0" forKey:@"serviceVersion"];
    [parameters setObject:@"20151016093603" forKey:@"requestTime"];

//    NSURL *url = [NSURL URLWithString:@"http://services.ubtrobot.com:8081/opencenter/app/accessGetListByPage"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//        NSLog(@"Error: %@", error);
//    }];
//    [operation start];
    
    NSString *urlString = @"http://services.ubtrobot.com:8081/opencenter/app/accessGetListByPage";
//    NSString *formattingURLStr = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
//    [manager POST:@"http://services.ubtrobot.com:8081/opencenter/app/accessGetListByPage" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        
//    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//        NSLog(@"Error: %@", error);
//    }];
}

- (void)testRequestTwo{
    NSDictionary *parameters = @{@"appCategory":@"1",@"appType":@"1",@"pageSize":@"20",@"requestKey":@"116444BC70489A89075A5B1226F297C1",@"serviceVersion":@"V1.0.0.0",@"requestTime":@"1444981496"};
    NSError *error=nil;
    NSString *url = @"http://10.10.1.12:8081/opencenter/app/accessGetListByPage";
    NSData *jsonRequestDict= [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonCommand=[[NSString alloc] initWithData:jsonRequestDict encoding:NSUTF8StringEncoding];
    NSLog(@"***jsonCommand***%@",jsonCommand);
    
    NSDictionary *params =[NSDictionary dictionaryWithObjectsAndKeys:jsonCommand,@"requestParam", nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];  //AFHTTPResponseSerializer serializer
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error=nil;
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Request Successful, response '%@'", responseStr);
        NSMutableDictionary *jsonResponseDict= [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        NSLog(@"Response Dictionary:: %@",jsonResponseDict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


- (void)testLogin{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript",@"text/plain",nil];
    NSDictionary *parameters = @{@"userName":@"1",@"userPassword":@"1",@"appType":@"1",@"requestKey":@"116444BC70489A89075A5B1226F297C1",@"serviceVersion":@"V1.0.0.0",@"requestTime":@"1444981496"};
    
    [manager POST:@"http://10.10.1.14:8080/ubx/user/login" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)testMineHttp{
    NSString *url = @"http://10.10.1.12:8081/opencenter/app/accessGetListByPage";
    //加入参数
    NSDictionary *parameters = @{@"appCategory":@"1",@"appType":@"2",@"pageSize":@"20",@"requestKey":@"116444BC70489A89075A5B1226F297C1",@"serviceVersion":@"V1.0.0.0",@"requestTime":@"1444981496"};
    //有网络才发送请求
    if([DLHttpHelper NetWorkIsOK]){
        //发送请求，并且得到返回的数据
        [DLHttpHelper post:url RequestParams:parameters FinishBlock:^(NSData *data, NSURLResponse *response, NSError *connectionError) {
            NSLog(@"%@",response);
            NSLog(@"%@",data);
        }];
    }
}

- (void)testActionListRequest{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    NSDictionary *parameters = @{@"actionType":@"2",@"page":@"1",@"appType":@"2",@"requestKey":@"116444BC70489A89075A5B1226F297C1",@"serviceVersion":@"V1.0.0.0",@"requestTime":@"20151016093603"};
    
    NSString *urlString = @"http://10.10.1.14:8080/ubx/action/getListByPage";

    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
