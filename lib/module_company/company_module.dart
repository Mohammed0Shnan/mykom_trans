import 'package:my_kom/abstracts/module/my_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_kom/module_company/company_routes.dart';
import 'package:my_kom/module_company/screen/company_products_screen.dart';
import 'package:my_kom/module_company/screen/products_detail_screen.dart';

class CompanyModule extends MyModule {
   final CompanyProductScreen _companyProductScreen  ;
   final PriductDetailScreen _productDetailScreen;
   CompanyModule(this._companyProductScreen,this._productDetailScreen);

  @override
  Map<String, WidgetBuilder> getRoutes() {
    return {
       CompanyRoutes.COMPANY_PRODUCTS_SCREEN : (context) => _companyProductScreen,
      CompanyRoutes.PRODUCTS_DETAIL_SCREEN : (context) => _productDetailScreen,
    };
  }
}
