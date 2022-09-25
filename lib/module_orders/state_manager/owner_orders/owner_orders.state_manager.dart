
import 'package:rxdart/rxdart.dart';

class OwnerOrdersStateManager {
  // final OrdersService _ordersService;
  // final AuthService _authService;
  // final ProfileService _profileService;
  // final PlanService _planService;

  // final PublishSubject<OwnerOrdersListState> _stateSubject = PublishSubject();
  // final PublishSubject<ProfileResponseModel> _profileSubject = PublishSubject();

  // Stream<OwnerOrdersListState> get stateStream => _stateSubject.stream;

  // Stream<ProfileResponseModel> get profileStream => _profileSubject.stream;

  // OwnerOrdersStateManager(
  //   this._ordersService,
  //   this._authService,
  //   this._profileService,
  //   this._planService,
  // );

  // void getProfile() {
  //   _profileService
  //       .getProfile()
  //       .then((profile) => _profileSubject.add(profile));
  // }

  // void getMyOrders(OwnerOrdersScreenState screenState) {
  //   _authService.isLoggedIn.then((value) {
  //     if (value) {
  //       _stateSubject.add(OrdersListStateLoading(screenState));
  //       _ordersService.getMyOrders().then((value) {
  //         if (value == null) {
  //           _stateSubject
  //               .add(OrdersListStateError('Error Finding Data', screenState));
  //         } else {
  //           isNewOrderAvailable(value, screenState);
  //         }
  //       });
  //     } else {
  //       _stateSubject.add(OrdersListStateUnauthorized(screenState));
  //     }
  //   });
  // }

  // void isNewOrderAvailable(
  //     List<OrderModel> orders, OwnerOrdersScreenState screenState) {
  //   _planService.getOwnerCurrentPlan().then((value) {
  //     _stateSubject.add(OrdersListStateOrdersLoaded(
  //         orders, value.cars > orders.length, screenState));
  //   });
  // }
}
