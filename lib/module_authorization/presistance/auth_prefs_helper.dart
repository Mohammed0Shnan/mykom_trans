
import 'package:my_kom/module_authorization/enums/auth_source.dart';
import 'package:my_kom/module_authorization/enums/user_role.dart';
import 'package:my_kom/module_map/models/address_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPrefsHelper {
  
  Future<void> setUserId(String userId) async {
    SharedPreferences preferencesHelper = await SharedPreferences.getInstance();
    await preferencesHelper.setString('uid', userId);
    return;
  }

  Future<String?> getUserId() async {
    SharedPreferences preferencesHelper = await SharedPreferences.getInstance();
    return preferencesHelper.getString('uid');
  }

  Future<void> setStripId(String userId) async {
    SharedPreferences preferencesHelper = await SharedPreferences.getInstance();
    await preferencesHelper.setString('strip_id', userId);
    return;
  }

  Future<String?> getStripId() async {
    SharedPreferences preferencesHelper = await SharedPreferences.getInstance();
    return preferencesHelper.getString('strip_id');
  }

  Future<void> setUsername(String username) async {
    SharedPreferences preferencesHelper = await SharedPreferences.getInstance();
     preferencesHelper.setString('username', username);
  }

  Future<String?> getUsername() async {
    SharedPreferences preferencesHelper = await SharedPreferences.getInstance();
    return preferencesHelper.getString('username');
  }

  Future<void> setEmail(String email) async {
    SharedPreferences preferencesHelper = await SharedPreferences.getInstance();
     preferencesHelper.setString('email', email);
  }

  Future<String?> getEmail() async {
    SharedPreferences preferencesHelper = await SharedPreferences.getInstance();
    return preferencesHelper.getString('email');
  }

  Future<void> setPassword(String password) async {
    SharedPreferences preferencesHelper = await SharedPreferences.getInstance();
     preferencesHelper.setString('password', password);
  }

  Future<String?> getPhone() async {
    SharedPreferences preferencesHelper = await SharedPreferences.getInstance();
    return preferencesHelper.getString('phone');
  }
    Future<void> setPhone(String phone) async {
    SharedPreferences preferencesHelper = await SharedPreferences.getInstance();
     preferencesHelper.setString('phone', phone);
  }

   

  Future<bool> isSignedIn() async {
    try {
      String? uid = await getToken();
      return uid != null;
    } catch (e) {
      return false;
    }
  }

  Future<AuthSource> getAuthSource() async {
    SharedPreferences preferencesHelper = await SharedPreferences.getInstance();
    int? index = preferencesHelper.getInt('auth_source');
    return AuthSource.values[index!];
  }

  Future<bool> setAuthSource(AuthSource authSource) async {
    SharedPreferences preferencesHelper = await SharedPreferences.getInstance();
    return preferencesHelper.setInt(
      'auth_source',
     authSource.index,
    );
  }

   Future<UserRole?> getRole() async {
    SharedPreferences preferencesHelper = await SharedPreferences.getInstance();
    int? index = preferencesHelper.getInt('user_role');
    if(index == null)
      return null;
    return UserRole.values[index];
  }

  Future<bool> setRole(UserRole userRole) async {
    SharedPreferences preferencesHelper = await SharedPreferences.getInstance();
    return preferencesHelper.setInt(
      'user_role',
     userRole.index,
    );
  }

  /// @Function saves token string
  /// @returns void
  Future<void> setToken(String token) async {
    SharedPreferences preferencesHelper = await SharedPreferences.getInstance();
    await preferencesHelper.setString(
      'token',
      token,
    );
    await preferencesHelper.setString(
      'token_date',
      DateTime.now().toIso8601String(),
    );
  }

  Future<void> deleteToken() async {
    SharedPreferences preferencesHelper = await SharedPreferences.getInstance();
    await preferencesHelper.remove('token');
    await preferencesHelper.remove('token_date');
  }

  Future<void> cleanAll() async {
    SharedPreferences preferencesHelper = await SharedPreferences.getInstance();
    await preferencesHelper.clear();
  }

  /// @return String Token String
  /// @throw Unauthorized Exception when token is null
  Future<String?> getToken() async {
    SharedPreferences preferencesHelper = await SharedPreferences.getInstance();
    var token =  preferencesHelper.getString('token');

    return token;
  }

  /// @return DateTime tokenDate
  /// @throw UnauthorizedException when token date not found
  Future<DateTime?> getTokenDate() async {
    SharedPreferences preferencesHelper = await SharedPreferences.getInstance();
    var dateStr = await preferencesHelper.getString('token_date');
    if (dateStr == null) {
    //  throw UnauthorizedException('Token date not found');
    }else
    return DateTime.parse(dateStr);
  }

  Future<void>setAdderss(AddressModel addressModel) async{
    SharedPreferences preferencesHelper = await SharedPreferences.getInstance();
    await preferencesHelper.setDouble(
      'latitude',
      addressModel.latitude,
    );
    await preferencesHelper.setDouble(
      'longitude',
      addressModel.longitude,
    );
    await preferencesHelper.setString(
      'description',
      addressModel.description,
    );
  }
  Future<AddressModel?> getAddress() async {
  SharedPreferences preferencesHelper = await SharedPreferences.getInstance();
  double? lat = await preferencesHelper.getDouble('latitude');
  double? long = await preferencesHelper.getDouble('longitude');
  String? des = await preferencesHelper.getString('description');
  if(lat==null || long == null|| des==null)
   {
     return null;

   }
  else {
    AddressModel addressModel = AddressModel(description: des, latitude: lat, longitude: long, geoData: {});
    return addressModel;
  }

  }
  // /// @return void
  // Future<void> setCurrentRole(UserRole user_type) async {
  //   SharedPreferences preferencesHelper = await SharedPreferences.getInstance();
  //   await preferencesHelper.setInt('role', user_type.index);
  // }

  // /// @return UserType
  // /// @throw UnauthorizedException when no role is set
  // Future<UserRole> getCurrentRole() async {
  //   SharedPreferences preferencesHelper = await SharedPreferences.getInstance();
  //   var type = await preferencesHelper.getInt('role');
  //   if (type == null) {
  //     throw UnauthorizedException('User Role not found');
  //   }
  //   return UserRole.values[type];
  // }
}
