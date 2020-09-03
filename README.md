# zeking_flash_lamp

Flutter 闪光灯操作

此插件是 在 lamp 的基础上修改的，因为 lamp 的android端无法正常工作
附上lamp地址：https://pub.dev/packages/lamp

example的代码也是直接 拷贝 lamp 过来。

// Import package
import 'package:zeking_flash_lamp/zeking_flash_lamp.dart';

// Turn the lamp on:
ZekingFlashLamp.turnOn();

// Turn the lamp off:
ZekingFlashLamp.turnOff();

// Turn the lamp with a specific intensity (only affects iOS as of now):
ZekingFlashLamp.turnOn(intensity: 0.4);

// Check if the device has a lamp:
bool hasLamp = await ZekingFlashLamp.hasLamp;