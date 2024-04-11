package net.niuxiaoer.device_identity

import android.content.Context
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** DeviceIdentityPlugin */
class DeviceIdentityPlugin: FlutterPlugin, MethodCallHandler {

  private lateinit var channel : MethodChannel
  private lateinit var deviceIdentityUtil: DeviceIdentityUtil
  private lateinit var context: Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "device_identity")
    channel.setMethodCallHandler(this)

    context = flutterPluginBinding.applicationContext
    deviceIdentityUtil = DeviceIdentityUtil(context);

  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {

    when(call.method) {
      "register" -> {
        deviceIdentityUtil.register()
        result.success(true)
      }
      "getAndroidID" -> {
        result.success(deviceIdentityUtil.getAndroidID())
      }
      "getIMEI" -> {
        result.success(deviceIdentityUtil.getIMEI())
      }
      "getOAID" -> {
        result.success(deviceIdentityUtil.getOAID())
      }
      "getUA" -> {
        result.success(deviceIdentityUtil.getUA())
      }
      "getMac" -> {
        result.success(deviceIdentityUtil.getMacAddress(context))
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
