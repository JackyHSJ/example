-keep class **.zego.**{*;}
-keep class **.zego_zpns.** { *; }
-keep class com.google.android.gms.** { *; }

-dontoptimize
-dontpreverify

-dontwarn cn.jpush.**
-keep class cn.jpush.** {*;}
-dontwarn cn.jiguang.**
-keep class cn.jiguang.** {*;}

-dontwarn cn.com.chinatelecom.**
-keep class cn.com.chinatelecom.** {*;}
-dontwarn com.ct.**
-keep class com.ct.** {*;}
-dontwarn a.a.**
-keep class a.a.** {*;}
-dontwarn com.cmic.**
-keep class com.cmic.** {*;}
-dontwarn com.unicom.**
-keep class com.unicom.** {*;}
-dontwarn com.sdk.**
-keep class com.sdk.** {*;}

-dontwarn com.sdk.**
-keep class com.sdk.** {*;}

-dontwarn org.bouncycastle.**
-keep class org.bouncycastle.** {*;}
-keep class a.**{*;}
# reyun sdk
-dontwarn com.reyun.tracking.**
-keep class com.reyun.tracking.** {*;}

#oppo推播
-keep public class * extends android.app.Service
-keep class com.heytap.msp.** { *;}

#小米推播
#-keep class com.xiaomi.mipush.sdk.DemoMessageReceiver {*;}

#华为推播
-ignorewarnings
-keepattributes *Annotation*
-keepattributes Exceptions
-keepattributes InnerClasses
-keepattributes Signature
-keepattributes SourceFile,LineNumberTable
-keep class com.huawei.hianalytics.**{*;}
-keep class com.huawei.updatesdk.**{*;}
-keep class com.huawei.hms.**{*;}

#vivo推播
-dontwarn com.vivo.push.**
-keep class com.vivo.push.**{*; }
-keep class com.vivo.vms.**{*; }

#网易易盾一键登入
-dontwarn com.cmic.sso.sdk.**
-keep class com.cmic.sso.**{*;}
-dontwarn com.sdk.**
-keep class com.sdk.** { *;}
-dontwarn com.unicom.online.account.shield.**
-keep class com.unicom.online.account.shield.** {*;}
-keep class cn.com.chinatelecom.account.**{*;}
-keep public class * extends android.view.View
-keep class com.netease.nis.quicklogin.entity.**{*;}
-keep class com.netease.nis.quicklogin.listener.**{*;}
-keep class com.netease.nis.quicklogin.QuickLogin{
    public <methods>;
    public <fields>;
}
-keep class com.netease.nis.quicklogin.helper.UnifyUiConfig{*;}
-keep class com.netease.nis.quicklogin.helper.UnifyUiConfig$Builder{
     public <methods>;
     public <fields>;
 }
-keep class com.netease.nis.quicklogin.utils.LoginUiHelper$CustomViewListener{
     public <methods>;
     public <fields>;
}
-keep class com.netease.nis.basesdk.**{
    public *;
    protected *;
}


#极光一键登入
        -dontoptimize
        -dontpreverify

        -dontwarn cn.jpush.**
        -keep class cn.jpush.** {*;}
        -dontwarn cn.jiguang.**
        -keep class cn.jiguang.** {*;}

        -dontwarn cn.com.chinatelecom.**
        -keep class cn.com.chinatelecom.** {*;}
        -dontwarn com.ct.**
        -keep class com.ct.** {*;}
        -dontwarn a.a.**
        -keep class a.a.** {*;}
        -dontwarn com.cmic.**
        -keep class com.cmic.** {*;}
        -dontwarn com.unicom.**
        -keep class com.unicom.** {*;}
        -dontwarn com.sdk.**
        -keep class com.sdk.** {*;}

        -dontwarn com.sdk.**
        -keep class com.sdk.** {*;}





