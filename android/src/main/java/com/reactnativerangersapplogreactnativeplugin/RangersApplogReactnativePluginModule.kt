package com.reactnativerangersapplogreactnativeplugin

import android.text.TextUtils
import com.bytedance.applog.AppLog
import com.bytedance.applog.InitConfig
import com.bytedance.applog.UriConfig
import com.facebook.react.bridge.*
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject
import java.util.*


class RangersApplogReactnativePluginModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

  override fun getName(): String {
    return "RangersAppLogModule"
  }

  @ReactMethod
  fun init(appId: String, channel: String, enableAb: Boolean, autoStart: Boolean, enableEncrypt: Boolean, host: String?, promise: Promise) {
    val initConfig: InitConfig = InitConfig(appId, channel)
    initConfig.setAutoStart(autoStart)
    initConfig.isAbEnable = enableAb
    if (!TextUtils.isEmpty(host)) {
      initConfig.setUriConfig(UriConfig.createByDomain(host, null))
    }
    AppLog.setEncryptAndCompress(enableEncrypt)
    AppLog.init(reactApplicationContext, initConfig)
  }

  @ReactMethod
  fun start(promise: Promise) {
    AppLog.start()
  }

  @ReactMethod
  fun profileAppend(params: ReadableMap, promise: Promise) {
    AppLog.profileAppend(readableMapToJson(params))
  }

  @ReactMethod
  fun profileIncrement(params: ReadableMap, promise: Promise) {
    AppLog.profileIncrement(readableMapToJson(params))
  }

  @ReactMethod
  fun profileSet(params: ReadableMap, promise: Promise) {
    AppLog.profileSet(readableMapToJson(params))
  }

  @ReactMethod
  fun profileSetOnce(params: ReadableMap, promise: Promise) {
    AppLog.profileSetOnce(readableMapToJson(params))
  }

  @ReactMethod
  fun profileUnset(key: String, promise: Promise) {
    AppLog.profileUnset(key)
  }

  @ReactMethod
  fun onEventV3(event: String, params: ReadableMap, promise: Promise) {
    AppLog.onEventV3(event, readableMapToJson(params))
  }

  @ReactMethod
  fun setHeaderInfo(headerInfo: ReadableMap, promise: Promise) {
    AppLog.setHeaderInfo(headerInfo.toHashMap())
  }

  @ReactMethod
  fun setUserUniqueId(id: String, promise: Promise) {
    AppLog.setUserUniqueID(id)
  }

  @ReactMethod
  fun getAbSdkVersion(promise: Promise) {
    promise.resolve(AppLog.getAbSdkVersion())
  }

  @ReactMethod
  fun getABTestConfigValueForKey(key: String, defaultValue: String?, promise: Promise) {
    promise.resolve(AppLog.getAbConfig(key, defaultValue))
  }

  @ReactMethod
  fun removeHeaderInfo(key: String, promise: Promise) {
    AppLog.removeHeaderInfo(key)
  }

  @ReactMethod
  fun getDeviceID(promise: Promise) {
    promise.resolve(AppLog.getDid())
  }

  @ReactMethod
  fun getAllAbTestConfigs(promise: Promise) {
    promise.resolve(AppLog.getAllAbTestConfigs())
  }

  fun readableMapToJson(readableMap: ReadableMap?): JSONObject? {
    val jsonObject = JSONObject()
    if (readableMap == null) {
      return null
    }
    val iterator = readableMap.keySetIterator()
    if (!iterator.hasNextKey()) {
      return null
    }
    while (iterator.hasNextKey()) {
      val key = iterator.nextKey()
      val readableType = readableMap.getType(key)
      try {
        when (readableType) {
          ReadableType.Null -> jsonObject.put(key, null)
          ReadableType.Boolean -> jsonObject.put(key, readableMap.getBoolean(key))
          ReadableType.Number -> jsonObject.put(key, readableMap.getInt(key))
          ReadableType.String -> jsonObject.put(key, readableMap.getString(key))
          ReadableType.Map -> jsonObject.put(key, readableMapToJson(readableMap.getMap(key)))
          ReadableType.Array -> jsonObject.put(key, convertArrayToJson(readableMap.getArray(key)))
          else -> {
          }
        }
      } catch (ex: JSONException) {
      }
    }
    return jsonObject
  }

  @Throws(JSONException::class)
  private fun convertArrayToJson(readableArray: ReadableArray?): JSONArray? {
    val array = JSONArray()
    for (i in 0 until readableArray!!.size()) {
      when (readableArray.getType(i)) {
        ReadableType.Null -> {
        }
        ReadableType.Boolean -> array.put(readableArray.getBoolean(i))
        ReadableType.Number -> array.put(readableArray.getInt(i))
        ReadableType.String -> array.put(readableArray.getString(i))
        ReadableType.Map -> array.put(readableMapToJson(readableArray.getMap(i)))
        ReadableType.Array -> array.put(convertArrayToJson(readableArray.getArray(i)))
      }
    }
    return array
  }
}
