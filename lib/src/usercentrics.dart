import 'package:flutter/foundation.dart';
import 'package:usercentrics_sdk/src/model/model.dart';
import 'package:usercentrics_sdk/src/platform/usercentrics_platform.dart';

/// The the entry point class for Usercentrics SDK.
class Usercentrics {
  Usercentrics._();

  /// The property is visible for testing to allow tests to set a mock
  /// instance directly as a static property since the class is not initialized.
  /// Cached & lazily loaded instance of [UsercentricsPlatform].
  /// By default, it does not get initialized until the user starts using Usercentrics.
  @visibleForTesting
  static UsercentricsPlatform? delegatePackingProperty;

  static UsercentricsPlatform get _delegate {
    return delegatePackingProperty ??= UsercentricsPlatform.instance;
  }

  /// Initialize Usercentrics with the given arguments. Call this method only once in the whole life of the application. If you want to change the configuration and initialize again, please use the [reset] method before.
  /// - The [settingsId] is a Usercentrics generated ID, used to identify a unique CMP configuration.
  /// - The [ruleSetId] is a Usercentrics generated ID, used to identify a set of CMP configurations.
  /// - The [defaultLanguage] sets the default language in the language selection hierarchy. E.g. "en", "de", "fr". The default value is empty.
  /// - The [loggerLevel] provides a set of logs in the standard output depending on the Level: [UsercentricsLoggerLevel.debug] (most detailed logs, includes every other level), [UsercentricsLoggerLevel.warning] (non-problematic operations) and [UsercentricsLoggerLevel.error] (relevant logs to any blocking problems). The default value is [UsercentricsLoggerLevel.none].
  /// - The [timeoutMillis] sets a timeout for network requests in milliseconds. The default value is 10000 milliseconds.
  /// - The [version] freezes the configuration version shown to your users, you may pass a specific version here. E.g. "3.0.4". The default value is "latest".
  /// - The [networkMode] sets the network operation mode. Be careful, use this option only if we have confirmed that it is ready to use because it has a significant impact on the whole system's performance. The default value is "world".
  static void initialize({
    String settingsId = "",
    String ruleSetId = "",
    String? defaultLanguage,
    UsercentricsLoggerLevel? loggerLevel,
    int? timeoutMillis,
    String? version,
    NetworkMode? networkMode,
    bool? consentMediation,
  }) =>
      _delegate.initialize(
        settingsId: settingsId,
        ruleSetId: ruleSetId,
        defaultLanguage: defaultLanguage,
        loggerLevel: loggerLevel,
        timeoutMillis: timeoutMillis,
        version: version,
        networkMode: networkMode,
        consentMediation: consentMediation,
      );

  /// {@template initialize}
  /// Reset Usercentrics to enable the [initialize] again.
  /// {@endtemplate}
  static void reset() => _delegate.reset();

  /// Get the [UsercentricsReadyStatus] to catch the consent status of the user.
  static Future<UsercentricsReadyStatus> get status => _delegate.status;

  /// Show the Banner first layer to **collect** consents.
  /// - The [layout] of the banner.
  /// - The [generalStyleSettings] that enables you to style general paramenters programmatically.
  /// - The [firstLayerSettings] that enables you to style the first layer programmatically.
  /// - The [secondLayerSettings] that enables you to style the second layer programmatically.
  static Future<UsercentricsConsentUserResponse?> showFirstLayer({
    required UsercentricsLayout layout,
    GeneralStyleSettings? generalStyleSettings,
    FirstLayerStyleSettings? firstLayerSettings,
    SecondLayerStyleSettings? secondLayerSettings,
  }) =>
      _delegate.showFirstLayer(
        layout: layout,
        generalStyleSettings: generalStyleSettings,
        firstLayerSettings: firstLayerSettings,
        secondLayerSettings: secondLayerSettings,
      );

  /// Show the Banner second layer to **manage** consents.
  /// - The [generalStyleSettings] that enables you to style general paramenters programmatically.
  /// - The [secondLayerSettings] that enables you to style the second layer programmatically.
  static Future<UsercentricsConsentUserResponse?> showSecondLayer({
    GeneralStyleSettings? generalStyleSettings,
    SecondLayerStyleSettings? secondLayerSettings,
  }) =>
      _delegate.showSecondLayer(
        generalStyleSettings: generalStyleSettings,
        secondLayerSettings: secondLayerSettings,
      );

  /// Get the complete list of [UsercentricsServiceConsent] with the last status of the user.
  static Future<List<UsercentricsServiceConsent>> get consents =>
      _delegate.consents;

  /// Get a Usercentrics generated ID, used to identify a user's consent history.
  static Future<String> get controllerId => _delegate.controllerId;

  /// Restore a user session in another Usercentrics supported platform.
  /// - The [controllerId] is a Usercentrics generated ID, used to identify a user's consent history.
  static Future<UsercentricsReadyStatus> restoreUserSession({
    required String controllerId,
  }) =>
      _delegate.restoreUserSession(controllerId: controllerId);

  /// Get all the CMP Data.
  static Future<UsercentricsCMPData> get cmpData => _delegate.cmpData;

  /// Get the data that needs to be disclosed to the end-user if TCF is enabled.
  static Future<TCFData> get tcfData => _delegate.tcfData;

  /// Get the User's CCPA consent data.
  static Future<CCPAData> get ccpaData => _delegate.ccpaData;

  /// Get the User's Session Data that can be injected in a WebView with Usercentrics Browswer SDK.
  static Future<String> get userSessionData => _delegate.userSessionData;

  /// Set the CMP ID value required by IAB for custom UI.
  static Future<void> setCmpIdForTCF({
    required int id,
  }) =>
      _delegate.setCmpIdForTCF(id: id);

  /// Change the CMP language.
  static Future<void> changeLanguage({
    required String language,
  }) =>
      _delegate.changeLanguage(language: language);

  /// Accept all services.
  static Future<List<UsercentricsServiceConsent>> acceptAll({
    required UsercentricsConsentType consentType,
  }) =>
      _delegate.acceptAll(consentType: consentType);

  /// Accept all services and TCF.
  static Future<List<UsercentricsServiceConsent>> acceptAllForTCF({
    required TCFDecisionUILayer fromLayer,
    required UsercentricsConsentType consentType,
  }) =>
      _delegate.acceptAllForTCF(consentType: consentType, fromLayer: fromLayer);

  /// Deny all services.
  static Future<List<UsercentricsServiceConsent>> denyAll({
    required UsercentricsConsentType consentType,
  }) =>
      _delegate.denyAll(consentType: consentType);

  /// Deny all services and TCF.
  static Future<List<UsercentricsServiceConsent>> denyAllForTCF({
    required TCFDecisionUILayer fromLayer,
    required UsercentricsConsentType consentType,
  }) =>
      _delegate.denyAllForTCF(consentType: consentType, fromLayer: fromLayer);

  /// Save service decisions.
  static Future<List<UsercentricsServiceConsent>> saveDecisions({
    required List<UserDecision> decisions,
    required UsercentricsConsentType consentType,
  }) =>
      _delegate.saveDecisions(decisions: decisions, consentType: consentType);

  /// Save service and TCF decisions.
  static Future<List<UsercentricsServiceConsent>> saveDecisionsForTCF({
    required TCFUserDecisions tcfDecisions,
    required TCFDecisionUILayer fromLayer,
    required List<UserDecision> serviceDecisions,
    required UsercentricsConsentType consentType,
  }) =>
      _delegate.saveDecisionsForTCF(
        tcfDecisions: tcfDecisions,
        fromLayer: fromLayer,
        serviceDecisions: serviceDecisions,
        consentType: consentType,
      );

  /// Save service and CCPA decisions.
  static Future<List<UsercentricsServiceConsent>> saveOptOutForCCPA({
    required bool isOptedOut,
    required UsercentricsConsentType consentType,
  }) =>
      _delegate.saveOptOutForCCPA(
        isOptedOut: isOptedOut,
        consentType: consentType,
      );
}
