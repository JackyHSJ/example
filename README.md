# frechat-app


## 專案資料夾組成

基本上會是 type-first and feature-next 的擺放方式

<pre>
run_configs/
lib/
├── dialogs/
├── models/
├── screens/
│   ├── activity_browser.dart
│   ├── messenger.dart
│   ├── personal_profile.dart
│   └── strike_up_list.dart
├── system/
│   ├── global.dart
│   ├── providers.dart
│   └── util.dart
├── utils/
├── widgets/
│   ├── activity_browser/
│   │   ├── activity_browser_header.dart
│   │   └── activity_browser_footer.dart
│   ├── messenger/
│   │   ├── messenger_item.dart
│   │   └── messenger_panel.dart
│   ├── personal_profile/
│   │   ├── personal_profile_portrait.dart
│   │   ├── personal_profile_badge.dart
│   │   └── personal_profile_summary.dart
│   └── strike_up_list/
│       ├── strike_up_list_item.dart
│       └── strike_up_list_header.dart
├── main.dart
└── frechat.dart
</pre>

### UI相關

跟介面有關係的是 screens / widgets / dialogs 三個資料夾，也就是所有的 stateless / stateful widget 都只會出現在這三個地方內。

- screens 會是放各個最上層的頁面用。
- widgets 內則是以頁面作為分類再放各頁面專屬的任意子元件。
- dialogs 則是跳窗型 (showDialog) 型元件。

### 系統相關

 - system/global.dart 內會有專案內只需要初始化一次但是到處都會用到的全域物件，像是 SharedPreferences 或者 PackageInfo 這種東西。
 - system/providers.dart 專案內常用型的 provider 請集中放在此處並加上註解。除非你有一個大量提供 provider 的狀況才在其他 feature 資料夾開自己的 provider 檔。
 - system/util.dart 如果你想開很多地方都可能會使用到的方法，請放在這個地方並且加上註解。

### 編譯輸出用 Scripts
run_configs 資料夾底下為方便編譯輸出 ipa/aab/apk 檔案用的 scripts，通常可以用 IDE 的快捷列來跑這些檔案一件輸出所有平台用的安裝檔。輸出的檔案將會以版號以及git分枝名稱命名，放在你的桌面上。

## Git branch 使用方式

**初期只要知道 main 跟 develop 的使用規則即可**

- main: 會保持一份極新隨時可以讓人作為分枝基礎用的內容。
- develop/*: 這個資料夾底下的 branch 為開發獨立功能而建的開發途中型分枝，開發功能達成至目標階段後即可 merge 回 main 並移除。
- production: 出版本專用，出版本時，會在 main 標上版號 tag (0.1.88+88) 後 merge 至 production，負責編譯產出 aab or apk/ipa 的人就使用這個分支的最新版來作業。

參考 [GitLab Flow](https://about.gitlab.com/topics/version-control/what-is-gitlab-flow/)

## 內部工具
  - [Redmine](http://redmine.zyg.com.tw/)
  - [NAS](http://192.168.41.110:5000/)
  - [Android KeyStore](http://192.168.41.110:5000/sharing/GRUHLFTSW)
  - [後端 API 文件](http://apidoc.zyg.com.tw/frechat/frontend/)
  - [UI 設計文件](https://rftpbm.axshare.com/#id=5oi07z)
  - [UI Figma](https://www.figma.com/file/VwL4J3ERBWHOfOjcPeWjIU/%E7%A4%BE%E4%BA%A4-App?type=design&node-id=27%3A4544&mode=design&t=XBRqHiO2MlZGKhvk-1)
  - [審核用後台](http://www.gscjcplive.com/login)

## 登入競品測試用門號
  - 號碼A給 @Benson 登入用 13612215711
  - 號碼B給 @舜傑 登入用 15919122524
  - 號碼C給 @李建輝 登入用 13035198058

## 第三方平台資源收集
- RTC：即构。
  - [Flutter SDK](https://pub.dev/packages/zego_zim/) 
  - [Official Site](https://doc-zh.zego.im/article/15223)
    - Acc: baba666990@gmail.com
    - Pw: Hh666990
- 美颜：杭州相芯科技。(無 Flutter SDK , 但是官方有給 Flutter 使用 Native SDK 範例)
  - [GitHub Flutter Example 即构](https://github.com/Faceunity/FUZegoFlutter)
- Im：网易云。
  - [Flutter SDK](https://pub.dev/packages/nim_core)
  - [Official Site](https://doc.yunxin.163.com/all/api-refer)
- 广告系统：神策。热云两家对比价格，
  - 神策 [Document 含 Flutter SDK 下載連結](https://manual.sensorsdata.cn/sa/latest/flutter-109576737.html)
  - 热云 [Document 含 Flutter SDK 下載連結](http://docs.trackingio.com/flutter.html)
- 一键登录：中国移动。(無 Flutter SDK)
  - [Native SDK](http://dev.10086.cn/numIdentific#sdkdownload)
  - [Android Flutter Example](https://blog.csdn.net/sumsear/article/details/115680451)
  - [開發者後台](http://dev.10086.cn/apmc/consumptionCenter/applicationManagement)
    - Acc: 13035198058
    - Pw: !2345Qwert
- 自动提现：
  - 天津云账户
    - [Official GitHub](https://github.com/YunzhanghuOpen?language=php)
  - 薪宝
    - ???

## 上架平台
- Android：
  - 小米商城
    - [Developer Console](https://dev.mi.com/platform)
    - [Android Store APK](https://www.mi.com/appdownload)
  - 華為 App Gallery
    - [Developer Console](https://developer.huawei.com/consumer/cn/appgallery/)
    - [Android Store APK EN](https://consumer.huawei.com/en/mobileservices/appgallery/)

### 審核用資訊
- 安卓平台软件包名称（包名)
  - com.zyg.frechat

- 安卓公钥
  - 23910168758512879472960808759874102799835507829623381234415791263281821626297239002281290633290908970609318878332834225470040393892272472646875835461917397013631434979198925748121905417129956084128703903624775557287778211320001146657262481253079477896342314033411349423120426387856067869372379529594226778912507644652326738254013747760025208494373156060706019083705060848507968974120777796316189395228343151676948300929172030164768242107969176140651203776056499797203789515961569607968913071324041217004450331691360561575947178334000472898680011318050159121249240738415100729388925412121284082889130471607422367406521

- 安卓证书MD5指纹
  - MD5 Fingerprint: 6D 54 79 BC 97 60 BF 7D E5 9A B7 14 09 9D 7B D7

- IOS平台Bundle ID
  - com.zyg.frechat

- IOS公钥
  - AD 20 19 3E 99 EF A4 45 E7 7F 7C 6F F8 07 B7 68 8D AA BE 2B FA 6F BF 1C 0D 41 36 8C AF FA C3 67 9E 5D 8C BB B8 B1 CB 85 A1 7B AF 83 D9 89 E9 32 BE 44 90 4A E9 4D DC AB 05 85 2B 9E 61 1E BB CF B8 42 80 C1 CE AE BD 97 FF C9 46 46 72 56 0A FE E8 81 29 9E AE 05 BD 70 58 49 8F F5 ED 77 88 3D EB F4 EB 89 B1 E3 5D C4 26 C8 F4 89 FF 69 B7 58 6B 3F 70 18 35 74 DC 9F 3A F6 5C FE CC F2 50 BE 3E C3 EA 1E E9 E5 9A 27 31 41 F1 B9 23 D9 57 0A D0 12 30 FF 40 D6 83 45 B9 CE CE B6 1A 08 29 E1 C4 8D FB 58 FA 38 75 86 C8 FC EE 41 0A 3C E4 E4 7E DA E1 4F F1 26 63 78 BF 8B 3F 55 3B B8 41 E0 04 45 2F C2 F6 29 6A 64 AD A6 BA 2D 90 EB 9D 05 77 AC B5 71 B0 AB 21 9B CA 8D 42 78 9F 04 91 9B 56 AB D1 54 D1 74 B4 2D 68 C8 78 E0 B9 B2 FC 57 0F 98 D6 41 F1 C1 6D 89 62 A9 83 73 09 9C DD FB

- IOS证书SHA-1指纹
  - 95 6C 2D 38 20 6B 8B 1C 6E 77 BE AB D1 C2 89 89 36 E8 6D B6

### 專案寫作哲學

#### 可維護性。
#### 可維護性。
#### 可維護性。

重要的事情說三次。本專案不採用過於酷炫的框架，只要求最基本及重要的工程師素養: 寫出其他人一眼就可以理解的東西，造福你的隊友以及後人。

### Do this:
1. 理解並且擁抱 Flutter 自身的程式碼習性。
2. 建立新類別及變數時使用表達力強，尋找最正確的關鍵字命名。
3. 理解專案資料夾組成，避免找不到東西以及放錯檔案位置的狀況。
4. 分享及介紹你所製作的好用功能給你的隊友，讓他們不需要重新造輪。
5. 了解並且使用你隊友已經替你做好的東西，有需要的話可以請你的隊友擴充功能，而非重新造輪。
6. 要修改隊友的程式碼時，請先與他討論，至少禮貌性告知要做到。
7. pubspec file 需要新增套件時，請註解您的使用場合，以利維護。
8. 有任何問題隨時於頻道發問，解決問題身體才會健康。

### Don't do this:
1. 請不要使用 var 這種懶人變數宣告法，請明確宣告您的變數型態。
2. dynamic 與 object 變數只有在真的有必要的時候才使用。
3. 不鼓勵創造魔法功能，也就是如果你沒有解釋，別人就不會用的東西。

## 綜合下載資源

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Android Studio](https://developer.android.com/studio) or [VSCode](https://code.visualstudio.com/download)
- [Trello](https://trello.com/b/aLEcuvFZ/frechat-app)
- [競品範例](https://apkcombo.com/zh/%E7%BB%87%E6%A2%A6/com.zhiqu.zhimeng/)

## Secrets

- Android release 版本用 keyStore 下載: http://192.168.41.110:5000/sharing/OsGO6U7xl