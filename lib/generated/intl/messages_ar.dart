import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ar';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{

    /// login page
    "login": MessageLookupByLibrary.simpleMessage("دخول"),
    "email": MessageLookupByLibrary.simpleMessage("الايميل"),
    "password": MessageLookupByLibrary.simpleMessage("كلمة المرور"),
    "createAccount": MessageLookupByLibrary.simpleMessage("انشاء حساب"),
    "confirmPassword": MessageLookupByLibrary.simpleMessage("تأكيد كلمة المرور"),
    "signInToContinue": MessageLookupByLibrary.simpleMessage("سجل دخول للمتابعة"),
    "welcome": MessageLookupByLibrary.simpleMessage("مرحبا"),
    "forgotPassword": MessageLookupByLibrary.simpleMessage("نسيت كلمة المرور؟"),
    "dontHaveAnAccount": MessageLookupByLibrary.simpleMessage("لا تملك حساب؟"),
    "emailAddressIsRequired": MessageLookupByLibrary.simpleMessage("الايميل مطلوب"),
    "passwordIsRequired": MessageLookupByLibrary.simpleMessage("كلمة السر مطلوبة"),

    /// Register Page

    "createNewAccount": MessageLookupByLibrary.simpleMessage("انشاء حساب جديد"),
    "alreadyHaveOne": MessageLookupByLibrary.simpleMessage("هل تملك حساب؟"),
    "next": MessageLookupByLibrary.simpleMessage("التالي"),
    "register": MessageLookupByLibrary.simpleMessage("تسجيل"),
    "phone": MessageLookupByLibrary.simpleMessage("الموبايل"),
    "address": MessageLookupByLibrary.simpleMessage("العنوان"),
    "name": MessageLookupByLibrary.simpleMessage("الاسم"),
    "completeYourDetail": MessageLookupByLibrary.simpleMessage("استكمال البيانات"),
    "confirmCode": MessageLookupByLibrary.simpleMessage("تأكيد"),
    "resendCode": MessageLookupByLibrary.simpleMessage("اعادة طلب الرمز"),
    "nameIsRequired": MessageLookupByLibrary.simpleMessage("الاسم مطلوب"),
    "addressIsRequired": MessageLookupByLibrary.simpleMessage("العنوان مطلوب"),
    "phoneIsRequired": MessageLookupByLibrary.simpleMessage("الرقم مطلوب"),
    "codeIsRequired": MessageLookupByLibrary.simpleMessage("رجاءا ادخل رمز التحقق"),
    "code": MessageLookupByLibrary.simpleMessage("رمز التحقق"),
    "newPassword": MessageLookupByLibrary.simpleMessage("كلمة السر الجديدة"),
    "registerAddressSuccessMessage": MessageLookupByLibrary.simpleMessage("يمكنك تغيير عنوانك الرئيسي من الصفحة الشخصية"),
    "registerAddressErrorMessage": MessageLookupByLibrary.simpleMessage("فشل تحديد موقعك ، يرجى إعادة تحديده"),
    "buildingOrHomeNumber": MessageLookupByLibrary.simpleMessage("رقم البناء أو المنزل"),
    "buildingOrHomeNumberHint": MessageLookupByLibrary.simpleMessage("أدخل أسم البناء أو رقم المنزل"),

    /// About Pages
    "skip": MessageLookupByLibrary.simpleMessage("تخطي"),
    "titlePageOne": MessageLookupByLibrary.simpleMessage("خيارات متعددة"),
    "titlePageTow": MessageLookupByLibrary.simpleMessage("ادفع بسهولة"),
    "titlePageThree": MessageLookupByLibrary.simpleMessage("توصيل مجاني"),
    "subTitlePageOne": MessageLookupByLibrary.simpleMessage("في ماي كوم تقدر تلاقي الخيار الذي يناسبك"),
    "subTitlePageTow": MessageLookupByLibrary.simpleMessage("طريقة الدفع في ماي كوم متعددة  ,ادفع بالطريقة الي تناسبك"),
    "subTitlePageThree": MessageLookupByLibrary.simpleMessage("بينما كل التطبيقات تحقق ارباحهامن رسوم التوصيل تطبيقنا يوصلك مجانا"),
    "deleteMyAccount": MessageLookupByLibrary.simpleMessage("حذف الحساب"),
    "optional": MessageLookupByLibrary.simpleMessage("اختياري"),
    "required": MessageLookupByLibrary.simpleMessage("مطلوب"),
    "requiredCartFieldMessage": MessageLookupByLibrary.simpleMessage("الرجاء إدخال الحقول المطلوبة"),


    /// Home Page
    "home": MessageLookupByLibrary.simpleMessage("الرئيسية"),
    "orders": MessageLookupByLibrary.simpleMessage("الطلبات"),
    "profile": MessageLookupByLibrary.simpleMessage("حسابي"),
    "ship": MessageLookupByLibrary.simpleMessage("السلة"),
    "more": MessageLookupByLibrary.simpleMessage("المزيد"),
    "deliveryTo": MessageLookupByLibrary.simpleMessage("التوصيل الى"),
    "comingSoon": MessageLookupByLibrary.simpleMessage("المنطقة غير متوفرة حاليًا حدد الموقع يدويًا"),
    "pleaseWait": MessageLookupByLibrary.simpleMessage("انتظر قليلا"),
    "notLoggedIN": MessageLookupByLibrary.simpleMessage("انت غير مشترك في \n MyKom"),
    "refresh": MessageLookupByLibrary.simpleMessage("تحديث"),
    "determineLocation": MessageLookupByLibrary.simpleMessage("تعذر تحديد الموقع ، حدد الموقع يدويًا"),
    "recommended": MessageLookupByLibrary.simpleMessage("موصى به"),
    "companies": MessageLookupByLibrary.simpleMessage("الشركات"),
    "all": MessageLookupByLibrary.simpleMessage("الكل"),

    /// Setting Page
    "settings": MessageLookupByLibrary.simpleMessage("الاعدادات"),
    "aboutApp": MessageLookupByLibrary.simpleMessage("حول التطبيق"),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage("سياسة الخصوصية"),
    "deliveryPolicy": MessageLookupByLibrary.simpleMessage("سياسة التوصيل"),
    "contactUs": MessageLookupByLibrary.simpleMessage("تواصل معنا"),
    "logout": MessageLookupByLibrary.simpleMessage("خروج"),
    "language": MessageLookupByLibrary.simpleMessage("اللغة"),
    "english": MessageLookupByLibrary.simpleMessage("الانكليزية"),
    "arabic": MessageLookupByLibrary.simpleMessage("العربية"),

    "aboutAppDescription": MessageLookupByLibrary.simpleMessage("تقوم شركة مملوكة لشباب إماراتي بفخر بتوصيل المياه والمواد الاستهلاكية إلى شعب الإمارات العربية المتحدة"),
    "privacyAppTitle1": MessageLookupByLibrary.simpleMessage("تاريخ السريان: 22 أغسطس 2019"),
    "privacyAppSubTitle": MessageLookupByLibrary.simpleMessage('''تقوم شركة MYKOM ("نحن" أو "نحن" أو "خاصتنا") بتشغيل https://mykom.app/ موقع الويب وتطبيقات الجوال ("الخدمة").

  تُعلمك هذه الصفحة بسياساتنا المتعلقة بجمع البيانات الشخصية واستخدامها والكشف عنها عند استخدام خدمتنا والخيارات التي قمت بربطها بهذه البيانات.

  نستخدم بياناتك لتوفير الخدمة وتحسينها. باستخدام الخدمة ، فإنك توافق على جمع واستخدام المعلومات وفقًا لهذه السياسة. ما لم يتم تحديد خلاف ذلك في سياسة الخصوصية هذه ، فإن المصطلحات المستخدمة في سياسة الخصوصية هذه لها نفس المعاني كما في الشروط والأحكام الخاصة بنا ، والتي يمكن الوصول إليها من https://mykom.app/



  جمع المعلومات واستخدامها

  نقوم بجمع عدة أنواع مختلفة من المعلومات لأغراض مختلفة لتوفير وتحسين خدماتنا لك.

  لن يتم تخزين جميع تفاصيل بطاقات الائتمان / الخصم ومعلومات التعريف الشخصية أو بيعها أو مشاركتها أو تأجيرها أو تأجيرها لأي طرف ثالث.
  لن يمرر https://mykom.app أي تفاصيل بطاقة خصم / ائتمان إلى جهات خارجية
  أنواع البيانات المجمعة
  بيانات شخصية
  أثناء استخدام خدمتنا ، قد نطلب منك تزويدنا بمعلومات تعريف شخصية معينة يمكن استخدامها للاتصال بك أو التعرف عليك ("البيانات الشخصية"). قد تتضمن معلومات التعريف الشخصية ، على سبيل المثال لا الحصر:
  *عنوان البريد الالكترونى
  * الاسم الأول واسم العائلة
  *رقم الهاتف
  * العنوان ، الولاية ، المقاطعة ، الرمز البريدي / الرمز البريدي ، المدينة
  المتطلبات القانونية
  قد يكشف mykom.app عن بياناتك الشخصية بحسن نية أن هذا الإجراء ضروري من أجل:

  * للامتثال لالتزام قانوني
  * لحماية حقوق أو ممتلكات mykom.app والدفاع عنها
  * لمنع أو التحقيق في أي مخالفات محتملة تتعلق بالخدمة
  * لحماية السلامة الشخصية لمستخدمي الخدمة أو الجمهور
  * للحماية من المسؤولية القانونية
  مقدمي الخدمة

  يجوز لنا توظيف شركات وأفراد من أطراف ثالثة لتسهيل خدمتنا ("مزودي الخدمة") ، أو لتقديم الخدمة نيابة عنا ، أو لأداء الخدمات المتعلقة بالخدمة أو لمساعدتنا في تحليل كيفية استخدام خدمتنا.

  هذه الأطراف الثالثة لديها حق الوصول إلى بياناتك الشخصية فقط لأداء هذه المهام نيابة عنا وهي ملزمة بعدم الكشف عنها أو استخدامها لأي غرض آخر.
  خصوصية الأطفال

  لا تخاطب خدمتنا أي شخص يقل عمره عن 18 عامًا ("الأطفال").

  نحن لا نجمع عن عمد معلومات تعريف شخصية من أي شخص يقل عمره عن 18 عامًا. إذا كنت أحد الوالدين أو الوصي وتدرك أن أطفالك قد زودونا ببيانات شخصية ، فيرجى الاتصال بنا. إذا علمنا أننا جمعنا بيانات شخصية من الأطفال دون التحقق من موافقة الوالدين ، فإننا نتخذ خطوات لإزالة تلك المعلومات من خوادمنا.
  التغييرات على سياسة الخصوصية هذه

  قد نقوم بتحديث سياسة الخصوصية الخاصة بنا من وقت لآخر. سنخطرك بأي تغييرات عن طريق نشر سياسة الخصوصية الجديدة على هذه الصفحة.

  سنخبرك عبر البريد الإلكتروني و / أو إشعارًا بارزًا على خدمتنا ، قبل أن يصبح التغيير ساريًا وتحديث "تاريخ السريان" في الجزء العلوي من سياسة الخصوصية هذه.'''),

    "privacyDeliveryAppTitleDescription": MessageLookupByLibrary.simpleMessage("معلومات التسليم الهامة"),

    "privacyDeliveryAppSubTitleDescription": MessageLookupByLibrary.simpleMessage('''* نقدم منتجاتنا داخل الإمارات فقط. سيتم الشحن بشكل أساسي بواسطتنا ، ولكن قد نستخدم ساعيًا تابعًا لجهة خارجية عند الضرورة.
* التوصيل داخل المدن الرئيسية بدولة الإمارات العربية المتحدة يكون في غضون يوم إلى يومين عمل. بالنسبة للمناطق النائية في دولة الإمارات العربية المتحدة ، يكون التوصيل من 4 إلى 10 أيام عمل.
* نحن نقدم التوصيل المجاني. لتجنب أي تأخير في التسليم ، يرجى تقديم عنوانك الكامل مع تفاصيل الاتصال الخاصة بك.
* ستتم معالجة أي طلبات يتم استلامها خلال عطلة نهاية الأسبوع أو أيام العطلات في يوم العمل التالي.'''),




    /// Profile Page
    "emailAndPhone": MessageLookupByLibrary.simpleMessage("الايميل والهاتف"),
    "myAddress": MessageLookupByLibrary.simpleMessage("عنواني"),
    "myInformation": MessageLookupByLibrary.simpleMessage("معلوماتي الشخصية"),
    "myProfile": MessageLookupByLibrary.simpleMessage("الحساب\nالشخصي"),
    "titleDeleteAccountAlert": MessageLookupByLibrary.simpleMessage("هل تريد حذف حسابك؟"),
    "subTitleDeleteAccountAlert": MessageLookupByLibrary.simpleMessage("ملاحظة: عندما تحذف حسابك ، ستفقد بياناتك الشخصية على تطبيق مايكوم."),
    "deleteAccountAlertButton": MessageLookupByLibrary.simpleMessage("حذف"),
    "cancelAccountDeleteAlertButton": MessageLookupByLibrary.simpleMessage("الغاء"),
    "successDeleteAccount": MessageLookupByLibrary.simpleMessage("تم حذف الحساب بنجاح"),
    "errorDeleteAccount": MessageLookupByLibrary.simpleMessage("حدث خطأ !"),
    /// Orders Page
    "currentOrders": MessageLookupByLibrary.simpleMessage("الطلبات الحالية"),
    "previousOrders": MessageLookupByLibrary.simpleMessage("الطلبات السابقة"),
    "trackShipment": MessageLookupByLibrary.simpleMessage("تتبع الشحنة"),
    "orderNumber": MessageLookupByLibrary.simpleMessage("رقم"),
    "orderDetail": MessageLookupByLibrary.simpleMessage("تفاصيل"),
    "reOrder": MessageLookupByLibrary.simpleMessage("اعادة الطلب"),
    "noDataToDisplay": MessageLookupByLibrary.simpleMessage("لا يوجد بيانات لعرضها"),


    /// Ship Pages
    "shoppingCart": MessageLookupByLibrary.simpleMessage("سلة المشتريات"),
    "ofStepper": MessageLookupByLibrary.simpleMessage("من"),
    "stepOneTitle": MessageLookupByLibrary.simpleMessage("تفاصيل وسعر الشحنة"),
    "stepOneSubTitle": MessageLookupByLibrary.simpleMessage("التالي هو الوجهة ، نوع الطلب"),
    "stepTowTitle": MessageLookupByLibrary.simpleMessage("الوجهة ونوع الطلب"),
    "stepTowSubTitle": MessageLookupByLibrary.simpleMessage("التالي هو تفاصيل الشحن والدفع"),
    "stepThreeTitle": MessageLookupByLibrary.simpleMessage("تفاصيل الشحن والدفع"),
    "stepThreeSubTitle": MessageLookupByLibrary.simpleMessage("التالي هو تأكيد الطلب"),
    "emptyShip": MessageLookupByLibrary.simpleMessage('السلة فارغة, أضف منتجات'),
    "back": MessageLookupByLibrary.simpleMessage('رجوع'),
    "completeTheOrder": MessageLookupByLibrary.simpleMessage('قم باتمام الطلب'),
    "orderWasNotAdded": MessageLookupByLibrary.simpleMessage('حدث خطأ لم يتم ارسال الطلب, حول مرة أخرى'),
    "orderAddedSuccessfully": MessageLookupByLibrary.simpleMessage('تم ارسال الطلب بنجاح'),
    "paymentSummary": MessageLookupByLibrary.simpleMessage("ملخص الدفع"),
    "myProducts": MessageLookupByLibrary.simpleMessage("منتجاتي"),
    "total": MessageLookupByLibrary.simpleMessage("الكل"),
    "addMore": MessageLookupByLibrary.simpleMessage("أضف المزيد"),
    "minimumAlert": MessageLookupByLibrary.simpleMessage("الحد الأدنى للطلب "),
    "destination": MessageLookupByLibrary.simpleMessage("الوجهة"),
    "change": MessageLookupByLibrary.simpleMessage("تغيير"),
    "street": MessageLookupByLibrary.simpleMessage("الشارع"),
    "myKomExpressService": MessageLookupByLibrary.simpleMessage("خدمة MyKom Express"),
    "myKomExpressServiceMessageEnable": MessageLookupByLibrary.simpleMessage("سيؤدي تفعيل ميزة mykom express إلى تسريع توصيل طلبك وزيادة رسوم الدفع البالغة 10.0 درهم"),
    "myKomExpressServiceMessageDisable": MessageLookupByLibrary.simpleMessage("ميزة خدمة MyKom Express  معطلة حاليًا"),
    "myKomExpress": MessageLookupByLibrary.simpleMessage("خدمة MyKom Express"),
    "extraCharge": MessageLookupByLibrary.simpleMessage("الرسوم الاضافية"),
    "orderValue": MessageLookupByLibrary.simpleMessage("قيمة الطلب"),
    "paymentMethods": MessageLookupByLibrary.simpleMessage("طريقة الدفع"),
    "cashMoney": MessageLookupByLibrary.simpleMessage("الدفع نقدا"),
    "creditCard": MessageLookupByLibrary.simpleMessage("الدفع باسخدام البطاقة"),
    "paymentMethodAlert": MessageLookupByLibrary.simpleMessage("رجاءا اختر طريقة الدفع"),
    "destinationAlert": MessageLookupByLibrary.simpleMessage("قم باختيار موقع صحيح ينتمي للمناطق المخدمة "),
    "orderConfirmation": MessageLookupByLibrary.simpleMessage("تأكيد"),
    "payByCard": MessageLookupByLibrary.simpleMessage("دفع اونلاين"),
    "addCard": MessageLookupByLibrary.simpleMessage("أضف بطاقة"),
    "selectCardAlert": MessageLookupByLibrary.simpleMessage("رجاءا حدد بطاقة الدفع "),

    /// Products Pages

    "searchForYourProducts": MessageLookupByLibrary.simpleMessage("ابحث عن منتجات معينة"),
    "added": MessageLookupByLibrary.simpleMessage("أضف"),
    "seeTheCart": MessageLookupByLibrary.simpleMessage("اذهب الى السلة"),
    "addToCart": MessageLookupByLibrary.simpleMessage(" أضف الى السلة"),
    "description": MessageLookupByLibrary.simpleMessage("الوصف"),
    "selectTheNumberOfItemsRequired": MessageLookupByLibrary.simpleMessage("قم بتحديد عدد المنتجات ثم أضف"),
    "itemsHaveBeenAdded": MessageLookupByLibrary.simpleMessage("تم أضافة المنتجات الى السلة"),
    "rival": MessageLookupByLibrary.simpleMessage("خصم"),


    /// Order Pages

    "trackingOrder": MessageLookupByLibrary.simpleMessage("تتبع الطلب"),
    "orderTrackingNumber": MessageLookupByLibrary.simpleMessage("رقم الطلب"),
    "gotCaption": MessageLookupByLibrary.simpleMessage("استلام الطلب"),
    "gotCaptionDes": MessageLookupByLibrary.simpleMessage("تم استلام الطلب , تتم المعالجة"),
    "inStore": MessageLookupByLibrary.simpleMessage("في المخزن"),
    "inStoreDes": MessageLookupByLibrary.simpleMessage("يتم الان تجهيز طلبك في المستودع"),
    "delivery": MessageLookupByLibrary.simpleMessage("التوصيل"),
    "deliveryDes": MessageLookupByLibrary.simpleMessage("الطلب في الطريق اليك"),
    "gotCash": MessageLookupByLibrary.simpleMessage("مرحلة التسليم"),
    "gotCashDes": MessageLookupByLibrary.simpleMessage("استلام الطلب ودفع النقود "),
    "finished": MessageLookupByLibrary.simpleMessage("النهاية"),
    "finishedDes": MessageLookupByLibrary.simpleMessage("تم استلام الطلب بنجاح"),

    "quickOrder": MessageLookupByLibrary.simpleMessage("طلب سريع"),
    "price": MessageLookupByLibrary.simpleMessage("سعر الشحنة"),
    "orderDate": MessageLookupByLibrary.simpleMessage("تاريخ طلب الشحنة"),
    "orderProducts": MessageLookupByLibrary.simpleMessage("محتوى الشحنة"),
    "no": MessageLookupByLibrary.simpleMessage("لا"),
    "yes": MessageLookupByLibrary.simpleMessage("نعم"),

    "successLogin": MessageLookupByLibrary.simpleMessage("تم تسجيل الدخول بنجاح"),
    "emailIsAlready": MessageLookupByLibrary.simpleMessage("الايميل موجود مسبقا"),
    "accountNotFound": MessageLookupByLibrary.simpleMessage("الحساب غير موجود"),
    "incorrectPassword": MessageLookupByLibrary.simpleMessage("كلمة السر غير صحيحة"),
    "errorInLogin": MessageLookupByLibrary.simpleMessage("خطأ في تسجيل الدخول"),
    "errorInRegister": MessageLookupByLibrary.simpleMessage("خطأ في عملية التسجيل"),
    "goToHome": MessageLookupByLibrary.simpleMessage("الذهاب الى الرئيسية"),
    "mapSave": MessageLookupByLibrary.simpleMessage("حفظ"),
    "mapDelivery": MessageLookupByLibrary.simpleMessage("توصيل الى هنا"),
    "thankYou": MessageLookupByLibrary.simpleMessage("شكرا لك !"),
    "orderReceived": MessageLookupByLibrary.simpleMessage("تم استلام طلبك"),
    "selectAndSave": MessageLookupByLibrary.simpleMessage("قم بتحديد موقع"),
    "errorInGetCurrentLocation": MessageLookupByLibrary.simpleMessage("فشل في تحديد الموقع"),

    "codeSend": MessageLookupByLibrary.simpleMessage("تم ارسال الرمز برسالة نصية"),
    "codeTimeOut": MessageLookupByLibrary.simpleMessage("تم انتهاء مدة الرمز المرسل , قم باعادة طلب الرمز"),
    "creditComingSoon": MessageLookupByLibrary.simpleMessage("قريبا !!!"),
    "serviceComingSoon": MessageLookupByLibrary.simpleMessage("قريبا !!!"),
    "anotherAddress": MessageLookupByLibrary.simpleMessage("عنوان آخر!"),
    "saveAnotherAddress": MessageLookupByLibrary.simpleMessage("أضغط هنا لحفظ العنوان للوصول اليه سريعا في المرة القادمة"),
    "enterTheNameOfTheBookmark": MessageLookupByLibrary.simpleMessage("أدخل اسم العلامة المرجعية"),
    "pleaseWaitForSaveLocation": MessageLookupByLibrary.simpleMessage("جار حفظ الموقع.."),
    "successSaveLocation": MessageLookupByLibrary.simpleMessage("تمت عملية الحفظ بنجاح"),
    "errorSaveLocation": MessageLookupByLibrary.simpleMessage("حدث خطأ حاول مجددا!"),
    "hintTextBookMarkField": MessageLookupByLibrary.simpleMessage("المنزل , ورشة العمل ,الخ..."),
    "nameBookMark": MessageLookupByLibrary.simpleMessage("أدخل اسم العلامة المرجعية"),
    "afterSaveLocation": MessageLookupByLibrary.simpleMessage("تم حفظ الموقع , نقر فوق تغيير للاستخدام السريع "),
    "errorLoadLocation": MessageLookupByLibrary.simpleMessage("حدث خطأ في تحميل العناصر"),
    "to": MessageLookupByLibrary.simpleMessage("الى"),
    "remove": MessageLookupByLibrary.simpleMessage("حذف"),
    "removed": MessageLookupByLibrary.simpleMessage("تم الحذف"),
    "signedOutSuccessfully": MessageLookupByLibrary.simpleMessage("تم تسجيل الخروج بنجاح"),
    "nextTimeBookMark": MessageLookupByLibrary.simpleMessage("أضف علامات مرجعية للمرة القادمة"),
    "cart": MessageLookupByLibrary.simpleMessage("السلة"),
    "plot": MessageLookupByLibrary.simpleMessage("حبة"),
    "note": MessageLookupByLibrary.simpleMessage("ملاحظة"),
    "noteMessage": MessageLookupByLibrary.simpleMessage("ستظهر هذه الملاحظة عند مقدم خدمة التوصيل"),
    "validPhone": MessageLookupByLibrary.simpleMessage("ادخل رقم هاتف صحيح"),
    "shortPassword": MessageLookupByLibrary.simpleMessage("كلمة المرمر قصرة , على الأقل 5 محارف"),
    "confirmPasswordRequired": MessageLookupByLibrary.simpleMessage("تأكيد كلمة المرمر مطلوب"),
    "numberOfItemsRequired": MessageLookupByLibrary.simpleMessage("حدد عدد العناصر المطلوب"),










  };
}
