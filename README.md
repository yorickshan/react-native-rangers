# react native rangers

A RangersAppLog plugin for React Native forked from rangers_applog_reactnative_plugin

>
>
>  在使用 RangersAppLog SDK 前，你需要先[注册DataRangers账号](https://datarangers.com.cn/help/doc?lid=1867&did=40001)并且创建一个应用。
>


## 1. 插件安装与初始化

### iOS
1. 安装插件
2. 在iOS原生工程的Podfile中依赖RangersAppLog. 参考[example/ios/Podfile](example/ios/Podfile)
3. 在iOS原生工程的AppDelegate.m中初始化RangersAppLog. 参考[example/ios/RangersApplogReactnativePluginExample/AppDelegate.m](example/ios/RangersApplogReactnativePluginExample/AppDelegate.m)
4. 可以参考(1)插件源码[ios/RangersAppLogModule.m](ios/RangersAppLogModule.m) (2)测试RN文件[example/src/App.tsx](example/src/App.tsx)中的调用方式使用调用插件接口。

### Android
1. 安装插件
2. 在Android原生工程中依赖RangersAppLog. 参考example/android/build.gradle
3. 在Android原生工程的Application中初始化RangersAppLog. 参考example/android/MainApplication中的onCreate初始化
4. 测试RN文件[example/src/App.tsx](example/src/App.tsx)中的调用方式使用调用插件接口。

## 2. 插件接口文档

| 接口名                     | 功能                              | 参数                                                        | 支持平台     |
|----------------------------|-----------------------------------|-------------------------------------------------------------|--------------|
| setUserUniqueId            | 设置用户登录 Id                   | 参数1：string，可空。user_unique_id。                       | iOS, Android |
| setHeaderInfo              | 自定义header信息 设置用户公共属性 | 参数1：字典，可空。自定义header信息。                       | iOS, Android |
| onEventV3                  | 生成自定义埋点                    | 参数1：string，非空。事件名。 参数2：字典，可空。事件参数。 | iOS, Android |
| getDeviceID                | 获取did                   | 参数：无 返回：str。                                        | iOS, Android          |
| getAbSdkVersion            | 获取全部客户端和服务端已曝光参数  | 参数：无 返回：str                                          | iOS, Android          |
| getABTestConfigValueForKey | 获取AB测试的配置，若不存在返回nil | 参数1: str, ABTest配置的key 返回：str或nil                  | iOS, Android          |


## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
