package com.zyg.frechat

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine
import androidx.annotation.NonNull
//import com.cmic.gen.sdk.auth.GenAuthnHelper
//import com.cmic.gen.sdk.view.GenAuthThemeConfig

import android.app.Service;

import android.app.NotificationManager

import android.app.NotificationChannel

import android.os.Build

import android.content.Intent

import android.os.IBinder

import android.app.Notification







class MainActivity: FlutterActivity() {

//     private var genAuthnHelper: GenAuthnHelper? = null

     override fun onCreate(savedInstanceState: Bundle?) {
          super.onCreate(savedInstanceState)
//          //創建GenAuthnHelper實例
//          genAuthnHelper = GenAuthnHelper.getInstance(this)
//          //打開SDK日誌開關
//          GenAuthnHelper.setDebugMode(true)
//          //初始化授權頁主題
//          //todo 可以測試註解是否正常運行，Androidmanifest Activity是否可以拿掉
//          genAuthnHelper?.setAuthThemeConfig(GenAuthThemeConfig.Builder().build())

     }

     override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
          super.configureFlutterEngine(flutterEngine)
          ZegoBeautyPlugin(flutterEngine.dartExecutor.binaryMessenger, context)
          MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "example.com/channel").setMethodCallHandler {
                    call, result ->
               //中國移動一鍵登陸
               if(call.method == "loginAuth") {
//                    loginAuth(result)
               }
               else {
                    result.notImplemented()
               }
          }
     }

     //調用中國移動登陸認證SDK
//     private fun loginAuth(result: MethodChannel.Result) {
//          genAuthnHelper!!.loginAuth("", "") { i, jsonObject ->
//               try {
//                    val resultCode = jsonObject.optString("resultCode", "沒有返回碼")
//                    result.success(resultCode)
//               } catch (e: Exception) {
//                    e.printStackTrace()
//               }
//          }
//     }

}


class MyForegroundService : Service() {
     companion object {
          const val CHANNEL_ID = "VoiceAndVideoCallChannel"
     }

     override fun onCreate() {
          super.onCreate()
          createNotificationChannel()
          val notification = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
               Notification.Builder(this, CHANNEL_ID)
                       .build()
          } else {
               TODO("VERSION.SDK_INT < O")
          }
          startForeground(1, notification)
     }

     override fun onBind(intent: Intent): IBinder? {
          return null
     }

     private fun createNotificationChannel() {
          if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
               val serviceChannel = NotificationChannel(
                       CHANNEL_ID,
                       "語音與視訊離線通知權限",
                       NotificationManager.IMPORTANCE_DEFAULT
               )

               val manager = getSystemService(NotificationManager::class.java)
               manager?.createNotificationChannel(serviceChannel)
          }
     }
}