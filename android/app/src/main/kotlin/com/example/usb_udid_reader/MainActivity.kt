package com.example.usb_udid_reader

import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbManager
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.util.*

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.usb_udid_reader/usb"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Check if flutterEngine is not null and create MethodChannel
        flutterEngine?.dartExecutor?.let {
            MethodChannel(it.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
                if (call.method == "getUdid") {
                    val udid = getConnectedUsbDeviceUdid()
                    if (udid != null) {
                        result.success(udid)
                    } else {
                        result.error("UNAVAILABLE", "No USB device found", null)
                    }
                } else {
                    result.notImplemented()
                }
            }
        }
    }

    private fun getConnectedUsbDeviceUdid(): String? {
        val usbManager = getSystemService(USB_SERVICE) as UsbManager
        val deviceList = usbManager.deviceList
        if (deviceList.isEmpty()) {
            return null
        }

        val iterator: Iterator<UsbDevice> = deviceList.values.iterator()
        while (iterator.hasNext()) {
            val device = iterator.next()
            // Return the USB device ID as a unique identifier (UDID equivalent)
            return "Device ID: ${device.deviceId}"  // Device ID can act as the UDID
        }
        return null
    }
}
