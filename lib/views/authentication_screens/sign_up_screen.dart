import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_app/controllers/authentication_controller/sign_up_controller.dart';
import 'package:property_app/route_management/constant_routes.dart';
import 'package:property_app/utils/utils.dart';
import '../../app_constants/animations.dart';
import '../../app_constants/app_icon.dart';
import '../../app_constants/app_sizes.dart';
import '../../app_constants/color_constants.dart';
import '../../constant_widget/constant_widgets.dart';
import '../../custom_widgets/custom_button.dart';
import '../../custom_widgets/custom_text_field.dart';

class SignUpScreen extends GetView<SignUpController> {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("hello");
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: backAppBar(),
      body: SafeArea(
        child: Obx(()=>
           Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: SingleChildScrollView(
              physics: bouncingScrollPhysic,
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headingText (
                      text: "New User? Register here",
                      fontSize: 24
                    ),
                    h15,
                  GestureDetector(
                    onTap: () {
                      controller.pickProfileImage();
                    },
                    child: Center(
                        child: CircleAvatar(
                          radius: 62,
                          backgroundColor: Colors.grey,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            backgroundImage: controller.profileImage.value == null ? const AssetImage(AppIcons.personIcon) : FileImage(File(controller.profileImage.value!.path)) as ImageProvider,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle
                                ),
                                child: const Center(child: Icon(Icons.add, color: Colors.white,)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    h40,
                    CustomTextField(
                      controller: controller.nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Full name is required';
                        }
                        return null;
                      },
                      hintText: "Full Name",),
                    h15,
                    CustomTextField(
                      controller: controller.emailController,
                      validator: (value) => GetUtils.isEmail(value)
                          ? null
                          : 'Email is incorrect',
                      hintText: "Email",),
                    h15,
                    CustomTextField(
                      controller: controller.phoneController,
                      keyboaredtype: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length < 11) {
                          return 'Please enter valid phone number';
                        }
                        return null;
                      },
                      hintText: "Phone Number",),
                    h15,
                    CustomTextField(
                      controller: controller.passwordController,
                      isObscureText: controller.passwordObscure.value,
                      suffixIcon: IconButton(onPressed: (){
                        controller.passwordObscure.value = !controller.passwordObscure.value;
                      }, icon:  Icon(controller.passwordObscure.value ? Icons.visibility : Icons.visibility_off)),
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length < 8) {
                          return 'Invalid password. Must be at least 8 characters,\ncontain 1 uppercase letter, and 1 number.';
                        }
                        return null;
                      },
                      hintText: "Password",
                    ),
                    h15,
                    CustomTextField(
                      controller: controller.confirmPasswordController,
                      isObscureText: controller.cPasswordObscure.value,
                      suffixIcon: IconButton(onPressed: (){
                        controller.cPasswordObscure.value = !controller.cPasswordObscure.value;
                      }, icon:  Icon(controller.cPasswordObscure.value ? Icons.visibility : Icons.visibility_off)),
                      validator: (value) {
                        if (value == null || value.isEmpty  || value != controller.passwordController.text) {
                          return 'Confirm Password does not match';
                        }
                        return null;
                      },
                      hintText: "Confirm Password",
                    ),
                    h15,
                    CustomDropDown(
                        value: controller.userRoleValue.value,
                        validator: (value) {
                        if (value == null || value == "Select Role") {
                          return 'Please Select Role';
                        }
                         return null;
                        },
                        onChange: (value){
                          controller.userRoleValue.value  = value;
                        },items: ['Select Role' ,'Landlord', 'Tenant', 'Service Provider','Visitor', ]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        onTap: (){},
                        value: value,
                        child: customText(
                          text: value,
                          fontSize: 16,
                          color: hintColor
                        ),
                      );
                    }).toList(),),
                    h15,
                    controller.userRoleValue.value == "Landlord" ?
                     landLard(context) : const SizedBox(),

                    controller.userRoleValue.value == "Tenant" ?
                     tenant(context) : const SizedBox(),

                    controller.userRoleValue.value == "Service Provider" ?
                    servicesProvider(context) : const SizedBox(),

                    controller.userRoleValue.value == "Visitor" ?
                    Column(
                      children: [
                        h30,
                        CustomButton(
                          width: double.infinity,
                          text: "Register",
                          isLoading: controller.isLoading.value,
                          onTap: controller.isLoading.value ? null : (){
                            if(controller.formKey.currentState!.validate()){
                                if(controller.profileImage.value == null){
                                  controller.registerVisitor(context,
                                      controller.nameController.text,
                                      controller.emailController.text,
                                      controller.phoneController.text,
                                      controller.passwordController.text,
                                      controller.confirmPasswordController.text);
                                }else{
                                  print("uploaded with image");
                                  controller.registerVisitor(context,
                                      controller.nameController.text,
                                      controller.emailController.text,
                                      controller.phoneController.text,
                                      controller.passwordController.text,
                                      controller.confirmPasswordController.text, profileImage: controller.profileImage.value);
                                }
                            }

                            // if(controller.nameField.value ||
                            //    controller.emailField.value ||
                            //    controller.passwordField.value ){

                            // }else{
                            //
                            //
                            // }

                          },
                        ),
                        h50,
                      ],
                    ) : const SizedBox(),

                    controller.userRoleValue.value == "Select Role" ?
                    Column(
                      children: [
                        h30,
                        CustomButton(
                          width: double.infinity,
                          text: "Register",
                          onTap: (){
                            if(controller.formKey.currentState!.validate()){

                            }
                          },
                        ),
                        h50,
                      ],
                    ) : const SizedBox(),




                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget landLard(context){
    return Column(
      children: [
        CustomDropDown(
          validator: (value){
          if (value == null || value == "No of Properties") {
              return 'No of Properties';
          }
              return null;
          },
          value: controller.noOfPropertiesValue.value,
          onChange: (value){
            controller.noOfPropertiesValue.value  = value;
          },items: ['No of Properties', "1", "2", "3" ,"4", "5" , "6" ,"7" ,"8" ,"9" , "10" , "11", "12" , "13" , "14" , "15"]
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            onTap: (){

            },
            value: value,
            child: customText(
              text: value,
                fontSize: 16,
                color: hintColor
            ),
          );
        }).toList(),),
        h15,
        // CustomDropDown(
        //   value: controller.propertiesTypeValue.value,
        //   validator: (value){
        //     if (value == null || value == "Choose Property Type") {
        //       return 'Choose property type';
        //     }
        //     return null;
        //   },
        //   onChange: (value){
        //     controller.propertiesTypeValue.value  = value;
        //   },items: ['Choose Property Type', "1",]
        //     .map<DropdownMenuItem<String>>((String value) {
        //   return DropdownMenuItem<String>(
        //     onTap: (){
        //
        //     },
        //     value: value,
        //     child: customText(
        //       text: value,
        //         fontSize: 16,
        //         color: hintColor
        //     ),
        //   );
        // }).toList(),),
        CustomDropDown(
          value: controller.propertiesTypeValue.value,
          validator: (value){
            if (value == null || value == "Choose Property Type") {
              return 'Choose property type';
            }
            return null;
          },
          onChange: (value){
            int index = controller.items.indexOf(value) - 0;

            controller.propertiesTypeValue.value  = value;
            controller.propertyTypeIndex.value = index;
            print(controller.propertyTypeIndex.value);
          },items: controller.items
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            onTap: (){

            },
            value: value,
            child: customText(
                text: value,
                fontSize: 16,
                color: hintColor
            ),
          );
        }).toList(),),
        h15,
        CustomTextField(
          readOnly: true,
          hintText: 'Weekdays, ${controller.startTime.value.format(context)} - ${controller.endTime.value.format(context)}',
          suffixIcon: IconButton(onPressed: (){
            controller.selectDateTime(context);
          }, icon: const Icon(Icons.calendar_month)),
        ),
        h30,
        CustomButton(
          width: double.infinity,
          text: "Next",
          onTap: (){
           if(controller.formKey.currentState!.validate()){
              Get.toNamed(kAddDetailScreen);
           }
          },
        ),
      ],
    );
  }
  Widget tenant(context){
    return  Column(
      children: [
        CustomDropDown(
          value: controller.onRentValue.value,
          validator: (value){
            if (value == null || value == "Select last status") {
              return 'Select last status';
            }
            return null;
          },
          onChange: (value){
            controller.onRentValue.value  = value;
          },items: ['Select last status','own house', 'on rent' ]
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            onTap: (){

            },
            value: value,
            child: customText(
              text: value,
                fontSize: 16,
                color: hintColor
            ),
          );
        }).toList(),),
        h15,
        controller.onRentValue.value == "on rent" ?  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              validator: (value){
                if (value == null || value.isEmpty) {
                  return 'Last tenancy required';
                }
                return null;
              },
              controller: controller.lastTenancyController,
              errorText: controller.lastTenancyField.value ? null : "Last tenancy required",
              hintText: "Duration of Last Tenancy",),
            h15,
            CustomTextField(
              validator: (value){
                if (value == null || value.isEmpty) {
                  return 'Last landlord required';
                }
                return null;
              },
              controller: controller.lastLandLordController,
              errorText: controller.lastLandLordField.value ? null : "Last landlord required",
              hintText: "Name of Last Landlord",),
            h15,
            CustomTextField(
              validator: (value){
                if (value == null || value.isEmpty) {
                  return 'Last landlord number required';
                }
                return null;
              },
              controller: controller.lastLandLordContactController,
              errorText: controller.lastLandLordContactField.value ? null : "Last landlord number required",
              hintText: "Contact Number of Last Landlord",),
            h15,
          ],
        ) : const SizedBox(),
        CustomTextField(
          validator: (value){
            if (value == null || value.isEmpty) {
              return 'Occupation required';
            }
            return null;
          },
          controller: controller.occupationController,
          errorText: controller.occupationField.value ? null : "Occupation required",
          hintText: "Occupation",
        ),
        h15,
        CustomTextField(
          validator: (value){
            if (value == null || value.isEmpty) {
              return 'Leased Duration required';
            }
            return null;
          },
          controller: controller.leasedDurationController,
          errorText: controller.leasedDurationField.value ? null : "Leased Duration required",
          hintText: "Leased Duration",),
        h15,
        CustomTextField(
          validator: (value){
            if (value == null || value.isEmpty) {
              return 'No of occupant required';
            }
            return null;
          },
          keyboaredtype: TextInputType.number,
          controller: controller.noOfOccupants,
          errorText: controller.leasedDurationField.value ? null : "No of occupant required",
          hintText: "No of occupants",),
        h50,
        CustomButton(
          width: double.infinity,
          text: "Register",
          isLoading: controller.isLoading.value,
          onTap:  controller.isLoading.value ? null : ()async{
            if(controller.formKey.currentState!.validate()){
              int occupant = int.parse(controller.noOfOccupants.text);
              if(controller.profileImage.value == null){
                if( controller.onRentValue.value == "Select last status" || controller.onRentValue.value == "own house" ){
                  print("own house");
                  await controller.registerTenant(
                    fullName: controller.nameController.text,
                    email: controller.emailController.text,
                    phoneNumber: controller.phoneController.text,
                    password: controller.passwordController.text,
                    cPassword: controller.confirmPasswordController.text,
                    roleId: 2,
                    lastStatus: 1, // or 2 based on your scenario
                    occupation: controller.occupationController.text, // provide value based on your scenario
                    leasedDuration: controller.leasedDurationController.text, // provide value based on your scenario
                    noOfOccupants: occupant, // provide value based on your scenario
                  );
                }
                else {
                  print("own rent");
                  await controller.registerTenant(
                    fullName: controller.nameController.text,
                    phoneNumber: controller.phoneController.text,
                    email: controller.emailController.text,
                    password: controller.passwordController.text,
                    cPassword: controller.confirmPasswordController.text,
                    roleId: 2,
                    lastStatus: 2,
                    lastLandlordName: controller.lastLandLordController.text, // provide value based on your scenario
                    lastTenancy: controller.lastTenancyController.text, // provide value based on your scenario
                    lastLandlordContact: controller.lastLandLordContactController.text, // provide value based on your scenario
                    occupation: controller.occupationController.text, // provide value based on your scenario
                    leasedDuration: controller.leasedDurationController.text, // provide value based on your scenario
                    noOfOccupants: occupant, // provide value based on your scenario
                  );
                }
              }else{
                print("tenenat profile image");
                if( controller.onRentValue.value == "Select last status" || controller.onRentValue.value == "own house" ){
                  print("own house");
                  await controller.registerTenant(
                    fullName: controller.nameController.text,
                    email: controller.emailController.text,
                    phoneNumber: controller.phoneController.text,
                    password: controller.passwordController.text,
                    cPassword: controller.confirmPasswordController.text,
                    roleId: 2,
                    profileImage: controller.profileImage.value!,
                    lastStatus: 2, // or 2 based on your scenario
                    occupation: controller.occupationController.text, // provide value based on your scenario
                    leasedDuration: controller.leasedDurationController.text, // provide value based on your scenario
                    noOfOccupants: occupant, // provide value based on your scenario
                  );
                }else {
                  print("own rent");
                  await controller.registerTenant(
                    fullName: controller.nameController.text,
                    phoneNumber: controller.phoneController.text,
                    email: controller.emailController.text,
                    password: controller.passwordController.text,
                    cPassword: controller.confirmPasswordController.text,
                    roleId: 2,
                    profileImage: controller.profileImage.value!,
                    lastStatus: 1,
                    lastLandlordName: controller.lastLandLordController.text, // provide value based on your scenario
                    lastTenancy: controller.lastTenancyController.text, // provide value based on your scenario
                    lastLandlordContact: controller.lastLandLordContactController.text, // provide value based on your scenario
                    occupation: controller.occupationController.text, // provide value based on your scenario
                    leasedDuration: controller.leasedDurationController.text, // provide value based on your scenario
                    noOfOccupants: occupant, // provide value based on your scenario
                  );
                }
              }

            }

            //Get.toNamed(kTenantDashboard);
          },
        ),
        h30,
      ],
    ) ;
  }
  Widget servicesProvider(context){
    return Column(
      children: [
        CustomDropDown(
          value: controller.electricalValue.value,
          validator: (value) {
            if (value == null || value == "Choose service") {
              return 'Please Choose service';
            }
            return null;
          },
          onChange: (value){
            controller.electricalValue.value  = value;
          },items: ['Choose service', 'Electrician','Plumber','Tailor', "Cleaner" ]
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            onTap: (){

            },
            value: value,
            child: customText(
              text: value,
                fontSize: 16,
                color: hintColor
            ),
          );
        }).toList(),),
        controller.electricalValue.value == "Choose service" ?  const SizedBox() : h15,
        controller.electricalValue.value == "Choose service" ? const SizedBox() :
        CustomTextField(
          controller: controller.experienceController,
          keyboaredtype: TextInputType.number,

          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter experience';
            }
            return null;
          },
          errorText: controller.experienceField.value ? null : "Experience Required",
          hintText: "Years of Experience",),
        controller.electricalValue.value == "Choose service" ?  const SizedBox() : h15,
        controller.electricalValue.value == "Choose service" ?  const SizedBox() :
        CustomTextField(
          readOnly: true,
          onTap: () {
            controller.selectDateTime(context);
          },
          hintText: 'Weekdays, ${controller.startTime.value.format(context)} - ${controller.endTime.value.format(context)}',
          suffixIcon: IconButton(onPressed: (){
            controller.selectDateTime(context);
          }, icon: const Icon(Icons.calendar_month)),
        ),


        h15,
        CustomDropDown(
          value: controller.yesValue.value,
          onChange: (value){
            controller.yesValue.value  = value;
          },items: [ 'Any Certificate ?' ,'Yes', 'No'  ]
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            onTap: (){

            },
            value: value,
            child: customText(
              text: value,
                fontSize: 16,
                color: hintColor
            ),
          );
        }).toList(),),
        h15,
        controller.yesValue.value == "Any Certificate ?" || controller.yesValue.value == "No"? const SizedBox() :
        Align(
          alignment: Alignment.bottomLeft,
          child: customText(
            text: "Any Certificate ? (optional)",
            fontSize: 12,
            color: blackColor,
          ),
        ),
        controller.yesValue.value == "Any Certificate ?" || controller.yesValue.value == "No" ?
        const SizedBox() :  h15,
        controller.yesValue.value == "Any Certificate ?" || controller.yesValue.value == "No"
        ? const SizedBox() :
        controller.certificateImage.value == null ? uploadImageContainer(
          onTap: (){
            controller.pickCertificate();
          },
          text: "Upload File"
        ) : Container(
          width: double.infinity,
          height: 130,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: FileImage(File(controller.certificateImage.value!.path),),
              fit: BoxFit.fill
            )
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: (){
                      controller.certificateImage.value = null;
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: const Icon(Icons.delete),
                    ),
                  ),
                  w5,
                  InkWell(
                    onTap: (){
                      controller.pickCertificate();
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: const Icon(Icons.edit),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ) ,
        h15,
        Align(
          alignment: Alignment.bottomLeft,
          child: customText(
            text: "Select CNIC Front Image",
            fontSize: 12,
            color: blackColor,
          ),
        ),
        h15,
        controller.frontCNICImage.value == null ? uploadImageContainer(
            onTap: (){
              controller.frontCNIC();
            },
            text: "CNIC Front"
        ) : Container(
          width: double.infinity,
          height: 130,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: FileImage(File(controller.frontCNICImage.value!.path),),
                  fit: BoxFit.fill
              )
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: (){
                      controller.frontCNICImage.value = null;
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: const Icon(Icons.delete),
                    ),
                  ),
                  w5,
                  InkWell(
                    onTap: (){
                      controller.pickCertificate();
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: const Icon(Icons.edit),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ) ,
        h15,
        Align(
          alignment: Alignment.bottomLeft,
          child: customText(
            text: "Select CNIC Back Image",
            fontSize: 12,
            color: blackColor,
          ),
        ),
        h15,
        controller.backCNICImage.value == null ? uploadImageContainer(
            onTap: (){
              controller.backCNIC();
            },
            text: "CNIC Back"
        ) : Container(
          width: double.infinity,
          height: 130,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: FileImage(File(controller.backCNICImage.value!.path),),
                  fit: BoxFit.fill
              )
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: (){
                      controller.backCNICImage.value = null;
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: const Icon(Icons.delete),
                    ),
                  ),
                  w5,
                  InkWell(
                    onTap: (){
                      controller.pickCertificate();
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: const Icon(Icons.edit),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ) ,
        h50,
        CustomButton(
          width: double.infinity,
          text: "Register",
          isLoading: controller.isLoading.value,
          onTap:  controller.isLoading.value ? null : ()async{
           if(controller.formKey.currentState!.validate()) {
             if (controller.frontCNICImage.value == null){
                AppUtils.errorSnackBar("Please Select", "Please Select CNIC Front Image");
              }else if (controller.backCNICImage.value == null){
                AppUtils.errorSnackBar("Please Select", "Please Select CNIC Back Image");
              }else{
                int experience = int.parse(controller.experienceController.text);
                if(controller.profileImage.value == null){
                  if (controller.yesValue.value == "Any Certificate ?" || controller.yesValue.value == "No") {
                    // User has provided certification
                    try {
                      await controller.registerServiceProvider(
                        fullName: controller.nameController.text,
                        email: controller.emailController.text,
                        phoneNumber: controller.phoneController.text,
                        password: controller.passwordController.text,
                        cPassword: controller.confirmPasswordController.text,
                        services: controller.electricalValue.value,
                        yearExperience: controller.experienceController.text,
                        availabilityStartTime: controller.startTime.value.format(context),
                        availabilityEndTime: controller.endTime.value.format(context),
                        cnicFront: controller.frontCNICImage.value!,
                        cnicBack: controller.backCNICImage.value!,
                      );
                      // Registration successful, navigate or perform other actions
                    } catch (e) {
                      // Handle registration failure, show error message or take appropriate action
                      print('Registration failed: $e');
                    }
                  } else {
                    // User has not provided certification
                    try {
                      await controller.registerServiceProvider(
                        fullName: controller.nameController.text,
                        email: controller.emailController.text,
                        phoneNumber: controller.phoneController.text,
                        password: controller.passwordController.text,
                        cPassword: controller.confirmPasswordController.text,
                        services: controller.electricalValue.value,
                        yearExperience: controller.experienceController.text,
                        availabilityStartTime: controller.startTime.value.format(context),
                        availabilityEndTime: controller.endTime.value.format(context),
                        cnicFront: controller.frontCNICImage.value!,
                        cnicBack: controller.backCNICImage.value!,
                        certification: controller.yesValue.value,
                        certificationFile: controller.certificateImage.value!,
                        // No certification information provided
                      );

                      // Registration successful, navigate or perform other actions
                    } catch (e) {
                      // Handle registration failure, show error message or take appropriate action
                      print('Registration failed: $e');
                    }
                  }

                }else{

                  if (controller.yesValue.value == "Any Certificate ?" || controller.yesValue.value == "No") {
                    // User has provided certification
                    try {
                      await controller.registerServiceProvider(

                        fullName: controller.nameController.text,
                        email: controller.emailController.text,
                        phoneNumber: controller.phoneController.text,
                        password: controller.passwordController.text,
                        cPassword: controller.confirmPasswordController.text,
                        profileImage: controller.profileImage.value!,
                        services: controller.electricalValue.value,
                        yearExperience: experience.toString(),
                        availabilityStartTime: controller.startTime.value.format(context),
                        availabilityEndTime: controller.endTime.value.format(context),
                        cnicFront: controller.frontCNICImage.value!,
                        cnicBack: controller.backCNICImage.value!,
                      );

                      // Registration successful, navigate or perform other actions
                    } catch (e) {
                      // Handle registration failure, show error message or take appropriate action
                      print('Registration failed: $e');
                    }
                  } else {
                    // User has not provided certification
                    try {
                      await controller.registerServiceProvider(
                        fullName: controller.nameController.text,
                        email: controller.emailController.text,
                        phoneNumber: controller.phoneController.text,
                        password: controller.passwordController.text,
                        cPassword: controller.confirmPasswordController.text,

                        profileImage: controller.profileImage.value!,
                        services: controller.electricalValue.value,
                        yearExperience: controller.experienceController.text,
                        availabilityStartTime: controller.startTime.value.format(context),
                        availabilityEndTime: controller.endTime.value.format(context),
                        cnicFront: controller.frontCNICImage.value!,
                        cnicBack: controller.backCNICImage.value!,
                        certification: controller.yesValue.value,
                        certificationFile: controller.certificateImage.value!,
                        // No certification information provided
                      );

                      // Registration successful, navigate or perform other actions
                    } catch (e) {
                      // Handle registration failure, show error message or take appropriate action
                      print('Registration failed: $e');
                    }
                  }

                }
              }
           }
          },
        ),
        h50,
      ],
    );
  }
}
