import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

class S {
  S();

  static S? current;

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();

      return S.current!;
    });
  }

  static S? of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// Login Page

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get createAccount {
    return Intl.message(
      'Create Account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `sign in to continue `
  String get signInToContinue {
    return Intl.message(
      'Sign In To Continue',
      name: 'signInToContinue',
      desc: '',
      args: [],
    );
  }

  /// `Welcome `
  String get welcome {
    return Intl.message(
      'Welcome',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }


  /// `Forgot Password`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account`
  String get dontHaveAnAccount {
    return Intl.message(
      'Don\'t Have An Account',
      name: 'dontHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Email Address is Required`
  String get emailAddressIsRequired {
    return Intl.message(
      'Email Address Is Required',
      name: 'emailAddressIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Password is Required`
  String get passwordIsRequired {
    return Intl.message(
      'Password Is Required',
      name: 'passwordIsRequired',
      desc: '',
      args: [],
    );
  }


  /// Register Page

  /// `Create New Account`
  String get createNewAccount {
    return Intl.message(
      'Create New Account',
      name: 'createNewAccount',
      desc: '',
      args: [],
    );
  }

  /// `Already Have One`
  String get alreadyHaveOne {
    return Intl.message(
      'Already Have One',
      name: 'alreadyHaveOne',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get phone {
    return Intl.message(
      'Phone',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }


  /// `Complete Your Detail`
  String get completeYourDetail {
    return Intl.message(
      'Complete Your Detail',
      name: 'completeYourDetail',
      desc: '',
      args: [],
    );
  }


  /// `Confirm Code`
  String get confirmCode {
    return Intl.message(
      'Confirm Code',
      name: 'confirmCode',
      desc: '',
      args: [],
    );
  }


  /// `Resend Code`
  String get resendCode {
    return Intl.message(
      'Resend Code',
      name: 'resendCode',
      desc: '',
      args: [],
    );
  }

  /// `Name Is Required`
  String get nameIsRequired {
    return Intl.message(
      'Name Is Required`',
      name: 'nameIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Address Is Required`
  String get addressIsRequired {
    return Intl.message(
      'Address Is Required',
      name: 'addressIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Phone Is Required`
  String get phoneIsRequired {
    return Intl.message(
      'Phone Is Required',
      name: 'phoneIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Code`
  String get code {
    return Intl.message(
      'Code',
      name: 'code',
      desc: '',
      args: [],
    );
  }

  /// `Code Is Required`
  String get codeIsRequired {
    return Intl.message(
      'Code Is Required',
      name: 'codeIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get arabic {
    return Intl.message(
      'Arabic',
      name: 'arabic',
      desc: '',
      args: [],
    );
  }


  /// About Pages

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Title Page One`
  String get titlePageOne {
    return Intl.message(
      'Title Page One ',
      name: 'titlePageOne',
      desc: '',
      args: [],
    );
  }

  /// `Title Page Tow`
  String get titlePageTow {
    return Intl.message(
      'Title Page Tow ',
      name: 'titlePageTow',
      desc: '',
      args: [],
    );
  }

  /// `Title Page Three`
  String get titlePageThree {
    return Intl.message(
      'Title Page Three ',
      name: 'titlePageThree',
      desc: '',
      args: [],
    );
  }

  /// `Sub Title Page One`
  String get subTitlePageOne {
    return Intl.message(
      'Sub Title Page One ',
      name: 'subTitlePageOne',
      desc: '',
      args: [],
    );
  }

  /// `Sub Title Page Tow`
  String get subTitlePageTow {
    return Intl.message(
      'Sub Title Page Tow ',
      name: 'subTitlePageTow',
      desc: '',
      args: [],
    );
  }

  /// `Sub Title Page Three`
  String get subTitlePageThree {
    return Intl.message(
      'Sub Title Page Three ',
      name: 'subTitlePageThree',
      desc: '',
      args: [],
    );
  }


  /// Home
  ///Nav Bar
  /// `Home`
  String get home {
    return Intl.message(
      'Home ',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Orders`
  String get orders {
    return Intl.message(
      'Orders',
      name: 'orders',
      desc: '',
      args: [],
    );
  }

  /// `Re Order`
  String get reOrder {
    return Intl.message(
      'Re Order',
      name: 'reOrder',
      desc: '',
      args: [],
    );
  }

  /// `No Data To Display`
  String get noDataToDisplay {
    return Intl.message(
      'No Data To Display',
      name: 'noDataToDisplay',
      desc: '',
      args: [],
    );
  }


  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Plot`
  String get plot {
    return Intl.message(
      'Plot',
      name: 'plot',
      desc: '',
      args: [],
    );
  }


  /// `Ship`
  String get ship {
    return Intl.message(
      'Ship',
      name: 'ship',
      desc: '',
      args: [],
    );
  }

  /// `More`
  String get more {
    return Intl.message(
      'More',
      name: 'more',
      desc: '',
      args: [],
    );
  }

  /// `Delivery To`
  String get deliveryTo {
    return Intl.message(
      'Delivery To',
      name: 'deliveryTo',
      desc: '',
      args: [],
    );
  }

  /// `Coming Soon`
  String get comingSoon {
    return Intl.message(
      'Coming Soon',
      name: 'comingSoon',
      desc: '',
      args: [],
    );
  }

  /// `Please Wait`
  String get pleaseWait {
    return Intl.message(
      'Please Wait',
      name: 'pleaseWait',
      desc: '',
      args: [],
    );
  }

  /// `Not Logged IN`
  String get notLoggedIN {
    return Intl.message(
      'Not Logged IN',
      name: 'notLoggedIN',
      desc: '',
      args: [],
    );
  }
  /// `Number Of Items Required`
  String get numberOfItemsRequired {
    return Intl.message(
      'Number Of Items Required',
      name: 'numberOfItemsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Determine Location`
  String get determineLocation {
    return Intl.message(
      'Determine Location',
      name: 'determineLocation',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get refresh {
    return Intl.message(
      'Refresh',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }


  /// Setting Page

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `About App`
  String get aboutApp {
    return Intl.message(
      'About App',
      name: 'aboutApp',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Policy`
  String get deliveryPolicy {
    return Intl.message(
      'Delivery Policy',
      name: 'deliveryPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contactUs {
    return Intl.message(
      'Contact Us',
      name: 'contactUs',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `About App Description`
  String get aboutAppDescription {
    return Intl.message(
      'About App Description',
      name: 'aboutAppDescription',
      desc: '',
      args: [],
    );
  }

  /// `Privacy App Title1 Description`
  String get privacyAppTitle1 {
    return Intl.message(
      'Privacy App Title1',
      name: 'privacyAppTitle1',
      desc: '',
      args: [],
    );
  }

  /// `Privacy App subTitle1 Description`
  String get privacyAppSubTitle {
    return Intl.message(
      'Privacy App Sub Title',
      name: 'privacyAppSubTitle',
      desc: '',
      args: [],
    );
  }


  /// `Privacy Delivery App Title Description`
  String get privacyDeliveryAppTitleDescription {
    return Intl.message(
      'Privacy Delivery App Title Description',
      name: 'privacyDeliveryAppTitleDescription',
      desc: '',
      args: [],
    );
  }


  /// `Privacy Delivery App Sub Title Description`
  String get privacyDeliveryAppSubTitleDescription {
    return Intl.message(
      'Privacy Delivery App Sub Title Description',
      name: 'privacyDeliveryAppSubTitleDescription',
      desc: '',
      args: [],
    );
  }


  /// Profile Page

  /// `My Profile`
  String get myProfile {
    return Intl.message(
      'My Profile',
      name: 'myProfile',
      desc: '',
      args: [],
    );
  }
  /// `Cart`
  String get cart {
    return Intl.message(
      'Cart',
      name: 'cart',
      desc: '',
      args: [],
    );
  }

  /// `My Information`
  String get myInformation {
    return Intl.message(
      'My Information',
      name: 'myInformation',
      desc: '',
      args: [],
    );
  }

  /// `My Address`
  String get myAddress {
    return Intl.message(
      'My Address',
      name: 'myAddress',
      desc: '',
      args: [],
    );
  }

  /// `Email And Phone`
  String get emailAndPhone {
    return Intl.message(
      'Email And Phone',
      name: 'emailAndPhone',
      desc: '',
      args: [],
    );
  }

  /// Orders Page
  /// `Current Orders`
  String get currentOrders {
    return Intl.message(
      'Current Orders',
      name: 'currentOrders',
      desc: '',
      args: [],
    );
  }

  /// `Previous Orders`
  String get previousOrders {
    return Intl.message(
      'Previous Orders',
      name: 'previousOrders',
      desc: '',
      args: [],
    );
  }

  /// `Order Detail`
  String get orderDetail {
    return Intl.message(
      'Order Detail',
      name: 'orderDetail',
      desc: '',
      args: [],
    );
  }

  /// `Track Shipment`
  String get trackShipment {
    return Intl.message(
      'Track Shipment',
      name: 'trackShipment',
      desc: '',
      args: [],
    );
  }

  /// `Order Number`
  String get orderNumber {
    return Intl.message(
      'Order Number',
      name: 'orderNumber',
      desc: '',
      args: [],
    );
  }

  /// Ship Pages
  ///
  /// `Shopping Cart`
  String get shoppingCart {
    return Intl.message(
      'Shopping Cart',
      name: 'shoppingCart',
      desc: '',
      args: [],
    );
  }

  /// `Of`
  String get ofStepper {
    return Intl.message(
      'Of Stepper',
      name: 'ofStepper',
      desc: '',
      args: [],
    );
  }

  /// `Step One Title`
  String get stepOneTitle {
    return Intl.message(
      'Step One Title',
      name: 'stepOneTitle',
      desc: '',
      args: [],
    );
  }

  /// `Step One Sub Title`
  String get stepOneSubTitle {
    return Intl.message(
      'Step One Sub Title',
      name: 'stepOneSubTitle',
      desc: '',
      args: [],
    );
  }

  /// `Step Tow Title`
  String get stepTowTitle {
    return Intl.message(
      'Step Tow Title',
      name: 'stepTowTitle',
      desc: '',
      args: [],
    );
  }

  /// `Step Tow Sub Title`
  String get stepTowSubTitle {
    return Intl.message(
      'Step Tow Sub Title',
      name: 'stepTowSubTitle',
      desc: '',
      args: [],
    );
  }

  /// `Step Three Title`
  String get stepThreeTitle {
    return Intl.message(
      'Step Three Title',
      name: 'stepThreeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Step Three Sub Title`
  String get stepThreeSubTitle {
    return Intl.message(
      'Step Three Sub Title',
      name: 'stepThreeSubTitle',
      desc: '',
      args: [],
    );
  }

  /// `Service Coming Soon`
  String get serviceComingSoon {
    return Intl.message(
      'Service Coming Soon',
      name: 'serviceComingSoon',
      desc: '',
      args: [],
    );
  }


  /// `Another Address`
  String get anotherAddress {
    return Intl.message(
      'Another Address',
      name: 'anotherAddress',
      desc: '',
      args: [],
    );
  }


  /// `Save Another Address`
  String get saveAnotherAddress {
    return Intl.message(
      'Save Another Address',
      name: 'saveAnotherAddress',
      desc: '',
      args: [],
    );
  }


  /// `Enter the name of the bookmark`
  String get enterTheNameOfTheBookmark {
    return Intl.message(
      'Enter the name of the bookmark',
      name: 'enterTheNameOfTheBookmark',
      desc: '',
      args: [],
    );
  }
  /// `please wait for save location`
  String get pleaseWaitForSaveLocation {
    return Intl.message(
      'please wait for save location',
      name: 'pleaseWaitForSaveLocation',
      desc: '',
      args: [],
    );
  }
  /// `Success save location`
  String get successSaveLocation {
    return Intl.message(
      'Success save location',
      name: 'successSaveLocation',
      desc: '',
      args: [],
    );
  }
  /// `Error save location`
  String get errorSaveLocation {
    return Intl.message(
      'Error save location',
      name: 'errorSaveLocation',
      desc: '',
      args: [],
    );
  }

  /// `Name book Mark`
  String get nameBookMark {
    return Intl.message(
      'Name book Mark',
      name: 'nameBookMark',
      desc: '',
      args: [],
    );
  }

  /// `After Save Location`
  String get afterSaveLocation {
    return Intl.message(
      'After Save Location',
      name: 'afterSaveLocation',
      desc: '',
      args: [],
    );
  }

  /// `Error Load Location`
  String get errorLoadLocation {
    return Intl.message(
      'Error Load Location',
      name: 'errorLoadLocation',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get to {
    return Intl.message(
      'To',
      name: 'to',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get remove {
    return Intl.message(
      'Remove',
      name: 'remove',
      desc: '',
      args: [],
    );
  }
  /// `Signed out successfully`
  String get signedOutSuccessfully {
    return Intl.message(
      'Signed Out Successfully',
      name: 'signedOutSuccessfully',
      desc: '',
      args: [],
    );
  }


  /// `Removed`
  String get removed {
    return Intl.message(
      'removed',
      name: 'removed',
      desc: '',
      args: [],
    );
  }
  /// `Next Time Book Mark`
  String get nextTimeBookMark {
    return Intl.message(
      'Next Time Book Mark',
      name: 'nextTimeBookMark',
      desc: '',
      args: [],
    );
  }


  /// `Hint Text Book Mark Field`
  String get hintTextBookMarkField {
    return Intl.message(
      'Hint Text Book Mark Field',
      name: 'hintTextBookMarkField',
      desc: '',
      args: [],
    );
  }
  /// `Empty Ship`
  String get emptyShip {
    return Intl.message(
      'Empty Ship',
      name: 'emptyShip',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `Complete The Order`
  String get completeTheOrder {
    return Intl.message(
      'Complete The Order',
      name: 'completeTheOrder',
      desc: '',
      args: [],
    );
  }

  /// `Order Added Successfully`
  String get orderAddedSuccessfully {
    return Intl.message(
      'Order Added Successfully',
      name: 'orderAddedSuccessfully',
      desc: '',
      args: [],
    );
  }


  /// `Order Was Not Added`
  String get orderWasNotAdded {
    return Intl.message(
      'Order Was Not Added',
      name: 'orderWasNotAdded',
      desc: '',
      args: [],
    );
  }

  /// `Payment Summary`
  String get paymentSummary {
    return Intl.message(
      'Payment Summary',
      name: 'paymentSummary',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message(
      'Total',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `Add More`
  String get addMore {
    return Intl.message(
      'Add More',
      name: 'addMore',
      desc: '',
      args: [],
    );
  }

  /// `Minimum Alert`
  String get minimumAlert {
    return Intl.message(
      'Minimum Alert',
      name: 'minimumAlert',
      desc: '',
      args: [],
    );
  }

  /// `Destination`
  String get destination {
    return Intl.message(
      'Destination',
      name: 'destination',
      desc: '',
      args: [],
    );
  }

  /// `Note`
  String get note {
    return Intl.message(
      'Note',
      name: 'note',
      desc: '',
      args: [],
    );
  }

  /// `Note Message`
  String get noteMessage {
    return Intl.message(
      'Note Message',
      name: 'noteMessage',
      desc: '',
      args: [],
    );
  }

  /// `Password Short`
  String get shortPassword {
    return Intl.message(
      'Password Short',
      name: 'shortPassword',
      desc: '',
      args: [],
    );
  }
  /// `Confirm Password Required`
  String get confirmPasswordRequired {
    return Intl.message(
      'Confirm Password Required',
      name: 'confirmPasswordRequired',
      desc: '',
      args: [],
    );
  }
  /// `Valid Phone`
  String get validPhone {
    return Intl.message(
      'Valid Phone',
      name: 'validPhone',
      desc: '',
      args: [],
    );
  }
  /// `Change`
  String get change {
    return Intl.message(
      'Change',
      name: 'change',
      desc: '',
      args: [],
    );
  }

  /// `Street`
  String get street {
    return Intl.message(
      'Street',
      name: 'street',
      desc: '',
      args: [],
    );
  }

  /// `MyKom Express Service`
  String get myKomExpressService {
    return Intl.message(
      'MyKom Express Service',
      name: 'myKomExpressService',
      desc: '',
      args: [],
    );
  }

  /// `MyKom Express Service Message Disable`
  String get myKomExpressServiceMessageDisable {
    return Intl.message(
      'MyKom Express Service Message Disable',
      name: 'myKomExpressServiceMessageDisable',
      desc: '',
      args: [],
    );
  }

  /// `MyKom Express Service Message Enable`
  String get myKomExpressServiceMessageEnable {
    return Intl.message(
      'MyKom Express Service Message Enable',
      name: 'myKomExpressServiceMessageEnable',
      desc: '',
      args: [],
    );
  }

  /// `MyKom Express`
  String get myKomExpress {
    return Intl.message(
      'MyKom Express',
      name: 'myKomExpress',
      desc: '',
      args: [],
    );
  }

  /// `Extra Charge`
  String get extraCharge {
    return Intl.message(
      'Extra Charge',
      name: 'extraCharge',
      desc: '',
      args: [],
    );
  }

  /// `Order Value`
  String get orderValue {
    return Intl.message(
      'Order Value',
      name: 'orderValue',
      desc: '',
      args: [],
    );
  }

  /// `Title Delete Account Alert`
  String get titleDeleteAccountAlert {
    return Intl.message(
      'Title Delete Account Alert',
      name: 'titleDeleteAccountAlert',
      desc: '',
      args: [],
    );
  }
  /// `Sub Title Delete Account Alert`
  String get subTitleDeleteAccountAlert {
    return Intl.message(
      'Sub Title Delete Account Alert',
      name: 'subTitleDeleteAccountAlert',
      desc: '',
      args: [],
    );
  }
  /// `Delete Account Alert Button`
  String get deleteAccountAlertButton {
    return Intl.message(
      'Delete Account Alert Button',
      name: 'deleteAccountAlertButton',
      desc: '',
      args: [],
    );
  }  /// `Cancel Account Delete Alert Button`
  String get cancelAccountDeleteAlertButton {
    return Intl.message(
      'Sub Title Delete Account Alert',
      name: 'cancelAccountDeleteAlertButton',
      desc: '',
      args: [],
    );
  }

  /// `Optional`
  String get optional {
    return Intl.message(
      'Optional',
      name: 'optional',
      desc: '',
      args: [],
    );
  }

  /// `Required`
  String get required {
    return Intl.message(
      'Required',
      name: 'required',
      desc: '',
      args: [],
    );
  }
  /// `Required Cart Field Message`
  String get requiredCartFieldMessage {
    return Intl.message(
      'Required Cart Field Message',
      name: 'requiredCartFieldMessage',
      desc: '',
      args: [],
    );
  }

  /// `Building Or Home Number`
  String get buildingOrHomeNumber {
    return Intl.message(
      'Building Or Home Number',
      name: 'buildingOrHomeNumber',
      desc: '',
      args: [],
    );
  }
  /// `Building Or Home Number Hint`
  String get buildingOrHomeNumberHint {
    return Intl.message(
      'Building Or Home Number Hint',
      name: 'buildingOrHomeNumberHint',
      desc: '',
      args: [],
    );
  }

  /// `Success Delete Account`
  String get successDeleteAccount {
    return Intl.message(
      'Success Delete Account',
      name: 'successDeleteAccount',
      desc: '',
      args: [],
    );
  }
  /// `Error Delete Account`
  String get errorDeleteAccount {
    return Intl.message(
      'Error Delete Account',
      name: 'errorDeleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Payment Methods`
  String get paymentMethods {
    return Intl.message(
      'Payment Methods',
      name: 'paymentMethods',
      desc: '',
      args: [],
    );
  }

  /// `Cash Money `
  String get cashMoney {
    return Intl.message(
      'Cash Money',
      name: 'cashMoney',
      desc: '',
      args: [],
    );
  }

  /// `Delete My Account `
  String get deleteMyAccount {
    return Intl.message(
      'Delete My Account',
      name: 'deleteMyAccount',
      desc: '',
      args: [],
    );
  }



  /// `Companies`
  String get companies {
    return Intl.message(
      'Companies',
      name: 'companies',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Recommended `
  String get recommended {
    return Intl.message(
      'Recommended',
      name: 'recommended',
      desc: '',
      args: [],
    );
  }


  /// `Credit Card`
  String get creditCard {
    return Intl.message(
      'Credit Card',
      name: 'creditCard',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method Alert`
  String get paymentMethodAlert {
    return Intl.message(
      'Payment Method Alert',
      name: 'paymentMethodAlert',
      desc: '',
      args: [],
    );
  }

  /// `Destination Alert`
  String get destinationAlert {
    return Intl.message(
      'Destination Alert',
      name: 'destinationAlert',
      desc: '',
      args: [],
    );
  }

  /// `Order Confirmation`
  String get orderConfirmation {
    return Intl.message(
      'Order Confirmation',
      name: 'orderConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Pay By Card`
  String get payByCard {
    return Intl.message(
      'Pay By Card',
      name: 'payByCard',
      desc: '',
      args: [],
    );
  }

  /// `Add Card`
  String get addCard {
    return Intl.message(
      'Add Card',
      name: 'addCard',
      desc: '',
      args: [],
    );
  }

  /// `Select Card Alert`
  String get selectCardAlert {
    return Intl.message(
      'Select Card Alert',
      name: 'selectCardAlert',
      desc: '',
      args: [],
    );
  }

  /// `Products And Company Pages`

  /// `Search Product`
  String get searchForYourProducts {
    return Intl.message(
      'Search For Your Products',
      name: 'searchForYourProducts',
      desc: '',
      args: [],
    );
  }

  /// `Added`
  String get added {
    return Intl.message(
      'Added',
      name: 'added',
      desc: '',
      args: [],
    );
  }

  /// `See The Cart`
  String get seeTheCart {
    return Intl.message(
      'See The Cart',
      name: 'seeTheCart',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Add To Cart`
  String get addToCart {
    return Intl.message(
      'Add To Cart',
      name: 'addToCart',
      desc: '',
      args: [],
    );
  }

  /// `Items have been added`
  String get itemsHaveBeenAdded {
    return Intl.message(
      'Items have been added',
      name: 'itemsHaveBeenAdded',
      desc: '',
      args: [],
    );
  }

  /// `Select the number of items required`
  String get selectTheNumberOfItemsRequired {
    return Intl.message(
      'Select the number of items required',
      name: 'selectTheNumberOfItemsRequired',
      desc: '',
      args: [],
    );
  }
  /// `Register address success message`
  String get registerAddressSuccessMessage {
    return Intl.message(
      'Register address success message',
      name: 'registerAddressSuccessMessage',
      desc: '',
      args: [],
    );
  }
  /// `Register address error message`
  String get registerAddressErrorMessage {
    return Intl.message(
      'Register address error message',
      name: 'registerAddressErrorMessage',
      desc: '',
      args: [],
    );
  }
  /// `Rival`
  String get rival {
    return Intl.message(
      'Rival',
      name: 'rival',
      desc: '',
      args: [],
    );
  }

  /// Orders List

  /// `Tracking Order`
  String get trackingOrder {
    return Intl.message(
      'Tracking Order',
      name: 'trackingOrder',
      desc: '',
      args: [],
    );
  }

  /// `Order Tracking Number`
  String get orderTrackingNumber {
    return Intl.message(
      'Order Tracking Number',
      name: 'orderTrackingNumber',
      desc: '',
      args: [],
    );
  }

  /// `Got Caption`
  String get gotCaption {
    return Intl.message(
      'Got Caption',
      name: 'gotCaption',
      desc: '',
      args: [],
    );
  }

  /// `Got Caption Des`
  String get gotCaptionDes {
    return Intl.message(
      'Got Caption Des',
      name: 'gotCaptionDes',
      desc: '',
      args: [],
    );
  }


  /// `In Store`
  String get inStore {
    return Intl.message(
      'In Store',
      name: 'inStore',
      desc: '',
      args: [],
    );
  }

  /// `In Store Des`
  String get inStoreDes {
    return Intl.message(
      'In Store Des',
      name: 'inStoreDes',
      desc: '',
      args: [],
    );
  }

  /// `Delivery`
  String get delivery {
    return Intl.message(
      'Delivery',
      name: 'delivery',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Des`
  String get deliveryDes {
    return Intl.message(
      'Delivery Des',
      name: 'deliveryDes',
      desc: '',
      args: [],
    );
  }


  /// `Got Cash`
  String get gotCash {
    return Intl.message(
      'Got Cash',
      name: 'gotCash',
      desc: '',
      args: [],
    );
  }


  /// `Got Cash Des`
  String get gotCashDes {
    return Intl.message(
      'Got Cash Des',
      name: 'gotCashDes',
      desc: '',
      args: [],
    );
  }

  /// `Finished`
  String get finished {
    return Intl.message(
      'Finished',
      name: 'finished',
      desc: '',
      args: [],
    );
  }

  /// `Finished Des`
  String get finishedDes {
    return Intl.message(
      'Finished Des',
      name: 'finishedDes',
      desc: '',
      args: [],
    );
  }

  /// Order Detail

  /// `Quick Order`
  String get quickOrder {
    return Intl.message(
      'Quick Order',
      name: 'quickOrder',
      desc: '',
      args: [],
    );
  }



  /// `Price`
  String get price {
    return Intl.message(
      'Price',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `Order Date`
  String get orderDate {
    return Intl.message(
      'Order Date',
      name: 'orderDate',
      desc: '',
      args: [],
    );
  }
  /// `Order Products`
  String get orderProducts {
    return Intl.message(
      'Order Products',
      name: 'orderProducts',
      desc: '',
      args: [],
    );
  }
  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }
  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Success Login`
  String get successLogin {
    return Intl.message(
      'Success Login',
      name: 'successLogin',
      desc: '',
      args: [],
    );
  }

  /// `Email Is Already`
  String get emailIsAlready {
    return Intl.message(
      'Email Is Already',
      name: 'emailIsAlready',
      desc: '',
      args: [],
    );
  }

  /// `Account Not Found`
  String get accountNotFound {
    return Intl.message(
      'Email Is Already',
      name: 'emailIsAlready',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect Password`
  String get incorrectPassword {
    return Intl.message(
      'Incorrect Password',
      name: 'incorrectPassword',
      desc: '',
      args: [],
    );
  }

  /// `Error In Login`
  String get errorInLogin {
    return Intl.message(
      'Error In Login',
      name: 'errorInLogin',
      desc: '',
      args: [],
    );
  }

  /// `Error In Register`
  String get errorInRegister {
    return Intl.message(
      'Error In Register',
      name: 'errorInRegister',
      desc: '',
      args: [],
    );
  }

  /// `Go To Home`
  String get goToHome {
    return Intl.message(
      'Go To Home',
      name: 'goToHome',
      desc: '',
      args: [],
    );
  }

  /// `Order Success Added`
  String get orderSuccessAdded {
    return Intl.message(
      'Order Success Added',
      name: 'orderSuccessAdded',
      desc: '',
      args: [],
    );
  }

  /// `Order Error Added`
  String get orderErrorAdded {
    return Intl.message(
      'Order Error Added',
      name: 'orderErrorAdded',
      desc: '',
      args: [],
    );
  }

  /// `Map Save`
  String get mapSave {
    return Intl.message(
      'Map Save',
      name: 'mapSave',
      desc: '',
      args: [],
    );
  }

  /// `Map Delivery`
  String get mapDelivery {
    return Intl.message(
      'Map Delivery',
      name: 'mapDelivery',
      desc: '',
      args: [],
    );
  }
  /// `Thank You`
  String get thankYou {
    return Intl.message(
      'Thank You',
      name: 'thankYou',
      desc: '',
      args: [],
    );
  }
  /// `Order received`
  String get orderReceived {
    return Intl.message(
      'Order received',
      name: 'orderReceived',
      desc: '',
      args: [],
    );
  }
  /// `Select And Save `
  String get selectAndSave {
    return Intl.message(
      'Select And Save',
      name: 'selectAndSave',
      desc: '',
      args: [],
    );
  }

  /// `Error In Get Current Location `
  String get errorInGetCurrentLocation {
    return Intl.message(
      'Error In Get Current Location',
      name: 'errorInGetCurrentLocation',
      desc: '',
      args: [],
    );
  }
  /// `Code Send `
  String get codeSend {
    return Intl.message(
      'Code Send',
      name: 'codeSend',
      desc: '',
      args: [],
    );
  }

  /// `Code Time Out`
  String get codeTimeOut {
    return Intl.message(
      'Code Time Out',
      name: 'codeTimeOut',
      desc: '',
      args: [],
    );
  }

  /// `UnAuth`
  String get unAuth {
    return Intl.message(
      'UnAuth',
      name: 'unAuth',
      desc: '',
      args: [],
    );
  }
  /// `Credit Coming Soon`
  String get creditComingSoon {
    return Intl.message(
      'Credit Coming Soon',
      name: 'creditComingSoon',
      desc: '',
      args: [],
    );
  }
}


class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}
