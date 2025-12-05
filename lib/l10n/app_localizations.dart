import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_mr.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('mr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Water Tank Management'**
  String get appTitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Water Tank Management'**
  String get loginTitle;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter username'**
  String get usernameRequired;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get passwordRequired;

  /// No description provided for @twoFactorPrompt.
  ///
  /// In en, this message translates to:
  /// **'Please enter your 2FA token'**
  String get twoFactorPrompt;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @themeSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeSectionTitle;

  /// No description provided for @themeSectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Select the theme for the app'**
  String get themeSectionDescription;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get themeDark;

  /// No description provided for @languageSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSectionTitle;

  /// No description provided for @languageSectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Select the language for the app'**
  String get languageSectionDescription;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get languageHindi;

  /// No description provided for @languageMarathi.
  ///
  /// In en, this message translates to:
  /// **'Marathi'**
  String get languageMarathi;

  /// No description provided for @drawerDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get drawerDashboard;

  /// No description provided for @drawerSocieties.
  ///
  /// In en, this message translates to:
  /// **'Societies'**
  String get drawerSocieties;

  /// No description provided for @drawerTanks.
  ///
  /// In en, this message translates to:
  /// **'Tanks'**
  String get drawerTanks;

  /// No description provided for @drawerCleaningRecords.
  ///
  /// In en, this message translates to:
  /// **'Cleaning Records'**
  String get drawerCleaningRecords;

  /// No description provided for @drawerAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get drawerAnalytics;

  /// No description provided for @drawerSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get drawerSettings;

  /// No description provided for @drawerLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get drawerLogout;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonExit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get commonExit;

  /// No description provided for @commonAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get commonAll;

  /// No description provided for @commonNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get commonNone;

  /// No description provided for @commonUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get commonUnknown;

  /// No description provided for @commonRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get commonRequired;

  /// No description provided for @appExitTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit App'**
  String get appExitTitle;

  /// No description provided for @appExitMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit the application?'**
  String get appExitMessage;

  /// No description provided for @commonPositiveNumber.
  ///
  /// In en, this message translates to:
  /// **'Must be a positive number'**
  String get commonPositiveNumber;

  /// No description provided for @commonAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount: ₹{amount}'**
  String commonAmountLabel(String amount);

  /// No description provided for @commonDueLabel.
  ///
  /// In en, this message translates to:
  /// **'Pending: ₹{amount}'**
  String commonDueLabel(String amount);

  /// No description provided for @paymentStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paymentStatusPaid;

  /// No description provided for @paymentStatusUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get paymentStatusUnpaid;

  /// No description provided for @paymentStatusPartial.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get paymentStatusPartial;

  /// No description provided for @paymentModeCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get paymentModeCash;

  /// No description provided for @paymentModeOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get paymentModeOnline;

  /// No description provided for @paymentModeCheque.
  ///
  /// In en, this message translates to:
  /// **'Cheque'**
  String get paymentModeCheque;

  /// No description provided for @paymentModeUpi.
  ///
  /// In en, this message translates to:
  /// **'UPI'**
  String get paymentModeUpi;

  /// No description provided for @paymentModeCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get paymentModeCard;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @dashboardLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load dashboard'**
  String get dashboardLoadError;

  /// No description provided for @dashboardTotalSocieties.
  ///
  /// In en, this message translates to:
  /// **'Total Societies'**
  String get dashboardTotalSocieties;

  /// No description provided for @dashboardTotalTanks.
  ///
  /// In en, this message translates to:
  /// **'Total Tanks'**
  String get dashboardTotalTanks;

  /// No description provided for @dashboardTotalCleanings.
  ///
  /// In en, this message translates to:
  /// **'Total Cleanings'**
  String get dashboardTotalCleanings;

  /// No description provided for @dashboardRecentCleanings.
  ///
  /// In en, this message translates to:
  /// **'Recent Cleanings'**
  String get dashboardRecentCleanings;

  /// No description provided for @dashboardPaymentStats.
  ///
  /// In en, this message translates to:
  /// **'Payment Statistics'**
  String get dashboardPaymentStats;

  /// No description provided for @dashboardRevenueSummary.
  ///
  /// In en, this message translates to:
  /// **'Revenue Summary'**
  String get dashboardRevenueSummary;

  /// No description provided for @dashboardTotalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get dashboardTotalRevenue;

  /// No description provided for @dashboardTotalCollected.
  ///
  /// In en, this message translates to:
  /// **'Total Collected'**
  String get dashboardTotalCollected;

  /// No description provided for @dashboardTotalDue.
  ///
  /// In en, this message translates to:
  /// **'Total Pending'**
  String get dashboardTotalDue;

  /// No description provided for @dashboardQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get dashboardQuickActions;

  /// No description provided for @dashboardCreateSociety.
  ///
  /// In en, this message translates to:
  /// **'Create Society'**
  String get dashboardCreateSociety;

  /// No description provided for @dashboardCreateTank.
  ///
  /// In en, this message translates to:
  /// **'Create Tank'**
  String get dashboardCreateTank;

  /// No description provided for @dashboardCreateCleaning.
  ///
  /// In en, this message translates to:
  /// **'Create Cleaning'**
  String get dashboardCreateCleaning;

  /// No description provided for @dashboardUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get dashboardUpcoming;

  /// No description provided for @dashboardOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get dashboardOverdue;

  /// No description provided for @dashboardRecordsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} records'**
  String dashboardRecordsCount(int count);

  /// No description provided for @cleaningRecordsTitle.
  ///
  /// In en, this message translates to:
  /// **'Cleaning Records'**
  String get cleaningRecordsTitle;

  /// No description provided for @cleaningRecordsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load records'**
  String get cleaningRecordsLoadError;

  /// No description provided for @cleaningRecordsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No records found'**
  String get cleaningRecordsEmpty;

  /// No description provided for @filterSocietyLabel.
  ///
  /// In en, this message translates to:
  /// **'Society'**
  String get filterSocietyLabel;

  /// No description provided for @filterTankLabel.
  ///
  /// In en, this message translates to:
  /// **'Tank'**
  String get filterTankLabel;

  /// No description provided for @filterPaymentStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get filterPaymentStatusLabel;

  /// No description provided for @filterStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get filterStartDate;

  /// No description provided for @filterEndDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get filterEndDate;

  /// No description provided for @filterDaysAhead.
  ///
  /// In en, this message translates to:
  /// **'Days ahead:'**
  String get filterDaysAhead;

  /// No description provided for @filterBySocietyLabel.
  ///
  /// In en, this message translates to:
  /// **'Filter by Society'**
  String get filterBySocietyLabel;

  /// No description provided for @buttonUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get buttonUpcoming;

  /// No description provided for @buttonOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get buttonOverdue;

  /// No description provided for @cleaningRecordsDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date: {date}'**
  String cleaningRecordsDateLabel(String date);

  /// No description provided for @deleteCleaningRecordTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Cleaning Record'**
  String get deleteCleaningRecordTitle;

  /// No description provided for @deleteCleaningRecordMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this record?'**
  String get deleteCleaningRecordMessage;

  /// No description provided for @cleaningRecordDeleted.
  ///
  /// In en, this message translates to:
  /// **'Record deleted successfully'**
  String get cleaningRecordDeleted;

  /// No description provided for @cleaningRecordDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete record'**
  String get cleaningRecordDeleteFailed;

  /// No description provided for @cleaningRecordCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Cleaning Record'**
  String get cleaningRecordCreateTitle;

  /// No description provided for @cleaningRecordEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Cleaning Record'**
  String get cleaningRecordEditTitle;

  /// No description provided for @cleaningRecordTankLabel.
  ///
  /// In en, this message translates to:
  /// **'Tank *'**
  String get cleaningRecordTankLabel;

  /// No description provided for @cleaningRecordDateCleanedLabel.
  ///
  /// In en, this message translates to:
  /// **'Date Cleaned *'**
  String get cleaningRecordDateCleanedLabel;

  /// No description provided for @cleaningRecordNextExpectedLabel.
  ///
  /// In en, this message translates to:
  /// **'Next Expected Date *'**
  String get cleaningRecordNextExpectedLabel;

  /// No description provided for @cleaningRecordPaymentStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Status *'**
  String get cleaningRecordPaymentStatusLabel;

  /// No description provided for @cleaningRecordPaymentModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Mode'**
  String get cleaningRecordPaymentModeLabel;

  /// No description provided for @cleaningRecordTransactionIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Transaction ID'**
  String get cleaningRecordTransactionIdLabel;

  /// No description provided for @cleaningRecordChequeNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Cheque Number *'**
  String get cleaningRecordChequeNumberLabel;

  /// No description provided for @cleaningRecordChequeBankLabel.
  ///
  /// In en, this message translates to:
  /// **'Bank Name *'**
  String get cleaningRecordChequeBankLabel;

  /// No description provided for @cleaningRecordChequeDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Cheque Date *'**
  String get cleaningRecordChequeDateLabel;

  /// No description provided for @cleaningRecordTotalAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Amount *'**
  String get cleaningRecordTotalAmountLabel;

  /// No description provided for @cleaningRecordAmountDueLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount Pending *'**
  String get cleaningRecordAmountDueLabel;

  /// No description provided for @validationSelectTank.
  ///
  /// In en, this message translates to:
  /// **'Please select a tank'**
  String get validationSelectTank;

  /// No description provided for @validationSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Please select a date'**
  String get validationSelectDate;

  /// No description provided for @validationAmountExceeds.
  ///
  /// In en, this message translates to:
  /// **'Cannot exceed total amount'**
  String get validationAmountExceeds;

  /// No description provided for @validationInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get validationInvalidEmail;

  /// No description provided for @validationInvalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Mobile number must be exactly 10 digits'**
  String get validationInvalidPhone;

  /// No description provided for @cleaningRecordUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Record updated successfully'**
  String get cleaningRecordUpdateSuccess;

  /// No description provided for @cleaningRecordCreateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Record created successfully'**
  String get cleaningRecordCreateSuccess;

  /// No description provided for @cleaningRecordUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update record'**
  String get cleaningRecordUpdateFailed;

  /// No description provided for @cleaningRecordCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to create record'**
  String get cleaningRecordCreateFailed;

  /// No description provided for @buttonUpdateRecord.
  ///
  /// In en, this message translates to:
  /// **'Update Record'**
  String get buttonUpdateRecord;

  /// No description provided for @buttonCreateRecord.
  ///
  /// In en, this message translates to:
  /// **'Create Record'**
  String get buttonCreateRecord;

  /// No description provided for @analyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analyticsTitle;

  /// No description provided for @analyticsTabRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get analyticsTabRevenue;

  /// No description provided for @analyticsTabSocieties.
  ///
  /// In en, this message translates to:
  /// **'Societies'**
  String get analyticsTabSocieties;

  /// No description provided for @analyticsTabFrequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get analyticsTabFrequency;

  /// No description provided for @analyticsTabPaymentModes.
  ///
  /// In en, this message translates to:
  /// **'Payment Modes'**
  String get analyticsTabPaymentModes;

  /// No description provided for @analyticsTabLocations.
  ///
  /// In en, this message translates to:
  /// **'Locations'**
  String get analyticsTabLocations;

  /// No description provided for @analyticsPeriodLabel.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get analyticsPeriodLabel;

  /// No description provided for @analyticsYearLabel.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get analyticsYearLabel;

  /// No description provided for @analyticsPeriodDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get analyticsPeriodDaily;

  /// No description provided for @analyticsPeriodMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get analyticsPeriodMonthly;

  /// No description provided for @analyticsPeriodYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get analyticsPeriodYearly;

  /// No description provided for @analyticsNoRevenueData.
  ///
  /// In en, this message translates to:
  /// **'No revenue data available'**
  String get analyticsNoRevenueData;

  /// No description provided for @analyticsNoData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get analyticsNoData;

  /// No description provided for @analyticsRevenueDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Revenue Details'**
  String get analyticsRevenueDetailsTitle;

  /// No description provided for @analyticsTransactionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} transactions'**
  String analyticsTransactionsCount(int count);

  /// No description provided for @analyticsFrequencyDays.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String analyticsFrequencyDays(int count);

  /// No description provided for @analyticsTankCount.
  ///
  /// In en, this message translates to:
  /// **'{count} tanks'**
  String analyticsTankCount(int count);

  /// No description provided for @analyticsGroupByLabel.
  ///
  /// In en, this message translates to:
  /// **'Group By'**
  String get analyticsGroupByLabel;

  /// No description provided for @analyticsGroupByState.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get analyticsGroupByState;

  /// No description provided for @analyticsGroupByCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get analyticsGroupByCity;

  /// No description provided for @analyticsSocietyCount.
  ///
  /// In en, this message translates to:
  /// **'{count} societies'**
  String analyticsSocietyCount(int count);

  /// No description provided for @upcomingCleaningsTitle.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Cleanings'**
  String get upcomingCleaningsTitle;

  /// No description provided for @upcomingNoRecords.
  ///
  /// In en, this message translates to:
  /// **'No upcoming cleanings'**
  String get upcomingNoRecords;

  /// No description provided for @upcomingExpectedLabel.
  ///
  /// In en, this message translates to:
  /// **'Expected: {date}'**
  String upcomingExpectedLabel(String date);

  /// No description provided for @overdueCleaningsTitle.
  ///
  /// In en, this message translates to:
  /// **'Overdue Cleanings'**
  String get overdueCleaningsTitle;

  /// No description provided for @overdueNoRecords.
  ///
  /// In en, this message translates to:
  /// **'No overdue cleanings'**
  String get overdueNoRecords;

  /// No description provided for @overdueDaysOverdue.
  ///
  /// In en, this message translates to:
  /// **'{days} days overdue'**
  String overdueDaysOverdue(int days);

  /// No description provided for @overdueCreateRecord.
  ///
  /// In en, this message translates to:
  /// **'Create Record'**
  String get overdueCreateRecord;

  /// No description provided for @cleaningRecordDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Cleaning Record Details'**
  String get cleaningRecordDetailsTitle;

  /// No description provided for @cleaningRecordNotFound.
  ///
  /// In en, this message translates to:
  /// **'Record not found'**
  String get cleaningRecordNotFound;

  /// No description provided for @infoDateCleaned.
  ///
  /// In en, this message translates to:
  /// **'Date Cleaned'**
  String get infoDateCleaned;

  /// No description provided for @infoNextExpectedDate.
  ///
  /// In en, this message translates to:
  /// **'Next Expected Date'**
  String get infoNextExpectedDate;

  /// No description provided for @infoPaymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get infoPaymentStatus;

  /// No description provided for @infoPaymentMode.
  ///
  /// In en, this message translates to:
  /// **'Payment Mode'**
  String get infoPaymentMode;

  /// No description provided for @infoTotalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get infoTotalAmount;

  /// No description provided for @infoAmountDue.
  ///
  /// In en, this message translates to:
  /// **'Amount Pending'**
  String get infoAmountDue;

  /// No description provided for @buttonEditRecord.
  ///
  /// In en, this message translates to:
  /// **'Edit Record'**
  String get buttonEditRecord;

  /// No description provided for @buttonDeleteRecord.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get buttonDeleteRecord;

  /// No description provided for @societiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Societies'**
  String get societiesTitle;

  /// No description provided for @societiesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load societies'**
  String get societiesLoadError;

  /// No description provided for @societiesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No societies found'**
  String get societiesEmpty;

  /// No description provided for @societiesSearchLabel.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get societiesSearchLabel;

  /// No description provided for @societiesStateLabel.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get societiesStateLabel;

  /// No description provided for @societiesCityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get societiesCityLabel;

  /// No description provided for @societiesAllStates.
  ///
  /// In en, this message translates to:
  /// **'All States'**
  String get societiesAllStates;

  /// No description provided for @societiesAllCities.
  ///
  /// In en, this message translates to:
  /// **'All Cities'**
  String get societiesAllCities;

  /// No description provided for @societiesDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Society'**
  String get societiesDeleteTitle;

  /// No description provided for @societiesDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this society? This will also delete all associated tanks and cleaning records.'**
  String get societiesDeleteMessage;

  /// No description provided for @societyDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Society deleted successfully'**
  String get societyDeletedSuccess;

  /// No description provided for @societyDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete society'**
  String get societyDeleteFailed;

  /// No description provided for @paginationLabel.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String paginationLabel(int current, int total);

  /// No description provided for @tanksTitle.
  ///
  /// In en, this message translates to:
  /// **'Tanks'**
  String get tanksTitle;

  /// No description provided for @tanksLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load tanks'**
  String get tanksLoadError;

  /// No description provided for @tanksEmpty.
  ///
  /// In en, this message translates to:
  /// **'No tanks found'**
  String get tanksEmpty;

  /// No description provided for @filterBySociety.
  ///
  /// In en, this message translates to:
  /// **'Filter by Society'**
  String get filterBySociety;

  /// No description provided for @filterAllSocieties.
  ///
  /// In en, this message translates to:
  /// **'All Societies'**
  String get filterAllSocieties;

  /// No description provided for @tanksDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Tank'**
  String get tanksDeleteTitle;

  /// No description provided for @tanksDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this tank? This will also delete all associated cleaning records.'**
  String get tanksDeleteMessage;

  /// No description provided for @tankDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Tank deleted successfully'**
  String get tankDeletedSuccess;

  /// No description provided for @tankDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete tank'**
  String get tankDeleteFailed;

  /// No description provided for @createSocietyTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Society'**
  String get createSocietyTitle;

  /// No description provided for @editSocietyTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Society'**
  String get editSocietyTitle;

  /// No description provided for @societyNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Society Name *'**
  String get societyNameLabel;

  /// No description provided for @societyStateLabel.
  ///
  /// In en, this message translates to:
  /// **'State *'**
  String get societyStateLabel;

  /// No description provided for @societyCityLabel.
  ///
  /// In en, this message translates to:
  /// **'City *'**
  String get societyCityLabel;

  /// No description provided for @societyPincodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Pincode *'**
  String get societyPincodeLabel;

  /// No description provided for @societyAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Address *'**
  String get societyAddressLabel;

  /// No description provided for @chairmanDetails.
  ///
  /// In en, this message translates to:
  /// **'Chairman Details'**
  String get chairmanDetails;

  /// No description provided for @chairmanNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Chairman Name *'**
  String get chairmanNameLabel;

  /// No description provided for @chairmanPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Chairman Phone *'**
  String get chairmanPhoneLabel;

  /// No description provided for @chairmanEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Chairman Email (optional)'**
  String get chairmanEmailLabel;

  /// No description provided for @secretaryDetails.
  ///
  /// In en, this message translates to:
  /// **'Secretary Details'**
  String get secretaryDetails;

  /// No description provided for @secretaryNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Secretary Name *'**
  String get secretaryNameLabel;

  /// No description provided for @secretaryPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Secretary Phone *'**
  String get secretaryPhoneLabel;

  /// No description provided for @secretaryEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Secretary Email (optional)'**
  String get secretaryEmailLabel;

  /// No description provided for @societyCreateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Society created successfully'**
  String get societyCreateSuccess;

  /// No description provided for @societyUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Society updated successfully'**
  String get societyUpdateSuccess;

  /// No description provided for @societyCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to create society'**
  String get societyCreateFailed;

  /// No description provided for @societyUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update society'**
  String get societyUpdateFailed;

  /// No description provided for @buttonCreateSociety.
  ///
  /// In en, this message translates to:
  /// **'Create Society'**
  String get buttonCreateSociety;

  /// No description provided for @buttonUpdateSociety.
  ///
  /// In en, this message translates to:
  /// **'Update Society'**
  String get buttonUpdateSociety;

  /// No description provided for @createTankTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Tank'**
  String get createTankTitle;

  /// No description provided for @editTankTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Tank'**
  String get editTankTitle;

  /// No description provided for @tankSocietyLabel.
  ///
  /// In en, this message translates to:
  /// **'Society *'**
  String get tankSocietyLabel;

  /// No description provided for @tankLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location *'**
  String get tankLocationLabel;

  /// No description provided for @tankFrequencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Cleaning Frequency (days) *'**
  String get tankFrequencyLabel;

  /// No description provided for @tankFrequencyValue.
  ///
  /// In en, this message translates to:
  /// **'Frequency: {days} days'**
  String tankFrequencyValue(int days);

  /// No description provided for @validationSelectSociety.
  ///
  /// In en, this message translates to:
  /// **'Please select a society'**
  String get validationSelectSociety;

  /// No description provided for @tankCreateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Tank created successfully'**
  String get tankCreateSuccess;

  /// No description provided for @tankUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Tank updated successfully'**
  String get tankUpdateSuccess;

  /// No description provided for @tankCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to create tank'**
  String get tankCreateFailed;

  /// No description provided for @tankUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update tank'**
  String get tankUpdateFailed;

  /// No description provided for @buttonCreateTank.
  ///
  /// In en, this message translates to:
  /// **'Create Tank'**
  String get buttonCreateTank;

  /// No description provided for @buttonUpdateTank.
  ///
  /// In en, this message translates to:
  /// **'Update Tank'**
  String get buttonUpdateTank;

  /// No description provided for @societyDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Society Details'**
  String get societyDetailsTitle;

  /// No description provided for @societyNotFound.
  ///
  /// In en, this message translates to:
  /// **'Society not found'**
  String get societyNotFound;

  /// No description provided for @tanksSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Tanks'**
  String get tanksSectionTitle;

  /// No description provided for @addTankButton.
  ///
  /// In en, this message translates to:
  /// **'Add Tank'**
  String get addTankButton;

  /// No description provided for @noTanksFound.
  ///
  /// In en, this message translates to:
  /// **'No tanks found'**
  String get noTanksFound;

  /// No description provided for @recentCleaningsSection.
  ///
  /// In en, this message translates to:
  /// **'Recent Cleanings'**
  String get recentCleaningsSection;

  /// No description provided for @noCleaningRecordsFound.
  ///
  /// In en, this message translates to:
  /// **'No cleaning records found'**
  String get noCleaningRecordsFound;

  /// No description provided for @tankDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tank Details'**
  String get tankDetailsTitle;

  /// No description provided for @tankNotFound.
  ///
  /// In en, this message translates to:
  /// **'Tank not found'**
  String get tankNotFound;

  /// No description provided for @viewSocietyButton.
  ///
  /// In en, this message translates to:
  /// **'View Society'**
  String get viewSocietyButton;

  /// No description provided for @cleaningHistorySection.
  ///
  /// In en, this message translates to:
  /// **'Cleaning History'**
  String get cleaningHistorySection;

  /// No description provided for @addCleaningRecordButton.
  ///
  /// In en, this message translates to:
  /// **'Add Record'**
  String get addCleaningRecordButton;

  /// No description provided for @cleaningRecordLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load record'**
  String get cleaningRecordLoadError;

  /// No description provided for @cleaningRecordDetailsNotFound.
  ///
  /// In en, this message translates to:
  /// **'Record not found'**
  String get cleaningRecordDetailsNotFound;

  /// No description provided for @receiptTitle.
  ///
  /// In en, this message translates to:
  /// **'RECEIPT'**
  String get receiptTitle;

  /// No description provided for @receiptNumber.
  ///
  /// In en, this message translates to:
  /// **'Receipt Number'**
  String get receiptNumber;

  /// No description provided for @receiptDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get receiptDate;

  /// No description provided for @receiptCustomerInfo.
  ///
  /// In en, this message translates to:
  /// **'Customer Information'**
  String get receiptCustomerInfo;

  /// No description provided for @receiptSocietyName.
  ///
  /// In en, this message translates to:
  /// **'Society Name'**
  String get receiptSocietyName;

  /// No description provided for @receiptAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get receiptAddress;

  /// No description provided for @receiptCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get receiptCity;

  /// No description provided for @receiptContactPerson.
  ///
  /// In en, this message translates to:
  /// **'Contact Person'**
  String get receiptContactPerson;

  /// No description provided for @receiptPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get receiptPhone;

  /// No description provided for @receiptServiceDetails.
  ///
  /// In en, this message translates to:
  /// **'Service Details'**
  String get receiptServiceDetails;

  /// No description provided for @receiptTankLocation.
  ///
  /// In en, this message translates to:
  /// **'Tank Location'**
  String get receiptTankLocation;

  /// No description provided for @receiptCleaningDate.
  ///
  /// In en, this message translates to:
  /// **'Cleaning Date'**
  String get receiptCleaningDate;

  /// No description provided for @receiptNextCleaningDate.
  ///
  /// In en, this message translates to:
  /// **'Next Cleaning Date'**
  String get receiptNextCleaningDate;

  /// No description provided for @receiptPaymentInfo.
  ///
  /// In en, this message translates to:
  /// **'Payment Information'**
  String get receiptPaymentInfo;

  /// No description provided for @receiptPaymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get receiptPaymentStatus;

  /// No description provided for @receiptPaymentMode.
  ///
  /// In en, this message translates to:
  /// **'Payment Mode'**
  String get receiptPaymentMode;

  /// No description provided for @receiptTotalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get receiptTotalAmount;

  /// No description provided for @receiptAmountDue.
  ///
  /// In en, this message translates to:
  /// **'Amount Pending'**
  String get receiptAmountDue;

  /// No description provided for @receiptAmountPaid.
  ///
  /// In en, this message translates to:
  /// **'Amount Paid'**
  String get receiptAmountPaid;

  /// No description provided for @receiptAmountReceived.
  ///
  /// In en, this message translates to:
  /// **'Received Amount'**
  String get receiptAmountReceived;

  /// No description provided for @receiptThankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your business!'**
  String get receiptThankYou;

  /// No description provided for @receiptFooter.
  ///
  /// In en, this message translates to:
  /// **'This is a computer-generated receipt. No signature required.'**
  String get receiptFooter;

  /// No description provided for @buttonDownloadReceipt.
  ///
  /// In en, this message translates to:
  /// **'Download Receipt'**
  String get buttonDownloadReceipt;

  /// No description provided for @receiptGenerating.
  ///
  /// In en, this message translates to:
  /// **'Generating receipt...'**
  String get receiptGenerating;

  /// No description provided for @receiptGenerated.
  ///
  /// In en, this message translates to:
  /// **'Receipt generated successfully'**
  String get receiptGenerated;

  /// No description provided for @receiptGenerationFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate receipt'**
  String get receiptGenerationFailed;

  /// No description provided for @buttonExportAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Export Analytics to Excel'**
  String get buttonExportAnalytics;

  /// No description provided for @analyticsExcelGenerating.
  ///
  /// In en, this message translates to:
  /// **'Generating Excel file...'**
  String get analyticsExcelGenerating;

  /// No description provided for @analyticsExcelGenerated.
  ///
  /// In en, this message translates to:
  /// **'Excel file generated successfully'**
  String get analyticsExcelGenerated;

  /// No description provided for @analyticsExcelGenerationFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate Excel file'**
  String get analyticsExcelGenerationFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'mr':
      return AppLocalizationsMr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
