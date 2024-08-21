import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_task_manager/data/models/network_response.dart';
import 'package:getx_task_manager/data/services/network_caller.dart';
import 'package:getx_task_manager/data/utills/urls.dart';
import 'package:getx_task_manager/ui/screens/auth/set_password_screen.dart';

class OtpVerificationController extends GetxController {
  final TextEditingController otpTEController = TextEditingController();
  final RxBool isOtpVerified = false.obs;

  Future<void> otpVerification(String email) async {
    isOtpVerified.value = true;

    final NetworkResponse response = await NetworkCaller()
        .getRequest(Urls.recoverVerifyOTP(email, otpTEController.text));

    isOtpVerified.value = false;

    if (response.isSuccessfull) {
      Get.to(() => SetPasswordScreen(email: email, otp: otpTEController.text));
    }
  }
}