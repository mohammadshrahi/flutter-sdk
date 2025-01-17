import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:usercentrics_sdk/src/internal/bridge/bridge.dart';
import 'package:usercentrics_sdk/src/model/logger_level.dart';
import 'package:usercentrics_sdk/src/model/network_mode.dart';

void main() {
  // Data from the debugger
  const mockResponse = null;
  const expectedArguments = {
    "settingsId": "Yi9N3aXia",
    "ruleSetId": "XXxXXXYYyyyYY",
    "defaultLanguage": "en",
    "loggerLevel": "DEBUG",
    "version": "1.0.0",
    "timeoutMillis": 20000,
    "networkMode": "EU",
    'consentMediation': true
  };
  const mockSettingsId = 'Yi9N3aXia';
  const mockRuleSetId = 'XXxXXXYYyyyYY';
  const mockLoggerLevel = UsercentricsLoggerLevel.debug;
  const mockVersion = "1.0.0";
  const mockDefaultLanguage = "en";
  const mockTimeoutMillis = 20000;
  const mockNetworkMode = NetworkMode.eu;
  const mockConsentMediation = true;

  const MethodChannel channel = MethodChannel('usercentrics');
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() async {
    channel.setMockMethodCallHandler(null);
  });

  test('invoke', () {
    int callCounter = 0;
    MethodCall? receivedCall;
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      callCounter++;
      receivedCall = methodCall;
      return mockResponse;
    });
    const instance = MethodChannelInitialize();

    instance.invoke(
        channel: channel,
        settingsId: mockSettingsId,
        ruleSetId: mockRuleSetId,
        loggerLevel: mockLoggerLevel,
        version: mockVersion,
        defaultLanguage: mockDefaultLanguage,
        timeoutMillis: mockTimeoutMillis,
        networkMode: mockNetworkMode,
        consentMediation: mockConsentMediation);

    expect(callCounter, 1);
    expect(receivedCall?.method, 'initialize');
    expect(receivedCall?.arguments, expectedArguments);
  });
}
