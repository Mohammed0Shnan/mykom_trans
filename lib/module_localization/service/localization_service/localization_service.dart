
// import 'package:products_app/module_localization/presistance/localization_preferences_helper.dart';
// import 'package:rxdart/rxdart.dart';

// class LocalizationService {
//   static final PublishSubject<String> _localizationSubject =
//       PublishSubject<String>();
//   Stream<String> get localizationStream => _localizationSubject.stream;
//   final LocalizationPreferencesHelper _preferencesHelper =LocalizationPreferencesHelper();


//   Future<void> setLanguage(String lang) async {
//     await _preferencesHelper.setLanguage(lang);
//     _localizationSubject.add(lang);
//   }

//   Future<String> getLanguage() async {
//     String lang = await _preferencesHelper.getLanguage();
//     lang ??= 'en';
//     return lang;
//   }

//   void dispose() {
//     _localizationSubject.close();
//   }
// }
