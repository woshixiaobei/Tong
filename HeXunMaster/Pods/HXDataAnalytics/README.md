
<!--使用<body>标签来控制整体文本的外边距据左侧150px，为菜单导航留出范围-->
<br><br>
#<center/>和讯大数据SDK iOS客户端集成文档
<br><br>
<body style="margin-left:250px;">

<hr>
<font color=red size=6>**更新日志：**</font>

**Version：v2.3**

Build  | 日期	|	说明
------------- | ------------- | ------------
2.3.1  | 2017-05-15 | 优化从后台进入应用时对缓存页面的事件进行备份。
2.3.0  | 2017-05-08 | 修改启动次数统计规则：打开应用视为启动，完全退出或退至后台即视为退出。

**Version：v2.2**
	
	发布日期：2017-02-28
	功能更新：
	1.修改网络为HTTPS协议。

**Version：v2.1**

	发布日期：2016-10-28
	功能更新：
	1.更新事件统计格式。

**Version：v2.0**

	发布日期：2016-8-20
	功能更新：
	1.取消页面自动统计功能，页面统计交由开发者自行统计：
		1.1、进入页面新增 + (void)beginLogPageView:(NSString *)pageName; 方法
		1.2、离开页面新增 + (void)endLogPageView:(NSString *)pageName; 方法

	2.取消 webURL 自动捕获机制，交由开发者自行统计：
		2.1、关于对web网页地址的统计新增方法 + (void)openWeb:(NSString*)webURL;
		
	3.新增对 api url 的统计
		3.1、新增 + (void)apiURL:(NSString*)url; 方法
	
	4.新增自定义事件统计
		4.1、+ (void)event:(NSString *)eventId;
		4.2、+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes;

	5.提供一套集成统计解决方案
	
	6.HXDataAnalytics.framework 支持 cocoapods 集成管理

<hr>


##<span id=""/>

<div style="position:fixed;  top:30px;left:10px; ">
<br>
<font color=black><b>目录</b></font>
<ol> 
<li><a href="#mark0"> [Xcode8集成说明] </a></li>
<li><a href="#mark1"> [导入SDK] </a></li>
<li><a href="#mark2"> [使用CocoaPods安装SDK] </a></li>
<li><a href="#mark4"> [基本功能集成] </a></li>
<li><a href="#mark5"> [用户登录/退出统计] </a></li>
<li><a href="#mark6"> [页面统计] </a></li>
<li><a href="#mark7"> [自定义事件统计] </a></li>
<li><a href="#mark8"> [web页面地址统计] </a></li>
<li><a href="#mark9"> [接口api地址统计] </a></li>
<li><a href="#mark10"> [方便、快速、高效集成解决方案] </a></li>
</ol>
</div>



<br><br>



###<span id = "mark0" / > 1、Xcode8集成说明

**a)、如果将 Xcode 升级到 8.0 版本以上（包括8.0版本），因大数据SDK中涉及到的数据库加密框架在 Xcode8 编译并运行在采用64位架构的处理器的真机上会发生异常，请使用 CocoaPods 集成大数据SDK。**

**b)、如果目前仍使用 Xcode8.0 以下开发工具，则可直接下载大数据SDK，并按照第2步中提供的方法集成。**

<br><hr><br>

###<span id = "mark1" / > 2、下载并导入SDK
请先前往 [http://bdc.hexun.com/hxsdk/](http://bdc.hexun.com/hxsdk/) 下载SDK
<br>
#####a)、将 HXDataAnalytics.framework 拖入项目中，如图所示：


 ![][2]

<br>
#####b)、在工程目录结构中，设置引用配置：
<font color=red><b>TARGET —> Build Settings —> Other Linker Flags 中添加 -ObjC 如果依然有问题，再添加-all_load</b></font>

![][6]

<br><hr><br>

###<span id = "mark2" / >3、使用 CocoaPods 安装 SDK
CocoaPods 安装完成后，在你的项目根目录创建一个 Podfile 文件，添加如下内容：

	pod 'HXDataAnalytics',:git=>'https://git.oschina.net/oneonelayer/HXDataAnalytics.git'
	
	
在 terminal 中执行如下命令：
	
	pod install
	
**<font color=red>注：</font>** 基于安全性考虑，`HXDataAnalytics`为`私有Spec`并部署在私有`git`仓库管理，若需要使用`CocoaPods`来管理请先前往 [git.oschina.net](http://git.oschina.net) 注册账号，并将注册的`昵称`或`Email`发送至 <wangzishuai@staff.hexun.com> 并抄送 <chenzhijian@staff.hexun.com> 开通git权限（邮件主题：【HXDataAnalytics_iOS 基于 CocoaPods 集成管理权限开通】）

<br><hr><br>




###<span id = "mark4" / > 4、基本功能集成

<br>

**AppDelegate.m** 的配置主要包括填写 `AppID`、`channelId` 两部分，代码示例如下：

	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    	
    	[HXDataAnalytics startWithAppID:@"AppID" channelId:nil];
    	
   		return YES;
	}

##### AppId:

	AppID : 产品人员定义的产品唯一编号
	
	
##### ChannelId:

	应用下载渠道名称,为nil或@""时,默认为@"App Store"渠道。
	
	渠道命名规范：
	可以由英文字母、阿拉伯数字、下划线、中划线、空格、括号组成，可以含汉字以及其他明文字符，但是不建议使用中文命名，可能会出现乱码。
	"App Store" 及其各种大小写形式，作为和讯大数据保留的字段，不可以作为渠道名。
	

##### 
	



<br><hr><br>	
	

###<span id = "mark5" / > 5、用户登录/退出统计
<font color=red>和讯大数据 SDK 在统计用户时以和讯网用户唯一id 为标准：</font>

#####a)、用户登录成功后调用以下接口记录当前用户：

	+ (void)loginCompleteWithUserId:(NSString*)userId;
	
	userId ： 和讯网用户唯一id

#####b)、用户退出登录后调用以下接口注销当前用户：

	+ (void)logoutComplete;
	
	
<br><hr><br>	


###<span id = "mark6" / > 6、页面统计
#####实现页面的统计需要在每个View中配对调用如下方法：

    - (void)viewWillAppear:(BOOL)animated
    {
        [super viewWillAppear:animated];
        
        // 页面统计, 开始统计某个页面.【注：SDK2.0以上版本支持】
        [HXDataAnalytics beginLogPageView:@"PageOne"];//("PageOne"为页面名称，可自定义)
    }
	- (void)viewWillDisappear:(BOOL)animated 
    {
        // 页面统计, 结束统计某个页面.【注：SDK2.0以上版本支持】
        [HXDataAnalytics endLogPageView:@"PageOne"];
        
        [super viewWillDisappear:animated];
    } 	
    
**注意： <font color=red>页面统计集成正确，才能保证统计数据的完整性</font>**
	
	
<br><hr><br>	




###<span id = "mark7" / > 7、自定义事件的统计

#####a)、若单纯只对事件进行统计则使用如下方法：
	
	[HXDataAnalytics event:@"event_002"]; // event_002 为事件 id

#####b)、若需要同时对事件属性进行统计，使用如下方法：
	
	NSDictionary *dict = @{@"type" : @"book", @"quantity" : @"3"};
	[HXDataAnalytics event:@"purchase" attributes:dict];  
	

<br><hr><br>	


###<span id = "mark8" / > 8、web页面地址统计

#####当需要对所请求的 web页面地址进行统计时，使用如下方法：

	[HXDataAnalytics openWeb:@"http://www.hexun.com"];

<br><hr><br>	




###<span id = "mark9" / > 9、接口api地址统计

#####当需要对所请求的 api 地址进行统计时，使用如下方法：

	[HXDataAnalytics apiURL:@"http://www.hexun.com/api/test"]; 
	
	
<br><hr><br>


###<span id = "mark10" / > 10、方便、快速、高效集成解决方案
**<font color=red>注意：</font>** 为方便各事业部方便、快速、高效集成 HXDataAnalytics iOS版本，在此提供两套快速集成解决方案如下：

#####a)、现有项目中已集成友盟统计(UMengAnalytics)解决方案如下：
将 HxSDK_iOS_2.1.1 文件夹下所包含的 UMeng+HXDataAnalytics 文件夹添加进工程项目，并调用 hook 方法：
	
	#import "AppDelegate.h"
	#import <HXDataAnalytics/HXDataAnalytics.h>
	#import "MobClick.h"
	#import "MobClick+HXDataAnalytics.h"


	@interface AppDelegate ()

	@end

	@implementation AppDelegate

	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    	// 调用 hook 方法
    	[MobClick startWithAppkey:@"iOS_1001"];
    	[MobClick hook];
    
	    // 初始化 HXDataAnalytics
    	[HXDataAnalytics startWithAppID:@"iOS_1001" channelId:nil];
    
	    return YES;
	}
	
#####b)、若项目中未集成友盟统计
	
页面统计：建议在基类控制器中进行统计。

webURL、apiURL、事件统计：按需要进行逐个添加。
	
<br><hr><br>







	
</body>

[2]:http://o8smrh7ys.bkt.clouddn.com/HXDataAnalytics_img_2.png "集成SDK"

[3]:http://o8smrh7ys.bkt.clouddn.com/HXDataAnalytics_img_3.png "ATS配置"

[4]:http://o8smrh7ys.bkt.clouddn.com/HXDataAnalytics_img_5.png "embedded binaries"

[6]:http://o8smrh7ys.bkt.clouddn.com/HXDataAnalytics_img_6.png