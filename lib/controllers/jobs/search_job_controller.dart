import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:remark_app/controllers/job_controller.dart';
import 'package:remark_app/pages/jobs/all_jobs.dart';

class SearchJobController extends GetxController {
  TextEditingController titleController = TextEditingController();
  TextEditingController skillController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  RxList<String> skillTags = <String>[].obs;
  final double minSalary = 0;
  final double maxSalary = 10000000;
  RxDouble currentSalary = 0.0.obs;
  String selectedPlace = "";
  JobController jobController = Get.put(JobController());

  setCurrentSalary(double value) {
    double newValue = value;
    if (value < minSalary) {
      newValue = minSalary;
    }

    if (value > maxSalary) {
      newValue = maxSalary;
    }

    currentSalary(newValue);
    salaryController.setText(newValue.round().toString());
    update();
  }

  setSelectedPlace(value) {
    selectedPlace = value;
    update();
  }

  collectSearchData() async {
    var title = titleController.text;
    var skills = skillTags.toList().toString();
    var salary = salaryController.text;
    var location = selectedPlace;

    List<String> data = [];

    data.add(title);
    data.add(skills.toString());

    data.add(location);

    await jobController.searchJobs(title, skills, location);

    Get.to(() => Jobs());
  }

  resetController() {
    jobController.reset();
    currentSalary(0);
    salaryController.setText("0");
    titleController.clear();
    skillController.clear();
    skillTags.clear();
    selectedPlace = "";
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    salaryController.text = currentSalary.value.toString();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    resetController();
    super.onClose();
  }
}
