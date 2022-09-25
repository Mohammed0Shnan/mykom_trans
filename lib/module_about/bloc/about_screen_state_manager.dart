
// import 'package:rxdart/rxdart.dart';


// class AboutScreenStateManager {
//   final LocalizationService _localizationService;
//   final AboutService _aboutService;
//   final InitAccountService _initAccountService;

//   final stateStack = <AboutState>[];
//   final _stateSubject = PublishSubject<AboutState>();

//   AboutScreen _screen;

//   Stream<AboutState> get stateStream => _stateSubject.stream;

//   AboutState initialState(AboutScreen screen) {
//     _screen = screen;
//     return AboutStatePageInit(this);
//   }

//   AboutScreenStateManager(
//     this._localizationService,
//     this._aboutService,
//     this._initAccountService,
//   );

//   void init(AboutScreen screen) => _screen;

//   void setLanguage(String lang) {
//     _localizationService.setLanguage(lang);
//   }

//   void requestBooking() {
//     _stateSubject.add(AboutStateRequestBooking(this));
//   }

//   void moveNext(UserRole role) {
//     if (role == UserRole.ROLE_OWNER) {
//       _stateSubject.add(AboutStateLoading(this));
//       _initAccountService.getPackages().then((packages) {
//         _stateSubject.add(AboutStatePageOwner(this, packages));
//       });
//     } else {
//       _stateSubject.add(AboutStatePageCaptain(this));
//     }
//   }

//   void showSnackBar(String msg) => _screen.showSnackBar(msg);

//   void createAppointment(String name, String phone) {
//     _aboutService.createAppointment(name, phone).then((value) {
//       _stateSubject.add(AboutStatePageOwnerBookingSuccess(this));
//     });
//   }

//   void refresh(AboutState state) {
//     _stateSubject.add(state);
//   }
// }
