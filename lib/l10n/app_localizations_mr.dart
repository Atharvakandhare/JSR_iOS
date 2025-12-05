// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appTitle => 'वॉटर टँक व्यवस्थापन';

  @override
  String get loginTitle => 'वॉटर टँक व्यवस्थापन';

  @override
  String get usernameLabel => 'वापरकर्तानाव';

  @override
  String get passwordLabel => 'पासवर्ड';

  @override
  String get rememberMe => 'मला लक्षात ठेवा';

  @override
  String get loginButton => 'लॉगिन';

  @override
  String get usernameRequired => 'कृपया वापरकर्तानाव प्रविष्ट करा';

  @override
  String get passwordRequired => 'कृपया पासवर्ड प्रविष्ट करा';

  @override
  String get twoFactorPrompt => 'कृपया तुमचा 2FA टोकन प्रविष्ट करा';

  @override
  String get settingsTitle => 'सेटिंग्ज';

  @override
  String get themeSectionTitle => 'थीम';

  @override
  String get themeSectionDescription => 'अॅपसाठी थीम निवडा';

  @override
  String get themeLight => 'लाइट मोड';

  @override
  String get themeDark => 'डार्क मोड';

  @override
  String get languageSectionTitle => 'भाषा';

  @override
  String get languageSectionDescription => 'अॅपसाठी भाषा निवडा';

  @override
  String get languageEnglish => 'इंग्रजी';

  @override
  String get languageHindi => 'हिंदी';

  @override
  String get languageMarathi => 'मराठी';

  @override
  String get drawerDashboard => 'डॅशबोर्ड';

  @override
  String get drawerSocieties => 'सोसायटी';

  @override
  String get drawerTanks => 'टाक्या';

  @override
  String get drawerCleaningRecords => 'स्वच्छता रेकॉर्ड';

  @override
  String get drawerAnalytics => 'विश्लेषण';

  @override
  String get drawerSettings => 'सेटिंग्ज';

  @override
  String get drawerLogout => 'लॉगआउट';

  @override
  String get commonRetry => 'पुन्हा प्रयत्न करा';

  @override
  String get commonCancel => 'रद्द करा';

  @override
  String get commonDelete => 'हटवा';

  @override
  String get commonExit => 'बाहेर पडा';

  @override
  String get commonAll => 'सर्व';

  @override
  String get commonNone => 'काहीही नाही';

  @override
  String get commonUnknown => 'अज्ञात';

  @override
  String get commonRequired => 'आवश्यक';

  @override
  String get appExitTitle => 'अॅप बंद करा';

  @override
  String get appExitMessage =>
      'तुम्हाला खरोखर अॅप्लिकेशनमधून बाहेर पडायचे आहे का?';

  @override
  String get commonPositiveNumber => 'मूल्य सकारात्मक असणे आवश्यक आहे';

  @override
  String commonAmountLabel(String amount) {
    return 'रक्कम: ₹$amount';
  }

  @override
  String commonDueLabel(String amount) {
    return 'प्रलंबित: ₹$amount';
  }

  @override
  String get paymentStatusPaid => 'देय भरले';

  @override
  String get paymentStatusUnpaid => 'देय बाकी';

  @override
  String get paymentStatusPartial => 'प्रलंबित';

  @override
  String get paymentModeCash => 'रोख';

  @override
  String get paymentModeOnline => 'ऑनलाइन';

  @override
  String get paymentModeCheque => 'चेक';

  @override
  String get paymentModeUpi => 'यूपीआय';

  @override
  String get paymentModeCard => 'कार्ड';

  @override
  String get dashboardTitle => 'डॅशबोर्ड';

  @override
  String get dashboardLoadError => 'डॅशबोर्ड लोड करण्यात अयशस्वी';

  @override
  String get dashboardTotalSocieties => 'एकूण सोसायटी';

  @override
  String get dashboardTotalTanks => 'एकूण टाक्या';

  @override
  String get dashboardTotalCleanings => 'एकूण साफसफाई';

  @override
  String get dashboardRecentCleanings => 'अलीकडील साफसफाई';

  @override
  String get dashboardPaymentStats => 'भुगतान आकडेवारी';

  @override
  String get dashboardRevenueSummary => 'महसूल सारांश';

  @override
  String get dashboardTotalRevenue => 'एकूण महसूल';

  @override
  String get dashboardTotalCollected => 'एकूण वसुली';

  @override
  String get dashboardTotalDue => 'एकूण प्रलंबित';

  @override
  String get dashboardQuickActions => 'जलद कृती';

  @override
  String get dashboardCreateSociety => 'सोसायटी तयार करा';

  @override
  String get dashboardCreateTank => 'टाकी तयार करा';

  @override
  String get dashboardCreateCleaning => 'स्वच्छता रेकॉर्ड तयार करा';

  @override
  String get dashboardUpcoming => 'आगामी';

  @override
  String get dashboardOverdue => 'बहुदा';

  @override
  String dashboardRecordsCount(int count) {
    return '$count नोंदी';
  }

  @override
  String get cleaningRecordsTitle => 'स्वच्छता रेकॉर्ड';

  @override
  String get cleaningRecordsLoadError => 'रेकॉर्ड लोड करण्यात अयशस्वी';

  @override
  String get cleaningRecordsEmpty => 'कोणतेही रेकॉर्ड आढळले नाहीत';

  @override
  String get filterSocietyLabel => 'सोसायटी';

  @override
  String get filterTankLabel => 'टाकी';

  @override
  String get filterPaymentStatusLabel => 'भुगतान स्थिती';

  @override
  String get filterStartDate => 'सुरुवातीची तारीख';

  @override
  String get filterEndDate => 'शेवटची तारीख';

  @override
  String get filterDaysAhead => 'दिवस पुढे:';

  @override
  String get filterBySocietyLabel => 'सोसायटीने फिल्टर करा';

  @override
  String get buttonUpcoming => 'आगामी';

  @override
  String get buttonOverdue => 'बहुदा';

  @override
  String cleaningRecordsDateLabel(String date) {
    return 'तारीख: $date';
  }

  @override
  String get deleteCleaningRecordTitle => 'स्वच्छता रेकॉर्ड हटवा';

  @override
  String get deleteCleaningRecordMessage => 'आपण खरंच हा रेकॉर्ड हटवू इच्छिता?';

  @override
  String get cleaningRecordDeleted => 'रेकॉर्ड यशस्वीरित्या हटवला गेला';

  @override
  String get cleaningRecordDeleteFailed => 'रेकॉर्ड हटवण्यात अयशस्वी';

  @override
  String get cleaningRecordCreateTitle => 'स्वच्छता रेकॉर्ड तयार करा';

  @override
  String get cleaningRecordEditTitle => 'स्वच्छता रेकॉर्ड संपादित करा';

  @override
  String get cleaningRecordTankLabel => 'टाकी *';

  @override
  String get cleaningRecordDateCleanedLabel => 'स्वच्छतेची तारीख *';

  @override
  String get cleaningRecordNextExpectedLabel => 'पुढील अपेक्षित तारीख *';

  @override
  String get cleaningRecordPaymentStatusLabel => 'भुगतान स्थिती *';

  @override
  String get cleaningRecordPaymentModeLabel => 'भुगतान पद्धत';

  @override
  String get cleaningRecordTransactionIdLabel => 'व्यवहार आयडी';

  @override
  String get cleaningRecordChequeNumberLabel => 'चेक क्रमांक *';

  @override
  String get cleaningRecordChequeBankLabel => 'बँकेचे नाव *';

  @override
  String get cleaningRecordChequeDateLabel => 'चेक तारीख *';

  @override
  String get cleaningRecordTotalAmountLabel => 'एकूण रक्कम *';

  @override
  String get cleaningRecordAmountDueLabel => 'प्रलंबित रक्कम *';

  @override
  String get validationSelectTank => 'कृपया टाकी निवडा';

  @override
  String get validationSelectDate => 'कृपया तारीख निवडा';

  @override
  String get validationAmountExceeds => 'एकूण रकमेपेक्षा जास्त असू शकत नाही';

  @override
  String get validationInvalidEmail => 'अवैध ईमेल';

  @override
  String get validationInvalidPhone => 'मोबाइल नंबर नक्की 10 अंकांचा असावा';

  @override
  String get cleaningRecordUpdateSuccess =>
      'रेकॉर्ड यशस्वीरित्या अद्यतनित झाला';

  @override
  String get cleaningRecordCreateSuccess => 'रेकॉर्ड यशस्वीरित्या तयार झाला';

  @override
  String get cleaningRecordUpdateFailed => 'रेकॉर्ड अद्यतनित करण्यात अयशस्वी';

  @override
  String get cleaningRecordCreateFailed => 'रेकॉर्ड तयार करण्यात अयशस्वी';

  @override
  String get buttonUpdateRecord => 'रेकॉर्ड अद्यतनित करा';

  @override
  String get buttonCreateRecord => 'रेकॉर्ड तयार करा';

  @override
  String get analyticsTitle => 'विश्लेषण';

  @override
  String get analyticsTabRevenue => 'उत्पन्न';

  @override
  String get analyticsTabSocieties => 'सोसायटी';

  @override
  String get analyticsTabFrequency => 'वारंवारता';

  @override
  String get analyticsTabPaymentModes => 'देयक पद्धती';

  @override
  String get analyticsTabLocations => 'ठिकाणे';

  @override
  String get analyticsPeriodLabel => 'कालावधी';

  @override
  String get analyticsYearLabel => 'वर्ष';

  @override
  String get analyticsPeriodDaily => 'दैनिक';

  @override
  String get analyticsPeriodMonthly => 'मासिक';

  @override
  String get analyticsPeriodYearly => 'वार्षिक';

  @override
  String get analyticsNoRevenueData => 'उपलब्ध उत्पन्न डेटा नाही';

  @override
  String get analyticsNoData => 'उपलब्ध डेटा नाही';

  @override
  String get analyticsRevenueDetailsTitle => 'उत्पन्न तपशील';

  @override
  String analyticsTransactionsCount(int count) {
    return '$count व्यवहार';
  }

  @override
  String analyticsFrequencyDays(int count) {
    return '$count दिवस';
  }

  @override
  String analyticsTankCount(int count) {
    return '$count टाक्या';
  }

  @override
  String get analyticsGroupByLabel => 'गटानुसार';

  @override
  String get analyticsGroupByState => 'राज्य';

  @override
  String get analyticsGroupByCity => 'शहर';

  @override
  String analyticsSocietyCount(int count) {
    return '$count सोसायटी';
  }

  @override
  String get upcomingCleaningsTitle => 'आगामी स्वच्छता';

  @override
  String get upcomingNoRecords => 'कोणतीही आगामी स्वच्छता नाही';

  @override
  String upcomingExpectedLabel(String date) {
    return 'अपेक्षित: $date';
  }

  @override
  String get overdueCleaningsTitle => 'अतिदेय स्वच्छता';

  @override
  String get overdueNoRecords => 'कोणतीही अतिदेय स्वच्छता नाही';

  @override
  String overdueDaysOverdue(int days) {
    return '$days दिवस अतिदेय';
  }

  @override
  String get overdueCreateRecord => 'रेकॉर्ड तयार करा';

  @override
  String get cleaningRecordDetailsTitle => 'स्वच्छता रेकॉर्ड तपशील';

  @override
  String get cleaningRecordNotFound => 'रेकॉर्ड सापडला नाही';

  @override
  String get infoDateCleaned => 'स्वच्छतेची तारीख';

  @override
  String get infoNextExpectedDate => 'पुढील अपेक्षित तारीख';

  @override
  String get infoPaymentStatus => 'भुगतान स्थिती';

  @override
  String get infoPaymentMode => 'भुगतान पद्धत';

  @override
  String get infoTotalAmount => 'एकूण रक्कम';

  @override
  String get infoAmountDue => 'प्रलंबित रक्कम';

  @override
  String get buttonEditRecord => 'रेकॉर्ड संपादित करा';

  @override
  String get buttonDeleteRecord => 'हटवा';

  @override
  String get societiesTitle => 'सोसायटी';

  @override
  String get societiesLoadError => 'सोसायटी लोड करण्यात अयशस्वी';

  @override
  String get societiesEmpty => 'कोणतीही सोसायटी आढळली नाही';

  @override
  String get societiesSearchLabel => 'शोधा';

  @override
  String get societiesStateLabel => 'राज्य';

  @override
  String get societiesCityLabel => 'शहर';

  @override
  String get societiesAllStates => 'सर्व राज्ये';

  @override
  String get societiesAllCities => 'सर्व शहरे';

  @override
  String get societiesDeleteTitle => 'सोसायटी हटवा';

  @override
  String get societiesDeleteMessage =>
      'आपण खरंच ही सोसायटी हटवू इच्छिता? त्यामुळे संबंधित सर्व टाक्या आणि स्वच्छता रेकॉर्ड हटवले जातील.';

  @override
  String get societyDeletedSuccess => 'सोसायटी यशस्वीरित्या हटवली';

  @override
  String get societyDeleteFailed => 'सोसायटी हटवण्यात अयशस्वी';

  @override
  String paginationLabel(int current, int total) {
    return 'पृष्ठ $current / $total';
  }

  @override
  String get tanksTitle => 'टाक्या';

  @override
  String get tanksLoadError => 'टाक्या लोड करण्यात अयशस्वी';

  @override
  String get tanksEmpty => 'कोणतीही टाकी आढळली नाही';

  @override
  String get filterBySociety => 'सोसायटीने फिल्टर करा';

  @override
  String get filterAllSocieties => 'सर्व सोसायटी';

  @override
  String get tanksDeleteTitle => 'टाकी हटवा';

  @override
  String get tanksDeleteMessage =>
      'आपण खरंच ही टाकी हटवू इच्छिता? त्यामुळे संबंधित सर्व स्वच्छता रेकॉर्ड हटवले जातील.';

  @override
  String get tankDeletedSuccess => 'टाकी यशस्वीरित्या हटवली';

  @override
  String get tankDeleteFailed => 'टाकी हटवण्यात अयशस्वी';

  @override
  String get createSocietyTitle => 'सोसायटी तयार करा';

  @override
  String get editSocietyTitle => 'सोसायटी संपादित करा';

  @override
  String get societyNameLabel => 'सोसायटीचे नाव *';

  @override
  String get societyStateLabel => 'राज्य *';

  @override
  String get societyCityLabel => 'शहर *';

  @override
  String get societyPincodeLabel => 'पिनकोड *';

  @override
  String get societyAddressLabel => 'संपूर्ण पत्ता *';

  @override
  String get chairmanDetails => 'चेअरमन तपशील';

  @override
  String get chairmanNameLabel => 'चेअरमनचे नाव *';

  @override
  String get chairmanPhoneLabel => 'चेअरमन फोन *';

  @override
  String get chairmanEmailLabel => 'चेअरमन ईमेल (ऐच्छिक)';

  @override
  String get secretaryDetails => 'सचिव तपशील';

  @override
  String get secretaryNameLabel => 'सचिवाचे नाव *';

  @override
  String get secretaryPhoneLabel => 'सचिव फोन *';

  @override
  String get secretaryEmailLabel => 'सचिव ईमेल (ऐच्छिक)';

  @override
  String get societyCreateSuccess => 'सोसायटी यशस्वीरित्या तयार झाली';

  @override
  String get societyUpdateSuccess => 'सोसायटी यशस्वीरित्या अद्यतनित झाली';

  @override
  String get societyCreateFailed => 'सोसायटी तयार करण्यात अयशस्वी';

  @override
  String get societyUpdateFailed => 'सोसायटी अद्यतनित करण्यात अयशस्वी';

  @override
  String get buttonCreateSociety => 'सोसायटी तयार करा';

  @override
  String get buttonUpdateSociety => 'सोसायटी अद्यतनित करा';

  @override
  String get createTankTitle => 'टाकी तयार करा';

  @override
  String get editTankTitle => 'टाकी संपादित करा';

  @override
  String get tankSocietyLabel => 'सोसायटी *';

  @override
  String get tankLocationLabel => 'स्थान *';

  @override
  String get tankFrequencyLabel => 'स्वच्छता वारंवारता (दिवस) *';

  @override
  String tankFrequencyValue(int days) {
    return 'वारंवारता: $days दिवस';
  }

  @override
  String get validationSelectSociety => 'कृपया सोसायटी निवडा';

  @override
  String get tankCreateSuccess => 'टाकी यशस्वीरित्या तयार झाली';

  @override
  String get tankUpdateSuccess => 'टाकी यशस्वीरित्या अद्यतनित झाली';

  @override
  String get tankCreateFailed => 'टाकी तयार करण्यात अयशस्वी';

  @override
  String get tankUpdateFailed => 'टाकी अद्यतनित करण्यात अयशस्वी';

  @override
  String get buttonCreateTank => 'टाकी तयार करा';

  @override
  String get buttonUpdateTank => 'टाकी अद्यतनित करा';

  @override
  String get societyDetailsTitle => 'सोसायटी तपशील';

  @override
  String get societyNotFound => 'सोसायटी सापडली नाही';

  @override
  String get tanksSectionTitle => 'टाक्या';

  @override
  String get addTankButton => 'टाकी जोडा';

  @override
  String get noTanksFound => 'कोणतीही टाकी आढळली नाही';

  @override
  String get recentCleaningsSection => 'अलीकडील स्वच्छता';

  @override
  String get noCleaningRecordsFound => 'कोणतेही स्वच्छता रेकॉर्ड आढळले नाहीत';

  @override
  String get tankDetailsTitle => 'टाकी तपशील';

  @override
  String get tankNotFound => 'टाकी सापडली नाही';

  @override
  String get viewSocietyButton => 'सोसायटी पाहा';

  @override
  String get cleaningHistorySection => 'स्वच्छता इतिहास';

  @override
  String get addCleaningRecordButton => 'रेकॉर्ड जोडा';

  @override
  String get cleaningRecordLoadError => 'रेकॉर्ड लोड करण्यात अयशस्वी';

  @override
  String get cleaningRecordDetailsNotFound => 'रेकॉर्ड सापडला नाही';

  @override
  String get receiptTitle => 'पावती';

  @override
  String get receiptNumber => 'पावती क्रमांक';

  @override
  String get receiptDate => 'तारीख';

  @override
  String get receiptCustomerInfo => 'ग्राहक माहिती';

  @override
  String get receiptSocietyName => 'सोसायटीचे नाव';

  @override
  String get receiptAddress => 'पत्ता';

  @override
  String get receiptCity => 'शहर';

  @override
  String get receiptContactPerson => 'संपर्क व्यक्ती';

  @override
  String get receiptPhone => 'फोन';

  @override
  String get receiptServiceDetails => 'सेवा तपशील';

  @override
  String get receiptTankLocation => 'टाकी स्थान';

  @override
  String get receiptCleaningDate => 'स्वच्छतेची तारीख';

  @override
  String get receiptNextCleaningDate => 'पुढील स्वच्छतेची तारीख';

  @override
  String get receiptPaymentInfo => 'भुगतान माहिती';

  @override
  String get receiptPaymentStatus => 'भुगतान स्थिती';

  @override
  String get receiptPaymentMode => 'भुगतान पद्धत';

  @override
  String get receiptTotalAmount => 'एकूण रक्कम';

  @override
  String get receiptAmountDue => 'प्रलंबित रक्कम';

  @override
  String get receiptAmountPaid => 'दिलेली रक्कम';

  @override
  String get receiptAmountReceived => 'प्राप्त रक्कम';

  @override
  String get receiptThankYou => 'आपल्या व्यवसायासाठी धन्यवाद!';

  @override
  String get receiptFooter =>
      'ही संगणक-निर्मित पावती आहे. स्वाक्षरी आवश्यक नाही.';

  @override
  String get buttonDownloadReceipt => 'पावती डाउनलोड करा';

  @override
  String get receiptGenerating => 'पावती तयार केली जात आहे...';

  @override
  String get receiptGenerated => 'पावती यशस्वीरित्या तयार झाली';

  @override
  String get receiptGenerationFailed => 'पावती तयार करण्यात अयशस्वी';

  @override
  String get buttonExportAnalytics => 'एक्सेलमध्ये विश्लेषण निर्यात करा';

  @override
  String get analyticsExcelGenerating => 'एक्सेल फाइल तयार केली जात आहे...';

  @override
  String get analyticsExcelGenerated => 'एक्सेल फाइल यशस्वीरित्या तयार झाली';

  @override
  String get analyticsExcelGenerationFailed =>
      'एक्सेल फाइल तयार करण्यात अयशस्वी';
}
