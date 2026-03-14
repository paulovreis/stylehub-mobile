import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('pt'),
    Locale('pt', 'BR')
  ];

  /// No description provided for @appName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Beauty Salon'**
  String get appName;

  /// No description provided for @commonContinue.
  ///
  /// In pt_BR, this message translates to:
  /// **'Continuar'**
  String get commonContinue;

  /// No description provided for @commonValidate.
  ///
  /// In pt_BR, this message translates to:
  /// **'Validar'**
  String get commonValidate;

  /// No description provided for @commonSave.
  ///
  /// In pt_BR, this message translates to:
  /// **'Salvar'**
  String get commonSave;

  /// No description provided for @commonRetry.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tentar novamente'**
  String get commonRetry;

  /// No description provided for @commonCancel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cancelar'**
  String get commonCancel;

  /// No description provided for @commonLoading.
  ///
  /// In pt_BR, this message translates to:
  /// **'Carregando…'**
  String get commonLoading;

  /// No description provided for @selectSalonTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Selecione seu salão'**
  String get selectSalonTitle;

  /// No description provided for @selectSalonUrlLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'URL do salão'**
  String get selectSalonUrlLabel;

  /// No description provided for @selectSalonSlugLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Código do salão'**
  String get selectSalonSlugLabel;

  /// No description provided for @selectSalonHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cole a URL completa ou digite o código do salão.'**
  String get selectSalonHint;

  /// No description provided for @selectSalonInvalid.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível validar este salão.'**
  String get selectSalonInvalid;

  /// No description provided for @loginTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Entrar'**
  String get loginTitle;

  /// No description provided for @loginEmail.
  ///
  /// In pt_BR, this message translates to:
  /// **'E-mail'**
  String get loginEmail;

  /// No description provided for @loginPassword.
  ///
  /// In pt_BR, this message translates to:
  /// **'Senha'**
  String get loginPassword;

  /// No description provided for @loginSubmit.
  ///
  /// In pt_BR, this message translates to:
  /// **'Entrar'**
  String get loginSubmit;

  /// No description provided for @loginCreateAccount.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criar conta'**
  String get loginCreateAccount;

  /// No description provided for @loginForgotPassword.
  ///
  /// In pt_BR, this message translates to:
  /// **'Esqueci minha senha'**
  String get loginForgotPassword;

  /// No description provided for @registerTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criar conta'**
  String get registerTitle;

  /// No description provided for @registerName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nome'**
  String get registerName;

  /// No description provided for @registerPhone.
  ///
  /// In pt_BR, this message translates to:
  /// **'Telefone'**
  String get registerPhone;

  /// No description provided for @registerSubmit.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criar conta'**
  String get registerSubmit;

  /// No description provided for @forgotTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Recuperar senha'**
  String get forgotTitle;

  /// No description provided for @forgotSubmit.
  ///
  /// In pt_BR, this message translates to:
  /// **'Enviar'**
  String get forgotSubmit;

  /// No description provided for @forgotSuccess.
  ///
  /// In pt_BR, this message translates to:
  /// **'Se existir uma conta, enviaremos instruções.'**
  String get forgotSuccess;

  /// No description provided for @resetTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Redefinir senha'**
  String get resetTitle;

  /// No description provided for @resetToken.
  ///
  /// In pt_BR, this message translates to:
  /// **'Token'**
  String get resetToken;

  /// No description provided for @resetNewPassword.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nova senha'**
  String get resetNewPassword;

  /// No description provided for @resetConfirmPassword.
  ///
  /// In pt_BR, this message translates to:
  /// **'Confirmar senha'**
  String get resetConfirmPassword;

  /// No description provided for @resetSubmit.
  ///
  /// In pt_BR, this message translates to:
  /// **'Redefinir'**
  String get resetSubmit;

  /// No description provided for @resetPasswordsMismatch.
  ///
  /// In pt_BR, this message translates to:
  /// **'As senhas não conferem.'**
  String get resetPasswordsMismatch;

  /// No description provided for @resetSuccess.
  ///
  /// In pt_BR, this message translates to:
  /// **'Senha redefinida com sucesso.'**
  String get resetSuccess;

  /// No description provided for @homeTabHome.
  ///
  /// In pt_BR, this message translates to:
  /// **'Início'**
  String get homeTabHome;

  /// No description provided for @homeTabAppointments.
  ///
  /// In pt_BR, this message translates to:
  /// **'Agendamentos'**
  String get homeTabAppointments;

  /// No description provided for @homeTabNotifications.
  ///
  /// In pt_BR, this message translates to:
  /// **'Notificações'**
  String get homeTabNotifications;

  /// No description provided for @homeTabProfile.
  ///
  /// In pt_BR, this message translates to:
  /// **'Perfil'**
  String get homeTabProfile;

  /// No description provided for @dashboardNextAppointment.
  ///
  /// In pt_BR, this message translates to:
  /// **'Próximo agendamento'**
  String get dashboardNextAppointment;

  /// No description provided for @dashboardNoAppointments.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhum agendamento por enquanto.'**
  String get dashboardNoAppointments;

  /// No description provided for @appointmentsUpcoming.
  ///
  /// In pt_BR, this message translates to:
  /// **'Próximos'**
  String get appointmentsUpcoming;

  /// No description provided for @appointmentsHistory.
  ///
  /// In pt_BR, this message translates to:
  /// **'Histórico'**
  String get appointmentsHistory;

  /// No description provided for @notificationsMarkAll.
  ///
  /// In pt_BR, this message translates to:
  /// **'Marcar todas como lidas'**
  String get notificationsMarkAll;

  /// No description provided for @notificationsEmpty.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhuma notificação.'**
  String get notificationsEmpty;

  /// No description provided for @notificationsDefaultTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Notificação'**
  String get notificationsDefaultTitle;

  /// No description provided for @notificationsMarkedAllRead.
  ///
  /// In pt_BR, this message translates to:
  /// **'Notificações marcadas como lidas.'**
  String get notificationsMarkedAllRead;

  /// No description provided for @profileTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Perfil'**
  String get profileTitle;

  /// No description provided for @profileNameLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nome'**
  String get profileNameLabel;

  /// No description provided for @profileEmailLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'E-mail'**
  String get profileEmailLabel;

  /// No description provided for @profilePhoneLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Telefone'**
  String get profilePhoneLabel;

  /// No description provided for @profileNameRequired.
  ///
  /// In pt_BR, this message translates to:
  /// **'Informe seu nome.'**
  String get profileNameRequired;

  /// No description provided for @profileEmailRequired.
  ///
  /// In pt_BR, this message translates to:
  /// **'Informe seu e-mail.'**
  String get profileEmailRequired;

  /// No description provided for @profileEmailInvalid.
  ///
  /// In pt_BR, this message translates to:
  /// **'E-mail inválido.'**
  String get profileEmailInvalid;

  /// No description provided for @profilePhoneInvalid.
  ///
  /// In pt_BR, this message translates to:
  /// **'Telefone inválido.'**
  String get profilePhoneInvalid;

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dados atualizados.'**
  String get profileUpdatedSuccess;

  /// No description provided for @profileUpdatedError.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível salvar. Tente novamente.'**
  String get profileUpdatedError;

  /// No description provided for @profileLogoutConfirm.
  ///
  /// In pt_BR, this message translates to:
  /// **'Deseja sair da sua conta?'**
  String get profileLogoutConfirm;

  /// No description provided for @profileChangeSalonConfirm.
  ///
  /// In pt_BR, this message translates to:
  /// **'Você sairá da conta e escolherá outro salão.'**
  String get profileChangeSalonConfirm;

  /// No description provided for @profileChangeSalon.
  ///
  /// In pt_BR, this message translates to:
  /// **'Trocar salão'**
  String get profileChangeSalon;

  /// No description provided for @profileLogout.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sair'**
  String get profileLogout;

  /// No description provided for @bookingServiceTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escolha um serviço'**
  String get bookingServiceTitle;

  /// No description provided for @bookingEmployeeTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escolha um profissional'**
  String get bookingEmployeeTitle;

  /// No description provided for @bookingDateTimeTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escolha data e horário'**
  String get bookingDateTimeTitle;

  /// No description provided for @bookingConfirmTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Confirmar agendamento'**
  String get bookingConfirmTitle;

  /// No description provided for @bookingNotes.
  ///
  /// In pt_BR, this message translates to:
  /// **'Observações (opcional)'**
  String get bookingNotes;

  /// No description provided for @bookingConfirm.
  ///
  /// In pt_BR, this message translates to:
  /// **'Confirmar'**
  String get bookingConfirm;

  /// No description provided for @bookingConflict.
  ///
  /// In pt_BR, this message translates to:
  /// **'Horário indisponível. Escolha outro.'**
  String get bookingConflict;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt': {
  switch (locale.countryCode) {
    case 'BR': return AppLocalizationsPtBr();
   }
  break;
   }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
