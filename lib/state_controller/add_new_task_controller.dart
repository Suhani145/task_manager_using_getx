
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_task_manager/data/models/network_response.dart';
import 'package:getx_task_manager/data/services/network_caller.dart';
import 'package:getx_task_manager/data/utills/urls.dart';

class AddNewTaskController extends GetxController {
  final TextEditingController titleTEController = TextEditingController();
  final TextEditingController descriptionTEController = TextEditingController();
  var addNewTaskInProgress = false.obs;

  Future<void> addNewTask() async {
    addNewTaskInProgress.value = true;

    final requestBody = {
      "title": titleTEController.text.trim(),
      "description": descriptionTEController.text.trim(),
      "status": "New"
    };

    final NetworkResponse response =
    await NetworkCaller().postRequest(Urls.createTask, requestBody);

    addNewTaskInProgress.value = false;

    if (response.isSuccessfull) {
      titleTEController.clear();
      descriptionTEController.clear();
      Get.snackbar('Success', 'Task added successfully');
    } else {
      Get.snackbar('Error', 'Task add failed!');
    }
  }
}