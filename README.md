# flutter_native
flutter和原生项目混合开发 
现在Flutter属于试水阶段，要是想在商业app中使用Flutter，目前基本上是将Flutter的页面嵌入到目前先有的iOS或者安卓工程，目前讲混合开发的文章有很多：

[Flutter新锐专家之路：混合开发篇](https://juejin.im/post/5b764acb51882532dc1812b1)

[Flutter混合工程改造实践](https://juejin.im/post/5b3f098ce51d45199840f4bb)

[Flutter混合工程开发探究](https://juejin.im/post/5b55819ef265da0f8d36615e)

[Now直播iOS Flutter混合工程实践](https://juejin.im/post/5b6cea3c6fb9a04fca3ca608)

不过这些文章大多讲的是安卓和flutter混合开发的，或者单一的iOS和flutter的 试了一下Flutter混合开发，有一些坑，总结给大家


##  目的

既然用Flutter混合开发，那肯定是希望写一套代码，安卓iOS都能无负担运行，所以在开发的时候，需要满足如下需求：

*   Flutter、iOS、安卓工程的目录在同一级，互相之前平级、无嵌套
*   开发iOS的时候，不用操心Flutter部分，只用xcode点击运行就可以（即修改编译iOS项目时，使用编译好的Flutter产物）
*   开发Flutter的时候，不用操心iOS部分，只用android studio点击运行就可以
*   支持模拟器和真机

混合开发最权威的指南当然是[flutter自己的wiki](https://github.com/flutter/flutter/wiki/Add-Flutter-to-existing-apps)

### iOS端集成

#### 1.第一步:新建目录,新建flutter项目
新建目录:
把iOS,安卓项目放进去.然后创建flutter_module
`flutter create -t module xxx`
目录结构:
flutter:
![imagepng](http://img.lishunfeng.top//file/2019/07/c2d6f24e74774b03b457274a92cba275_image.png) 
iOS:
![imagepng](http://img.lishunfeng.top//file/2019/07/f7e9540fc06a458195e329ff8f814d6c_image.png) 
安卓:
![imagepng](http://img.lishunfeng.top//file/2019/07/3900715c022b4708b3bd37fc1ed4e236_image.png) 

#### 1.pod集成
```
_## ==============Flutter ==============_

_## Flutter 模块的路径 pod update --verbose --no-repo-update_

_##绝对路径_

flutter_application_path = '/Users/lishunfeng/Desktop/flutter_ios/Flutter_module'

eval(File.read(File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')), binding)

_## ==============Flutter ==============_
```
pod install即可
![imagepng](http://img.lishunfeng.top//file/2019/07/ac861040c5b84b679fa30f764dea7034_image.png) 

#### 3.add 脚本
```
"$FLUTTER_ROOT/packages/flutter_tools/bin/xcode_backend.sh" build
"$FLUTTER_ROOT/packages/flutter_tools/bin/xcode_backend.sh" embed
```
![imagepng](http://img.lishunfeng.top//file/2019/07/f7dea782773c45caac85508b639294de_image.png) 
#### 4.跳转页面  或者 设置根页面

关键代码:
```
FlutterViewController* flutterViewController = [[FlutterViewController alloc] initWithProject:**nil** nibName:**nil** bundle:**nil**];

self.window.rootViewController = flutterViewController;

```
![imagepng](http://img.lishunfeng.top//file/2019/07/aa9c3f015b88432f9c8e9711b6c5b58d_image.png) 



![imagepng](http://img.lishunfeng.top//file/2019/07/477fd5f47cc04ebc8e496b3571763708_image.png) 

#### 5.运行项目即可
![imagepng](http://img.lishunfeng.top//file/2019/07/3fc5aba513704e7eb8705bbd7e175ad5_image.png) 

### Andorid端集成
#### 1.在settings.gradle添加代码
```
setBinding(new Binding([gradle: this]))
evaluate(new File(
  settingsDir.parentFile,
        "Flutter_module/.android/include_flutter.groovy"
))
```
![imagepng](http://img.lishunfeng.top//file/2019/07/8df5f98da9fd4fcab3729df9ee586da1_image.png) 


#### 2.在app里build..gradle

```
compileOptions {
  sourceCompatibility = '1.8'
  targetCompatibility = '1.8'
}

dependencies {
  implementation project(':flutter')
}

```


![imagepng](http://img.lishunfeng.top//file/2019/07/9b7edd75cf54495babb7efe9ed5b050b_image.png) 



#### 3.跳转到flutter页面
1.第一种:
布局:

xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
  android:layout_width="match_parent"
  android:layout_height="match_parent"
  android:orientation="vertical">

 <Button
  android:id="@+id/btn"
  android:layout_width="match_parent"
  android:layout_height="wrap_content"
  android:layout_marginTop="50dp"
  android:text="点击我" />

 <RelativeLayout
  android:id="@+id/rl_root_view"
  android:layout_width="match_parent"
  android:layout_height="match_parent">RelativeLayout>

<\/LinearLayout>



![imagepng](http://img.lishunfeng.top//file/2019/07/853db841e8fe4ff58812d517082efde3_image.png) 


代码:

--------------------------------

package com.example.fndroid;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;

import io.flutter.facade.Flutter;
import io.flutter.view.FlutterView;

public class MainActivity extends AppCompatActivity {

  @Override
  protected void onCreate(Bundle savedInstanceState) {
  super.onCreate(savedInstanceState);
  setContentView(R.layout.activity_main);
  RelativeLayout rl = findViewById(R.id.rl_root_view);
  findViewById(R.id.btn).setOnClickListener(new View.OnClickListener() {
  @Override
  public void onClick(View v) {
  startActivity(new Intent(MainActivity.this,HomeActivity.class));
  }
 });
  View flutterView = Flutter.createView(MainActivity.this, getLifecycle(), "route1");
  rl.addView(flutterView);

  }
}
----------

![imagepng](http://img.lishunfeng.top//file/2019/07/ddcf3b9d01aa408b900a22cf16aa60e1_image.png) 

![imagepng](http://img.lishunfeng.top//file/2019/07/6e7c1c5c2ae642d0bb940b186c23dfb1_image.png) 


第二种:
![imagepng](http://img.lishunfeng.top//file/2019/07/497b82c0a69949178c7bb44ff6311a99_image.png) 

![imagepng](http://img.lishunfeng.top//file/2019/07/3a878273f48c4f88ba4e3631fb5171be_image.png) 

#### 4.运行效果:

![imagepng](http://img.lishunfeng.top//file/2019/07/9178f6518e09437289f3754d296875d3_image.png) 

### 总结
通过上面的一些讲解，相信就能够使用native+flutter的混合开发了。但细心一点就会发现，
在前面的讲解中，flutter模块并没有与native项目进行通信，那么该如何通信尼？在笔者的下一篇文章会进行详细讲解。




