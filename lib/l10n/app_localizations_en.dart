// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Water Tank Management';

  @override
  String get loginTitle => 'Water Tank Management';

  @override
  String get usernameLabel => 'Username';

  @override
  String get passwordLabel => 'Password';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get loginButton => 'Login';

  @override
  String get usernameRequired => 'Please enter username';

  @override
  String get passwordRequired => 'Please enter password';

  @override
  String get twoFactorPrompt => 'Please enter your 2FA token';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get themeSectionTitle => 'Theme';

  @override
  String get themeSectionDescription => 'Select the theme for the app';

  @override
  String get themeLight => 'Light Mode';

  @override
  String get themeDark => 'Dark Mode';

  @override
  String get languageSectionTitle => 'Language';

  @override
  String get languageSectionDescription => 'Select the language for the app';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'Hindi';

  @override
  String get languageMarathi => 'Marathi';

  @override
  String get drawerDashboard => 'Dashboard';

  @override
  String get drawerSocieties => 'Societies';

  @override
  String get drawerTanks => 'Tanks';

  @override
  String get drawerCleaningRecords => 'Cleaning Records';

  @override
  String get drawerAnalytics => 'Analytics';

  @override
  String get drawerSettings => 'Settings';

  @override
  String get drawerLogout => 'Logout';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonExit => 'Exit';

  @override
  String get commonAll => 'All';

  @override
  String get commonNone => 'None';

  @override
  String get commonUnknown => 'Unknown';

  @override
  String get commonRequired => 'Required';

  @override
  String get appExitTitle => 'Exit App';

  @override
  String get appExitMessage => 'Are you sure you want to exit the application?';

  @override
  String get commonPositiveNumber => 'Must be a positive number';

  @override
  String commonAmountLabel(String amount) {
    return 'Amount: ₹$amount';
  }

  @override
  String commonDueLabel(String amount) {
    return 'Pending: ₹$amount';
  }

  @override
  String get paymentStatusPaid => 'Paid';

  @override
  String get paymentStatusUnpaid => 'Unpaid';

  @override
  String get paymentStatusPartial => 'Pending';

  @override
  String get paymentModeCash => 'Cash';

  @override
  String get paymentModeOnline => 'Online';

  @override
  String get paymentModeCheque => 'Cheque';

  @override
  String get paymentModeUpi => 'UPI';

  @override
  String get paymentModeCard => 'Card';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardLoadError => 'Failed to load dashboard';

  @override
  String get dashboardTotalSocieties => 'Total Societies';

  @override
  String get dashboardTotalTanks => 'Total Tanks';

  @override
  String get dashboardTotalCleanings => 'Total Cleanings';

  @override
  String get dashboardRecentCleanings => 'Recent Cleanings';

  @override
  String get dashboardPaymentStats => 'Payment Statistics';

  @override
  String get dashboardRevenueSummary => 'Revenue Summary';

  @override
  String get dashboardTotalRevenue => 'Total Revenue';

  @override
  String get dashboardTotalCollected => 'Total Collected';

  @override
  String get dashboardTotalDue => 'Total Pending';

  @override
  String get dashboardQuickActions => 'Quick Actions';

  @override
  String get dashboardCreateSociety => 'Create Society';

  @override
  String get dashboardCreateTank => 'Create Tank';

  @override
  String get dashboardCreateCleaning => 'Create Cleaning';

  @override
  String get dashboardUpcoming => 'Upcoming';

  @override
  String get dashboardOverdue => 'Overdue';

  @override
  String dashboardRecordsCount(int count) {
    return '$count records';
  }

  @override
  String get cleaningRecordsTitle => 'Cleaning Records';

  @override
  String get cleaningRecordsLoadError => 'Failed to load records';

  @override
  String get cleaningRecordsEmpty => 'No records found';

  @override
  String get filterSocietyLabel => 'Society';

  @override
  String get filterTankLabel => 'Tank';

  @override
  String get filterPaymentStatusLabel => 'Payment Status';

  @override
  String get filterStartDate => 'Start Date';

  @override
  String get filterEndDate => 'End Date';

  @override
  String get filterDaysAhead => 'Days ahead:';

  @override
  String get filterBySocietyLabel => 'Filter by Society';

  @override
  String get buttonUpcoming => 'Upcoming';

  @override
  String get buttonOverdue => 'Overdue';

  @override
  String cleaningRecordsDateLabel(String date) {
    return 'Date: $date';
  }

  @override
  String get deleteCleaningRecordTitle => 'Delete Cleaning Record';

  @override
  String get deleteCleaningRecordMessage =>
      'Are you sure you want to delete this record?';

  @override
  String get cleaningRecordDeleted => 'Record deleted successfully';

  @override
  String get cleaningRecordDeleteFailed => 'Failed to delete record';

  @override
  String get cleaningRecordCreateTitle => 'Create Cleaning Record';

  @override
  String get cleaningRecordEditTitle => 'Edit Cleaning Record';

  @override
  String get cleaningRecordTankLabel => 'Tank *';

  @override
  String get cleaningRecordDateCleanedLabel => 'Date Cleaned *';

  @override
  String get cleaningRecordNextExpectedLabel => 'Next Expected Date *';

  @override
  String get cleaningRecordPaymentStatusLabel => 'Payment Status *';

  @override
  String get cleaningRecordPaymentModeLabel => 'Payment Mode';

  @override
  String get cleaningRecordTransactionIdLabel => 'Transaction ID';

  @override
  String get cleaningRecordChequeNumberLabel => 'Cheque Number *';

  @override
  String get cleaningRecordChequeBankLabel => 'Bank Name *';

  @override
  String get cleaningRecordChequeDateLabel => 'Cheque Date *';

  @override
  String get cleaningRecordTotalAmountLabel => 'Total Amount *';

  @override
  String get cleaningRecordAmountDueLabel => 'Amount Pending *';

  @override
  String get validationSelectTank => 'Please select a tank';

  @override
  String get validationSelectDate => 'Please select a date';

  @override
  String get validationAmountExceeds => 'Cannot exceed total amount';

  @override
  String get validationInvalidEmail => 'Invalid email';

  @override
  String get validationInvalidPhone =>
      'Mobile number must be exactly 10 digits';

  @override
  String get cleaningRecordUpdateSuccess => 'Record updated successfully';

  @override
  String get cleaningRecordCreateSuccess => 'Record created successfully';

  @override
  String get cleaningRecordUpdateFailed => 'Failed to update record';

  @override
  String get cleaningRecordCreateFailed => 'Failed to create record';

  @override
  String get buttonUpdateRecord => 'Update Record';

  @override
  String get buttonCreateRecord => 'Create Record';

  @override
  String get analyticsTitle => 'Analytics';

  @override
  String get analyticsTabRevenue => 'Revenue';

  @override
  String get analyticsTabSocieties => 'Societies';

  @override
  String get analyticsTabFrequency => 'Frequency';

  @override
  String get analyticsTabPaymentModes => 'Payment Modes';

  @override
  String get analyticsTabLocations => 'Locations';

  @override
  String get analyticsPeriodLabel => 'Period';

  @override
  String get analyticsYearLabel => 'Year';

  @override
  String get analyticsPeriodDaily => 'Daily';

  @override
  String get analyticsPeriodMonthly => 'Monthly';

  @override
  String get analyticsPeriodYearly => 'Yearly';

  @override
  String get analyticsNoRevenueData => 'No revenue data available';

  @override
  String get analyticsNoData => 'No data available';

  @override
  String get analyticsRevenueDetailsTitle => 'Revenue Details';

  @override
  String analyticsTransactionsCount(int count) {
    return '$count transactions';
  }

  @override
  String analyticsFrequencyDays(int count) {
    return '$count days';
  }

  @override
  String analyticsTankCount(int count) {
    return '$count tanks';
  }

  @override
  String get analyticsGroupByLabel => 'Group By';

  @override
  String get analyticsGroupByState => 'State';

  @override
  String get analyticsGroupByCity => 'City';

  @override
  String analyticsSocietyCount(int count) {
    return '$count societies';
  }

  @override
  String get upcomingCleaningsTitle => 'Upcoming Cleanings';

  @override
  String get upcomingNoRecords => 'No upcoming cleanings';

  @override
  String upcomingExpectedLabel(String date) {
    return 'Expected: $date';
  }

  @override
  String get overdueCleaningsTitle => 'Overdue Cleanings';

  @override
  String get overdueNoRecords => 'No overdue cleanings';

  @override
  String overdueDaysOverdue(int days) {
    return '$days days overdue';
  }

  @override
  String get overdueCreateRecord => 'Create Record';

  @override
  String get cleaningRecordDetailsTitle => 'Cleaning Record Details';

  @override
  String get cleaningRecordNotFound => 'Record not found';

  @override
  String get infoDateCleaned => 'Date Cleaned';

  @override
  String get infoNextExpectedDate => 'Next Expected Date';

  @override
  String get infoPaymentStatus => 'Payment Status';

  @override
  String get infoPaymentMode => 'Payment Mode';

  @override
  String get infoTotalAmount => 'Total Amount';

  @override
  String get infoAmountDue => 'Amount Pending';

  @override
  String get buttonEditRecord => 'Edit Record';

  @override
  String get buttonDeleteRecord => 'Delete';

  @override
  String get societiesTitle => 'Societies';

  @override
  String get societiesLoadError => 'Failed to load societies';

  @override
  String get societiesEmpty => 'No societies found';

  @override
  String get societiesSearchLabel => 'Search';

  @override
  String get societiesStateLabel => 'State';

  @override
  String get societiesCityLabel => 'City';

  @override
  String get societiesAllStates => 'All States';

  @override
  String get societiesAllCities => 'All Cities';

  @override
  String get societiesDeleteTitle => 'Delete Society';

  @override
  String get societiesDeleteMessage =>
      'Are you sure you want to delete this society? This will also delete all associated tanks and cleaning records.';

  @override
  String get societyDeletedSuccess => 'Society deleted successfully';

  @override
  String get societyDeleteFailed => 'Failed to delete society';

  @override
  String paginationLabel(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String get tanksTitle => 'Tanks';

  @override
  String get tanksLoadError => 'Failed to load tanks';

  @override
  String get tanksEmpty => 'No tanks found';

  @override
  String get filterBySociety => 'Filter by Society';

  @override
  String get filterAllSocieties => 'All Societies';

  @override
  String get tanksDeleteTitle => 'Delete Tank';

  @override
  String get tanksDeleteMessage =>
      'Are you sure you want to delete this tank? This will also delete all associated cleaning records.';

  @override
  String get tankDeletedSuccess => 'Tank deleted successfully';

  @override
  String get tankDeleteFailed => 'Failed to delete tank';

  @override
  String get createSocietyTitle => 'Create Society';

  @override
  String get editSocietyTitle => 'Edit Society';

  @override
  String get societyNameLabel => 'Society Name *';

  @override
  String get societyStateLabel => 'State *';

  @override
  String get societyCityLabel => 'City *';

  @override
  String get societyPincodeLabel => 'Pincode *';

  @override
  String get societyAddressLabel => 'Full Address *';

  @override
  String get chairmanDetails => 'Chairman Details';

  @override
  String get chairmanNameLabel => 'Chairman Name *';

  @override
  String get chairmanPhoneLabel => 'Chairman Phone *';

  @override
  String get chairmanEmailLabel => 'Chairman Email (optional)';

  @override
  String get secretaryDetails => 'Secretary Details';

  @override
  String get secretaryNameLabel => 'Secretary Name *';

  @override
  String get secretaryPhoneLabel => 'Secretary Phone *';

  @override
  String get secretaryEmailLabel => 'Secretary Email (optional)';

  @override
  String get societyCreateSuccess => 'Society created successfully';

  @override
  String get societyUpdateSuccess => 'Society updated successfully';

  @override
  String get societyCreateFailed => 'Failed to create society';

  @override
  String get societyUpdateFailed => 'Failed to update society';

  @override
  String get buttonCreateSociety => 'Create Society';

  @override
  String get buttonUpdateSociety => 'Update Society';

  @override
  String get createTankTitle => 'Create Tank';

  @override
  String get editTankTitle => 'Edit Tank';

  @override
  String get tankSocietyLabel => 'Society *';

  @override
  String get tankLocationLabel => 'Location *';

  @override
  String get tankFrequencyLabel => 'Cleaning Frequency (days) *';

  @override
  String tankFrequencyValue(int days) {
    return 'Frequency: $days days';
  }

  @override
  String get validationSelectSociety => 'Please select a society';

  @override
  String get tankCreateSuccess => 'Tank created successfully';

  @override
  String get tankUpdateSuccess => 'Tank updated successfully';

  @override
  String get tankCreateFailed => 'Failed to create tank';

  @override
  String get tankUpdateFailed => 'Failed to update tank';

  @override
  String get buttonCreateTank => 'Create Tank';

  @override
  String get buttonUpdateTank => 'Update Tank';

  @override
  String get societyDetailsTitle => 'Society Details';

  @override
  String get societyNotFound => 'Society not found';

  @override
  String get tanksSectionTitle => 'Tanks';

  @override
  String get addTankButton => 'Add Tank';

  @override
  String get noTanksFound => 'No tanks found';

  @override
  String get recentCleaningsSection => 'Recent Cleanings';

  @override
  String get noCleaningRecordsFound => 'No cleaning records found';

  @override
  String get tankDetailsTitle => 'Tank Details';

  @override
  String get tankNotFound => 'Tank not found';

  @override
  String get viewSocietyButton => 'View Society';

  @override
  String get cleaningHistorySection => 'Cleaning History';

  @override
  String get addCleaningRecordButton => 'Add Record';

  @override
  String get cleaningRecordLoadError => 'Failed to load record';

  @override
  String get cleaningRecordDetailsNotFound => 'Record not found';

  @override
  String get receiptTitle => 'RECEIPT';

  @override
  String get receiptNumber => 'Receipt Number';

  @override
  String get receiptDate => 'Date';

  @override
  String get receiptCustomerInfo => 'Customer Information';

  @override
  String get receiptSocietyName => 'Society Name';

  @override
  String get receiptAddress => 'Address';

  @override
  String get receiptCity => 'City';

  @override
  String get receiptContactPerson => 'Contact Person';

  @override
  String get receiptPhone => 'Phone';

  @override
  String get receiptServiceDetails => 'Service Details';

  @override
  String get receiptTankLocation => 'Tank Location';

  @override
  String get receiptCleaningDate => 'Cleaning Date';

  @override
  String get receiptNextCleaningDate => 'Next Cleaning Date';

  @override
  String get receiptPaymentInfo => 'Payment Information';

  @override
  String get receiptPaymentStatus => 'Payment Status';

  @override
  String get receiptPaymentMode => 'Payment Mode';

  @override
  String get receiptTotalAmount => 'Total Amount';

  @override
  String get receiptAmountDue => 'Amount Pending';

  @override
  String get receiptAmountPaid => 'Amount Paid';

  @override
  String get receiptAmountReceived => 'Received Amount';

  @override
  String get receiptThankYou => 'Thank you for your business!';

  @override
  String get receiptFooter =>
      'This is a computer-generated receipt. No signature required.';

  @override
  String get buttonDownloadReceipt => 'Download Receipt';

  @override
  String get receiptGenerating => 'Generating receipt...';

  @override
  String get receiptGenerated => 'Receipt generated successfully';

  @override
  String get receiptGenerationFailed => 'Failed to generate receipt';

  @override
  String get buttonExportAnalytics => 'Export Analytics to Excel';

  @override
  String get analyticsExcelGenerating => 'Generating Excel file...';

  @override
  String get analyticsExcelGenerated => 'Excel file generated successfully';

  @override
  String get analyticsExcelGenerationFailed => 'Failed to generate Excel file';
}
