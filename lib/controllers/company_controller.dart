import 'package:get/get.dart';
import 'package:remark_app/apis/company/company_api.dart';
import 'package:remark_app/model/company/fetch_company_model.dart';
import 'package:remark_app/model/company/company_list_model.dart';

class CompanyController extends GetxController {
  RxList<Datum> companies = <Datum>[].obs;
  RxBool isFetchingCompanies = true.obs;
  Rx<Data> companyData = Data().obs;
  RxBool isFetchingCompany = true.obs;

  fetchCompanies() async {
    final response = await CompanyApi().fetchCompaniesList();

    if (response.status) {
      // print(response.data.÷toList());
      companies.value = response.data;
      companies.refresh();
      // print(companies.toJson().toString());
    }

    isFetchingCompanies(false);
    isFetchingCompanies.refresh();
  }

  fetchCompanyDetails({String companyID, String userID}) async {
    isFetchingCompany(true);
    final res = await CompanyApi().fetchCompanyByID(companyID);

    if (res.status) {
      print(res.data.companyName);
      companyData(res.data);
      companyData.refresh();
      isFetchingCompany(false);
    }
  }
}
