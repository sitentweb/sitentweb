import 'package:flutter/material.dart';
import 'package:remark_app/model/company/fetch_company_model.dart';

class SelectCompanyNotifier extends ChangeNotifier {
  String _companyID = "";
  bool _companyStatus = false;
  bool _companySelected = false;
  Data _companyData = Data();

  String get companyID => _companyID;
  bool get companyStatus => _companyStatus;
  bool get companySelected => _companySelected;
  Data get companyData => _companyData;

  void select(String id, bool status, bool selected, Data data) {
    _companyID = id;
    _companyStatus = status;
    _companySelected = selected;
    _companyData = data;

    notifyListeners();
  }

  void unselect() {
    _companyID = "0";
    _companyStatus = false;
    _companySelected = false;
    _companyData = Data();
  }
}
