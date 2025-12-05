// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'वाटर टैंक प्रबंधन';

  @override
  String get loginTitle => 'वाटर टैंक प्रबंधन';

  @override
  String get usernameLabel => 'उपयोगकर्ता नाम';

  @override
  String get passwordLabel => 'पासवर्ड';

  @override
  String get rememberMe => 'मुझे याद रखें';

  @override
  String get loginButton => 'लॉगिन';

  @override
  String get usernameRequired => 'कृपया उपयोगकर्ता नाम दर्ज करें';

  @override
  String get passwordRequired => 'कृपया पासवर्ड दर्ज करें';

  @override
  String get twoFactorPrompt => 'कृपया अपना 2FA टोकन दर्ज करें';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get themeSectionTitle => 'थीम';

  @override
  String get themeSectionDescription => 'एप के लिए थीम चुनें';

  @override
  String get themeLight => 'लाइट मोड';

  @override
  String get themeDark => 'डार्क मोड';

  @override
  String get languageSectionTitle => 'भाषा';

  @override
  String get languageSectionDescription => 'एप के लिए भाषा चुनें';

  @override
  String get languageEnglish => 'अंग्रेज़ी';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageMarathi => 'मराठी';

  @override
  String get drawerDashboard => 'डैशबोर्ड';

  @override
  String get drawerSocieties => 'सोसायटी';

  @override
  String get drawerTanks => 'टैंक';

  @override
  String get drawerCleaningRecords => 'सफाई रिकॉर्ड';

  @override
  String get drawerAnalytics => 'एनालिटिक्स';

  @override
  String get drawerSettings => 'सेटिंग्स';

  @override
  String get drawerLogout => 'लॉगआउट';

  @override
  String get commonRetry => 'पुनः प्रयास करें';

  @override
  String get commonCancel => 'रद्द करें';

  @override
  String get commonDelete => 'हटाएं';

  @override
  String get commonExit => 'बाहर निकलें';

  @override
  String get commonAll => 'सभी';

  @override
  String get commonNone => 'कोई नहीं';

  @override
  String get commonUnknown => 'अज्ञात';

  @override
  String get commonRequired => 'अनिवार्य';

  @override
  String get appExitTitle => 'ऐप बंद करें';

  @override
  String get appExitMessage =>
      'क्या आप वाकई एप्लिकेशन से बाहर निकलना चाहते हैं?';

  @override
  String get commonPositiveNumber => 'मान धनात्मक होना चाहिए';

  @override
  String commonAmountLabel(String amount) {
    return 'राशि: ₹$amount';
  }

  @override
  String commonDueLabel(String amount) {
    return 'लंबित: ₹$amount';
  }

  @override
  String get paymentStatusPaid => 'भुगतान किया';

  @override
  String get paymentStatusUnpaid => 'अभुगतान';

  @override
  String get paymentStatusPartial => 'लंबित';

  @override
  String get paymentModeCash => 'नकद';

  @override
  String get paymentModeOnline => 'ऑनलाइन';

  @override
  String get paymentModeCheque => 'चेक';

  @override
  String get paymentModeUpi => 'यूपीआई';

  @override
  String get paymentModeCard => 'कार्ड';

  @override
  String get dashboardTitle => 'डैशबोर्ड';

  @override
  String get dashboardLoadError => 'डैशबोर्ड लोड करने में विफल';

  @override
  String get dashboardTotalSocieties => 'कुल सोसायटी';

  @override
  String get dashboardTotalTanks => 'कुल टैंक';

  @override
  String get dashboardTotalCleanings => 'कुल सफाई';

  @override
  String get dashboardRecentCleanings => 'हाल की सफाई';

  @override
  String get dashboardPaymentStats => 'भुगतान आँकड़े';

  @override
  String get dashboardRevenueSummary => 'राजस्व सारांश';

  @override
  String get dashboardTotalRevenue => 'कुल राजस्व';

  @override
  String get dashboardTotalCollected => 'कुल संग्रह';

  @override
  String get dashboardTotalDue => 'कुल लंबित';

  @override
  String get dashboardQuickActions => 'त्वरित क्रियाएँ';

  @override
  String get dashboardCreateSociety => 'सोसायटी बनाएँ';

  @override
  String get dashboardCreateTank => 'टैंक बनाएँ';

  @override
  String get dashboardCreateCleaning => 'सफाई रिकॉर्ड बनाएँ';

  @override
  String get dashboardUpcoming => 'आगामी';

  @override
  String get dashboardOverdue => 'अतिदेय';

  @override
  String dashboardRecordsCount(int count) {
    return '$count रिकॉर्ड';
  }

  @override
  String get cleaningRecordsTitle => 'सफाई रिकॉर्ड';

  @override
  String get cleaningRecordsLoadError => 'रिकॉर्ड लोड करने में विफल';

  @override
  String get cleaningRecordsEmpty => 'कोई रिकॉर्ड नहीं मिला';

  @override
  String get filterSocietyLabel => 'सोसायटी';

  @override
  String get filterTankLabel => 'टैंक';

  @override
  String get filterPaymentStatusLabel => 'भुगतान स्थिति';

  @override
  String get filterStartDate => 'प्रारम्भ तिथि';

  @override
  String get filterEndDate => 'समाप्ति तिथि';

  @override
  String get filterDaysAhead => 'दिन आगे:';

  @override
  String get filterBySocietyLabel => 'सोसायटी से फ़िल्टर करें';

  @override
  String get buttonUpcoming => 'आगामी';

  @override
  String get buttonOverdue => 'अतिदेय';

  @override
  String cleaningRecordsDateLabel(String date) {
    return 'तिथि: $date';
  }

  @override
  String get deleteCleaningRecordTitle => 'सफाई रिकॉर्ड हटाएँ';

  @override
  String get deleteCleaningRecordMessage =>
      'क्या आप वाकई इस रिकॉर्ड को हटाना चाहते हैं?';

  @override
  String get cleaningRecordDeleted => 'रिकॉर्ड सफलतापूर्वक हटाया गया';

  @override
  String get cleaningRecordDeleteFailed => 'रिकॉर्ड हटाने में विफल';

  @override
  String get cleaningRecordCreateTitle => 'सफाई रिकॉर्ड बनाएँ';

  @override
  String get cleaningRecordEditTitle => 'सफाई रिकॉर्ड संपादित करें';

  @override
  String get cleaningRecordTankLabel => 'टैंक *';

  @override
  String get cleaningRecordDateCleanedLabel => 'सफाई की तिथि *';

  @override
  String get cleaningRecordNextExpectedLabel => 'अगली अपेक्षित तिथि *';

  @override
  String get cleaningRecordPaymentStatusLabel => 'भुगतान स्थिति *';

  @override
  String get cleaningRecordPaymentModeLabel => 'भुगतान विधि';

  @override
  String get cleaningRecordTransactionIdLabel => 'लेन-देन आईडी';

  @override
  String get cleaningRecordChequeNumberLabel => 'चेक नंबर *';

  @override
  String get cleaningRecordChequeBankLabel => 'बैंक का नाम *';

  @override
  String get cleaningRecordChequeDateLabel => 'चेक तिथि *';

  @override
  String get cleaningRecordTotalAmountLabel => 'कुल राशि *';

  @override
  String get cleaningRecordAmountDueLabel => 'लंबित राशि *';

  @override
  String get validationSelectTank => 'कृपया टैंक चुनें';

  @override
  String get validationSelectDate => 'कृपया तिथि चुनें';

  @override
  String get validationAmountExceeds => 'कुल राशि से अधिक नहीं हो सकता';

  @override
  String get validationInvalidEmail => 'अमान्य ईमेल';

  @override
  String get validationInvalidPhone => 'मोबाइल नंबर ठीक 10 अंकों का होना चाहिए';

  @override
  String get cleaningRecordUpdateSuccess => 'रिकॉर्ड सफलतापूर्वक अपडेट हुआ';

  @override
  String get cleaningRecordCreateSuccess => 'रिकॉर्ड सफलतापूर्वक बनाया गया';

  @override
  String get cleaningRecordUpdateFailed => 'रिकॉर्ड अपडेट करने में विफल';

  @override
  String get cleaningRecordCreateFailed => 'रिकॉर्ड बनाने में विफल';

  @override
  String get buttonUpdateRecord => 'रिकॉर्ड अपडेट करें';

  @override
  String get buttonCreateRecord => 'रिकॉर्ड बनाएँ';

  @override
  String get analyticsTitle => 'एनालिटिक्स';

  @override
  String get analyticsTabRevenue => 'राजस्व';

  @override
  String get analyticsTabSocieties => 'सोसायटी';

  @override
  String get analyticsTabFrequency => 'आवृत्ति';

  @override
  String get analyticsTabPaymentModes => 'भुगतान मोड';

  @override
  String get analyticsTabLocations => 'स्थान';

  @override
  String get analyticsPeriodLabel => 'अवधि';

  @override
  String get analyticsYearLabel => 'वर्ष';

  @override
  String get analyticsPeriodDaily => 'दैनिक';

  @override
  String get analyticsPeriodMonthly => 'मासिक';

  @override
  String get analyticsPeriodYearly => 'वार्षिक';

  @override
  String get analyticsNoRevenueData => 'कोई राजस्व डेटा उपलब्ध नहीं';

  @override
  String get analyticsNoData => 'कोई डेटा उपलब्ध नहीं';

  @override
  String get analyticsRevenueDetailsTitle => 'राजस्व विवरण';

  @override
  String analyticsTransactionsCount(int count) {
    return '$count लेन-देन';
  }

  @override
  String analyticsFrequencyDays(int count) {
    return '$count दिन';
  }

  @override
  String analyticsTankCount(int count) {
    return '$count टैंक';
  }

  @override
  String get analyticsGroupByLabel => 'समूह के अनुसार';

  @override
  String get analyticsGroupByState => 'राज्य';

  @override
  String get analyticsGroupByCity => 'शहर';

  @override
  String analyticsSocietyCount(int count) {
    return '$count सोसायटी';
  }

  @override
  String get upcomingCleaningsTitle => 'आगामी सफाई';

  @override
  String get upcomingNoRecords => 'कोई आगामी सफाई नहीं';

  @override
  String upcomingExpectedLabel(String date) {
    return 'अपेक्षित: $date';
  }

  @override
  String get overdueCleaningsTitle => 'अतिदेय सफाई';

  @override
  String get overdueNoRecords => 'कोई अतिदेय सफाई नहीं';

  @override
  String overdueDaysOverdue(int days) {
    return '$days दिन अतिदेय';
  }

  @override
  String get overdueCreateRecord => 'रिकॉर्ड बनाएँ';

  @override
  String get cleaningRecordDetailsTitle => 'सफाई रिकॉर्ड विवरण';

  @override
  String get cleaningRecordNotFound => 'रिकॉर्ड नहीं मिला';

  @override
  String get infoDateCleaned => 'सफाई की तिथि';

  @override
  String get infoNextExpectedDate => 'अगली अपेक्षित तिथि';

  @override
  String get infoPaymentStatus => 'भुगतान स्थिति';

  @override
  String get infoPaymentMode => 'भुगतान विधि';

  @override
  String get infoTotalAmount => 'कुल राशि';

  @override
  String get infoAmountDue => 'लंबित राशि';

  @override
  String get buttonEditRecord => 'रिकॉर्ड संपादित करें';

  @override
  String get buttonDeleteRecord => 'हटाएं';

  @override
  String get societiesTitle => 'सोसायटी';

  @override
  String get societiesLoadError => 'सोसायटी लोड करने में विफल';

  @override
  String get societiesEmpty => 'कोई सोसायटी नहीं मिली';

  @override
  String get societiesSearchLabel => 'खोजें';

  @override
  String get societiesStateLabel => 'राज्य';

  @override
  String get societiesCityLabel => 'शहर';

  @override
  String get societiesAllStates => 'सभी राज्य';

  @override
  String get societiesAllCities => 'सभी शहर';

  @override
  String get societiesDeleteTitle => 'सोसायटी हटाएँ';

  @override
  String get societiesDeleteMessage =>
      'क्या आप वाकई इस सोसायटी को हटाना चाहते हैं? इससे संबंधित सभी टैंक और सफाई रिकॉर्ड भी हट जाएंगे।';

  @override
  String get societyDeletedSuccess => 'सोसायटी सफलतापूर्वक हटाई गई';

  @override
  String get societyDeleteFailed => 'सोसायटी हटाने में विफल';

  @override
  String paginationLabel(int current, int total) {
    return 'पृष्ठ $current / $total';
  }

  @override
  String get tanksTitle => 'टैंक';

  @override
  String get tanksLoadError => 'टैंक लोड करने में विफल';

  @override
  String get tanksEmpty => 'कोई टैंक नहीं मिला';

  @override
  String get filterBySociety => 'सोसायटी से फ़िल्टर करें';

  @override
  String get filterAllSocieties => 'सभी सोसायटी';

  @override
  String get tanksDeleteTitle => 'टैंक हटाएँ';

  @override
  String get tanksDeleteMessage =>
      'क्या आप वाकई इस टैंक को हटाना चाहते हैं? इससे संबंधित सभी सफाई रिकॉर्ड भी हट जाएंगे।';

  @override
  String get tankDeletedSuccess => 'टैंक सफलतापूर्वक हटाया गया';

  @override
  String get tankDeleteFailed => 'टैंक हटाने में विफल';

  @override
  String get createSocietyTitle => 'सोसायटी बनाएँ';

  @override
  String get editSocietyTitle => 'सोसायटी संपादित करें';

  @override
  String get societyNameLabel => 'सोसायटी नाम *';

  @override
  String get societyStateLabel => 'राज्य *';

  @override
  String get societyCityLabel => 'शहर *';

  @override
  String get societyPincodeLabel => 'पिनकोड *';

  @override
  String get societyAddressLabel => 'पूरा पता *';

  @override
  String get chairmanDetails => 'चेयरमैन विवरण';

  @override
  String get chairmanNameLabel => 'चेयरमैन नाम *';

  @override
  String get chairmanPhoneLabel => 'चेयरमैन फोन *';

  @override
  String get chairmanEmailLabel => 'चेयरमैन ईमेल (वैकल्पिक)';

  @override
  String get secretaryDetails => 'सचिव विवरण';

  @override
  String get secretaryNameLabel => 'सचिव नाम *';

  @override
  String get secretaryPhoneLabel => 'सचिव फोन *';

  @override
  String get secretaryEmailLabel => 'सचिव ईमेल (वैकल्पिक)';

  @override
  String get societyCreateSuccess => 'सोसायटी सफलतापूर्वक बनाई गई';

  @override
  String get societyUpdateSuccess => 'सोसायटी सफलतापूर्वक अपडेट हुई';

  @override
  String get societyCreateFailed => 'सोसायटी बनाने में विफल';

  @override
  String get societyUpdateFailed => 'सोसायटी अपडेट करने में विफल';

  @override
  String get buttonCreateSociety => 'सोसायटी बनाएँ';

  @override
  String get buttonUpdateSociety => 'सोसायटी अपडेट करें';

  @override
  String get createTankTitle => 'टैंक बनाएँ';

  @override
  String get editTankTitle => 'टैंक संपादित करें';

  @override
  String get tankSocietyLabel => 'सोसायटी *';

  @override
  String get tankLocationLabel => 'स्थान *';

  @override
  String get tankFrequencyLabel => 'सफाई आवृत्ति (दिन) *';

  @override
  String tankFrequencyValue(int days) {
    return 'आवृत्ति: $days दिन';
  }

  @override
  String get validationSelectSociety => 'कृपया सोसायटी चुनें';

  @override
  String get tankCreateSuccess => 'टैंक सफलतापूर्वक बनाया गया';

  @override
  String get tankUpdateSuccess => 'टैंक सफलतापूर्वक अपडेट हुआ';

  @override
  String get tankCreateFailed => 'टैंक बनाने में विफल';

  @override
  String get tankUpdateFailed => 'टैंक अपडेट करने में विफल';

  @override
  String get buttonCreateTank => 'टैंक बनाएँ';

  @override
  String get buttonUpdateTank => 'टैंक अपडेट करें';

  @override
  String get societyDetailsTitle => 'सोसायटी विवरण';

  @override
  String get societyNotFound => 'सोसायटी नहीं मिली';

  @override
  String get tanksSectionTitle => 'टैंक';

  @override
  String get addTankButton => 'टैंक जोड़ें';

  @override
  String get noTanksFound => 'कोई टैंक नहीं मिला';

  @override
  String get recentCleaningsSection => 'हाल की सफाई';

  @override
  String get noCleaningRecordsFound => 'कोई सफाई रिकॉर्ड नहीं मिला';

  @override
  String get tankDetailsTitle => 'टैंक विवरण';

  @override
  String get tankNotFound => 'टैंक नहीं मिला';

  @override
  String get viewSocietyButton => 'सोसायटी देखें';

  @override
  String get cleaningHistorySection => 'सफाई इतिहास';

  @override
  String get addCleaningRecordButton => 'रिकॉर्ड जोड़ें';

  @override
  String get cleaningRecordLoadError => 'रिकॉर्ड लोड करने में विफल';

  @override
  String get cleaningRecordDetailsNotFound => 'रिकॉर्ड नहीं मिला';

  @override
  String get receiptTitle => 'रसीद';

  @override
  String get receiptNumber => 'रसीद संख्या';

  @override
  String get receiptDate => 'तारीख';

  @override
  String get receiptCustomerInfo => 'ग्राहक जानकारी';

  @override
  String get receiptSocietyName => 'सोसाइटी का नाम';

  @override
  String get receiptAddress => 'पता';

  @override
  String get receiptCity => 'शहर';

  @override
  String get receiptContactPerson => 'संपर्क व्यक्ति';

  @override
  String get receiptPhone => 'फोन';

  @override
  String get receiptServiceDetails => 'सेवा विवरण';

  @override
  String get receiptTankLocation => 'टैंक स्थान';

  @override
  String get receiptCleaningDate => 'सफाई की तारीख';

  @override
  String get receiptNextCleaningDate => 'अगली सफाई की तारीख';

  @override
  String get receiptPaymentInfo => 'भुगतान जानकारी';

  @override
  String get receiptPaymentStatus => 'भुगतान स्थिति';

  @override
  String get receiptPaymentMode => 'भुगतान मोड';

  @override
  String get receiptTotalAmount => 'कुल राशि';

  @override
  String get receiptAmountDue => 'लंबित राशि';

  @override
  String get receiptAmountPaid => 'भुगतान की गई राशि';

  @override
  String get receiptAmountReceived => 'प्राप्त राशि';

  @override
  String get receiptThankYou => 'आपके व्यवसाय के लिए धन्यवाद!';

  @override
  String get receiptFooter =>
      'यह एक कंप्यूटर-जनित रसीद है। हस्ताक्षर की आवश्यकता नहीं है।';

  @override
  String get buttonDownloadReceipt => 'रसीद डाउनलोड करें';

  @override
  String get receiptGenerating => 'रसीद बनाई जा रही है...';

  @override
  String get receiptGenerated => 'रसीद सफलतापूर्वक बनाई गई';

  @override
  String get receiptGenerationFailed => 'रसीद बनाने में विफल';

  @override
  String get buttonExportAnalytics => 'एक्सेल में एनालिटिक्स निर्यात करें';

  @override
  String get analyticsExcelGenerating => 'एक्सेल फ़ाइल बनाई जा रही है...';

  @override
  String get analyticsExcelGenerated => 'एक्सेल फ़ाइल सफलतापूर्वक बनाई गई';

  @override
  String get analyticsExcelGenerationFailed => 'एक्सेल फ़ाइल बनाने में विफल';
}
