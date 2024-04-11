package net.niuxiaoer.device_identity

import android.annotation.SuppressLint
import android.app.Application
import android.content.Context
import android.net.wifi.WifiInfo
import android.net.wifi.WifiManager
import android.os.Build
import com.github.gzuliyujiang.oaid.DeviceID
import com.github.gzuliyujiang.oaid.DeviceIdentifier
import java.io.BufferedReader
import java.io.FileReader
import java.io.IOException
import java.net.NetworkInterface
import java.util.Collections
import java.util.Locale

class DeviceIdentityUtil(private val context: Context) {

    // 在`Application#onCreate`里初始化，注意APP合规性，若最终用户未同意隐私政策则不要调用
    fun register() {
        DeviceIdentifier.register(context as? Application)
    }

    // 获取安卓ID，可能为空
    fun getAndroidID(): String {
        return DeviceIdentifier.getAndroidID(context)
    }

    // 获取IMEI，只支持Android 10之前的系统，需要READ_PHONE_STATE权限，可能为空
    fun getIMEI(): String {
        return DeviceIdentifier.getIMEI(context)
    }

    // 获取OAID/AAID，同步调用
    fun getOAID(): String {
        if (DeviceID.supportedOAID(context)) {
            return DeviceIdentifier.getOAID(context)
        }

        return ""
    }

    // 获取UA
    fun getUA(): String? {
        return System.getProperty("http.agent")
    }


    /**
     * 获取MAC地址
     *
     * @param context
     * @return
     */
    fun getMacAddress(context: Context?): String {
        return when {
            Build.VERSION.SDK_INT < Build.VERSION_CODES.M -> {
                getMacDefault(context)
            }

            Build.VERSION.SDK_INT < Build.VERSION_CODES.N -> {
                getMacAddressM()
            }

            else -> {
                getMacFromHardware()
            }
        }
    }


    /**
     * Android  6.0 之前（不包括6.0）
     *
     * @param context
     * @return
     */
    @SuppressLint("HardwareIds")
    private fun getMacDefault(context: Context?): String {
        var mac = "未获取到设备Mac地址"
        if (context == null) return mac

        val wifi = context.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
        var info: WifiInfo? = null
        try {
            info = wifi.connectionInfo
        } catch (e: Exception) {
            e.printStackTrace()
        }
        if (info == null) return mac
        mac = info.macAddress

        if (mac.isNotEmpty()) mac = mac.uppercase(Locale.ENGLISH)

        return mac
    }

    /**
     * Android 6.0（包括） - Android 7.0（不包括）
     *
     * @return
     */
    private fun getMacAddressM(): String {
        var mac = ""

        try {
            mac = BufferedReader(FileReader("/sys/class/net/wlan0/address")).readLine()
        } catch (e: IOException) {
            e.printStackTrace()
        }

        return mac
    }

    /**
     * 遍历循环所有的网络接口，找到接口是 wlan0
     *
     * @return
     */
    private fun getMacFromHardware(): String {
        try {
            val all: List<NetworkInterface> =
                Collections.list(NetworkInterface.getNetworkInterfaces())

            for (nif in all) {
                if (!nif.name.equals("wlan0", ignoreCase = true)) continue

                val macBytes = nif.hardwareAddress ?: return ""

                val res1 = StringBuilder()
                for (b in macBytes) {
                    res1.append(String.format("%02X:", b))
                }

                if (res1.isNotEmpty()) {
                    res1.deleteCharAt(res1.length - 1)
                }
                return res1.toString()
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return ""
    }

}