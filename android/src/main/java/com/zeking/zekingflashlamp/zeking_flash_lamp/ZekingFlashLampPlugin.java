package com.zeking.zekingflashlamp.zeking_flash_lamp;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import android.content.Context;
import android.hardware.Camera;
import android.content.pm.PackageManager;
import android.hardware.camera2.CameraAccessException;
import android.hardware.camera2.CameraCharacteristics;
import android.hardware.camera2.CameraManager;
import android.os.Build;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** ZekingFlashLampPlugin */
@RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
public class ZekingFlashLampPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    _camera = getCamera();
    mContext = flutterPluginBinding.getApplicationContext();

    // FlutterRegistrar

    channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "zeking_flash_lamp");
    channel.setMethodCallHandler(this);
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  public static void registerWith(Registrar registrar) {
    _camera = getCamera();
    mContext = registrar.activeContext();
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "zeking_flash_lamp");
    channel.setMethodCallHandler(new ZekingFlashLampPlugin());
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
//    if (call.method.equals("getPlatformVersion")) {
//      result.success("Android " + android.os.Build.VERSION.RELEASE);
//    } else {
//      result.notImplemented();
//    }

    if (call.method.equals("turnOn")) {
      this.turn(true);
      result.success(null);
    } else if(call.method.equals("turnOff")){
      this.turn(false);
      result.success(null);
    } else if(call.method.equals("hasLamp")){
      result.success(this.hasLamp());
    }else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  // =====================================================================================

  private static Camera _camera;
  private static Context mContext;


  private static Camera getCamera() {
    try {
      return Camera.open();
    } catch (Exception e) {
      System.out.println("Failed to get camera : " + e.toString());
      return null;
    }
  }

  private void turn(boolean on) {

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
      try {
        //获取CameraManager
        CameraManager mCameraManager = (CameraManager) mContext.getSystemService(Context.CAMERA_SERVICE);
        //获取当前手机所有摄像头设备ID
        String[] ids  = mCameraManager.getCameraIdList();
        for (String id : ids) {
          CameraCharacteristics c = mCameraManager.getCameraCharacteristics(id);
          //查询该摄像头组件是否包含闪光灯
          Boolean flashAvailable = c.get(CameraCharacteristics.FLASH_INFO_AVAILABLE);
          Integer lensFacing = c.get(CameraCharacteristics.LENS_FACING);
          if (flashAvailable != null && flashAvailable
                  && lensFacing != null && lensFacing == CameraCharacteristics.LENS_FACING_BACK) {
            //打开或关闭手电筒
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
              mCameraManager.setTorchMode(id, on);
            }
          }
        }
      } catch (CameraAccessException e) {
        e.printStackTrace();
      }
    }else{
      Camera.Parameters params;
      if (_camera == null || !hasLamp()) {
        return;
      }
      params = _camera.getParameters();
      params.setFlashMode(on ? Camera.Parameters.FLASH_MODE_TORCH : Camera.Parameters.FLASH_MODE_OFF);
      _camera.setParameters(params);
      if (on) {
        _camera.startPreview();
      } else {
        _camera.stopPreview();
      }
    }
  }

  private boolean hasLamp() {
    return mContext.getPackageManager().hasSystemFeature(PackageManager.FEATURE_CAMERA_FLASH);
  }



}
