import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:stoxplay/core/network/api_response.dart';
import 'package:stoxplay/features/profile_page/presentation/cubit/profile_cubit.dart';
import 'package:stoxplay/utils/common/functions/snackbar.dart';
import 'package:stoxplay/utils/common/widgets/app_button.dart';
import 'package:stoxplay/utils/common/widgets/cached_image_widget.dart';
import 'package:stoxplay/utils/common/widgets/common_back_button.dart';
import 'package:stoxplay/utils/common/widgets/common_textfield.dart';
import 'package:stoxplay/utils/common/widgets/text_view.dart';
import 'package:stoxplay/utils/constants/app_assets.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  ValueNotifier<XFile?> profileImage = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    // Initialize controllers when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<ProfileCubit>();
      cubit.initializeControllers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) {
        // Only react when profileModel reference changes from null -> non-null or to a new instance
        final changedModel = previous.profileModel != current.profileModel;
        return changedModel && current.profileModel != null;
      },
      listener: (context, state) {
        // Initialize controllers only when profile data becomes newly available
        final cubit = context.read<ProfileCubit>();
        cubit.initializeControllers();
      },
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final cubit = context.read<ProfileCubit>();
          return Scaffold(
            backgroundColor: AppColors.white,
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    child: Row(
                      children: [
                        CommonBackButton(onTap: () => Navigator.of(context).pop()),
                        Expanded(
                          child: Center(
                            child: TextView(
                              text: 'Personal Info',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.5,
                              lineHeight: 1,
                            ),
                          ),
                        ),
                        SizedBox(width: 36.w),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ValueListenableBuilder(
                    valueListenable: profileImage,
                    builder: (context, image, _) {
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    (state.profileModel?.profilePictureUrl != null &&
                                                state.profileModel!.profilePictureUrl!.isNotEmpty) ||
                                            (state.profileUrl.isNotEmpty)
                                        ? AppColors.primaryPurple
                                        : AppColors.blackD7D7,
                              ),
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(5.w),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.primaryPurple),
                                shape: BoxShape.circle,
                              ),
                              child: buildProfileAvatar(
                                profilePictureUrl:
                                    state.profileUrl.isNotEmpty
                                        ? state.profileUrl
                                        : state.profileModel?.profilePictureUrl,
                                pickedImage: profileImage.value,
                              ),
                            ),
                          ),
                          Gap(10.h),
                          AppButton(
                            text: 'Change Image',
                            onPressed: () async {
                              try {
                                final imagePicker = ImagePicker();
                                final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
                                if (pickedFile != null) {
                                  profileImage.value = pickedFile;
                                  try {
                                    await cubit.uploadProfilePicture(pickedFile.path);
                                  } catch (e) {
                                    showSnackBar(
                                      context: context,
                                      message: 'Failed to upload image. Please try again.',
                                    );
                                  }
                                }
                              } catch (e) {
                                showSnackBar(context: context, message: 'Unable to access gallery. Check permissions.');
                              }
                            },
                            height: 32.h,
                            width: 110.w,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            borderRadius: 8.r,
                            backgroundColor: AppColors.primaryPurple,
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 15.h),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      children: [
                        SizedBox(height: 20.h),
                        _buildTextField(cubit.firstNameController, title: "Full Name"),
                        SizedBox(height: 16.h),
                        _buildTextField(cubit.usernameController, title: "UserName"),
                        SizedBox(height: 16.h),
                        _buildTextField(cubit.emailController, title: "Email"),
                        SizedBox(height: 16.h),
                        TextView(text: 'Gender', fontColor: AppColors.black),
                        SizedBox(height: 5.h),
                        _buildDropdownField(state.gender ?? "SELECT", (val) {
                          cubit.updateGender(val);
                        }),

                        SizedBox(height: 16.h),
                        TextView(text: 'Date of birth', fontColor: AppColors.black),
                        SizedBox(height: 5.h),
                        _buildDateField(
                          state.dob == null ? 'Select Date' : DateFormat('dd/MM/yyyy').format(state.dob!),
                          context,
                          () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: state.dob ?? DateTime.now().subtract(Duration(days: 6570)),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now().subtract(Duration(days: 6570)),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: Colors.deepPurple,
                                      onPrimary: Colors.white,
                                      onSurface: Colors.black,
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(foregroundColor: Colors.deepPurple),
                                    ),
                                    dialogTheme: DialogThemeData(backgroundColor: Colors.white),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (date != null) {
                              cubit.updateDOB(date);
                            }
                          },
                        ),
                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 10.h, 24.w, 20.h),
                    child: AppButton(
                      isLoading: state.apiStatus.isLoading,
                      text: 'Update profile',
                      onPressed: () async {
                        final fullName = cubit.firstNameController.text.trim();
                        final userName = cubit.usernameController.text.trim();
                        final email = cubit.emailController.text.trim();

                        if (fullName.isEmpty ||
                            userName.isEmpty ||
                            email.isEmpty ||
                            (state.gender == 'SELECT') ||
                            state.dob == null) {
                          showSnackBar(context: context, message: 'Please fill all the fields before submitting.');
                          return;
                        }

                        final emailRegex = RegExp(r'^\S+@\S+\.\S+$');
                        if (!emailRegex.hasMatch(email)) {
                          showSnackBar(context: context, message: 'Please enter a valid email address.');
                          return;
                        }

                        if (userName.length < 3) {
                          showSnackBar(context: context, message: 'Username must be at least 3 characters.');
                          return;
                        }

                        try {
                          await cubit.updateProfile();
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          showSnackBar(context: context, message: 'Failed to update profile. Please try again.');
                        }
                      },

                      height: 45.h,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      backgroundColor: AppColors.primaryPurple,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, {required String title}) {
    return CommonTextfield(controller: controller, title: title, hintText: title);
  }

  Widget _buildDropdownField(String value, ValueChanged<String> onChanged) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.blackD3D3, width: 1),
        color: AppColors.white,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: DropdownButtonFormField<String>(
        value: value,
        items: ['SELECT', 'MALE', 'FEMALE', 'OTHER'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
        decoration: InputDecoration(border: InputBorder.none),
        icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primaryPurple),
      ),
    );
  }

  Widget buildProfileAvatar({required String? profilePictureUrl, required XFile? pickedImage, double radius = 45}) {
    // Prioritize newly picked local image so user immediately sees selection
    if (pickedImage != null) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.white,
        backgroundImage: FileImage(File(pickedImage.path)),
      );
    }

    // If SVG from network
    if (profilePictureUrl != null && profilePictureUrl.toLowerCase().endsWith('.svg')) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.white,
        child: ClipOval(
          child: SVGImageWidget(imageUrl: profilePictureUrl, errorWidget: Image.asset(AppAssets.profileIcon)),
        ),
      );
    }

    // If profilePictureUrl is a non-SVG image
    if (profilePictureUrl != null && profilePictureUrl.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.white,
        backgroundImage: NetworkImage(profilePictureUrl),
      );
    }

    // Default to asset
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.white,
      backgroundImage: AssetImage(AppAssets.profileIcon),
    );
  }

  Widget _buildDateField(String hint, BuildContext context, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.blackD3D3, width: 1),
          color: AppColors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                child: Text(hint, style: TextStyle(color: Colors.black, fontSize: 15.sp, fontWeight: FontWeight.w500)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: Icon(Icons.calendar_today_rounded, color: AppColors.primaryPurple, size: 22.w),
            ),
          ],
        ),
      ),
    );
  }
}
