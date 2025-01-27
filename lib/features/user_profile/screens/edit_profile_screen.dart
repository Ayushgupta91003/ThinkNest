import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:thinknest/core/common/error_text.dart';
import 'package:thinknest/core/common/loader.dart';
import 'package:thinknest/core/constants/constants.dart';
import 'package:thinknest/core/utils.dart';
import 'package:thinknest/features/auth/controlller/auth_controller.dart';
import 'package:thinknest/features/user_profile/controller/user_profile_controller.dart';
import 'package:thinknest/responsive/responsive.dart';
import 'package:thinknest/theme/pallete.dart';
import 'package:thinknest/widgets/custom_textfield.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditProfileScreen({
    super.key,
    required this.uid,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? bannerFile;
  File? profileFile;
  Uint8List? bannerWebFile;
  Uint8List? profileWebFile;

  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      if (kIsWeb) {
        setState(() {
          bannerWebFile = res.files.first.bytes;
        });
      } else {
        setState(() {
          bannerFile = File(res.files.first.path!);
        });
      }
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();

    if (res != null) {
      if (kIsWeb) {
        setState(() {
          profileWebFile = res.files.first.bytes;
        });
      } else {
        setState(() {
          profileFile = File(res.files.first.path!);
        });
      }
    }
  }

  void saveProfileChanges() {
    ref.read(userProfileControllerProvider.notifier).editProfile(
          profileFile: profileFile,
          bannerFile: bannerFile,
          context: context,
          name: nameController.text.trim(),
          bannerWebFile: bannerWebFile,
          profileWebFile: profileWebFile,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref.watch(getUserDataProvider(widget.uid)).when(
          data: (user) => Scaffold(
            backgroundColor: currentTheme.scaffoldBackgroundColor,
            appBar: AppBar(
              title: const Text(
                'Edit Profile',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.deepOrange,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: saveProfileChanges,
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            body: isLoading
                ? const Loader()
                : Responsive(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: selectBannerImage,
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(10),
                                    dashPattern: const [10, 4],
                                    strokeCap: StrokeCap.round,
                                    color: currentTheme
                                        .textTheme.bodySmall!.color!,
                                    child: Container(
                                      width: double.infinity,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: bannerWebFile != null
                                          ? Image.memory(bannerWebFile!)
                                          : bannerFile != null
                                              ? Image.file(bannerFile!)
                                              : user.banner.isEmpty ||
                                                      user.banner ==
                                                          Constants
                                                              .bannerDefault
                                                  ? const Center(
                                                      child: Icon(
                                                        Icons
                                                            .camera_alt_outlined,
                                                        size: 40,
                                                      ),
                                                    )
                                                  : Image.network(user.banner),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  left: 20,
                                  child: GestureDetector(
                                    onTap: selectProfileImage,
                                    child: profileWebFile != null
                                        ? CircleAvatar(
                                            backgroundImage:
                                                MemoryImage(profileWebFile!),
                                            radius: 32,
                                          )
                                        : profileFile != null
                                            ? CircleAvatar(
                                                backgroundImage:
                                                    FileImage(profileFile!),
                                                radius: 32,
                                              )
                                            : CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    user.profilePic),
                                                radius: 32,
                                              ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CustomTextfield(
                            controller: nameController,
                            hintText: 'Name',
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}












// import 'dart:io';
// // import 'dart:io';

// // import 'package:dotted_border/dotted_border.dart';
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:reddit_tutorial/core/common/error_text.dart';
// // import 'package:reddit_tutorial/core/common/loader.dart';
// // import 'package:reddit_tutorial/core/constants/constants.dart';
// // import 'package:reddit_tutorial/core/utils.dart';
// // import 'package:reddit_tutorial/features/auth/controlller/auth_controller.dart';
// // import 'package:reddit_tutorial/features/user_profile/controller/user_profile_controller.dart';
// // import 'package:reddit_tutorial/responsive/responsive.dart';
// // import 'package:reddit_tutorial/theme/pallete.dart';
// import 'package:chatterbox/core/common/loader.dart';
// import 'package:chatterbox/core/constants/constants.dart';
// import 'package:chatterbox/features/user_profile/controller/user_profile_controller.dart';
// import 'package:chatterbox/theme/pallete.dart';
// import 'package:chatterbox/widgets/custom_textfield.dart';
// import 'package:chatterbox/core/utils.dart';
// import 'package:chatterbox/features/auth/controlller/auth_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:chatterbox/core/common/error_text.dart';
// import 'package:chatterbox/responsive/responsive.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/foundation.dart';

// class EditProfileScreen extends ConsumerStatefulWidget {
//   final String uid;
//   const EditProfileScreen({
//     super.key,
//     required this.uid,
//   });

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _EditProfileScreenState();
// }

// class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
//   File? bannerFile;
//   File? profileFile;
//   Uint8List? bannerWebFile;
//   Uint8List? profileWebFile;

//   late TextEditingController nameController;

//   @override
//   void initState() {
//     super.initState();
//     nameController = TextEditingController(text: ref.read(userProvider)!.name);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     nameController.dispose();
//   }

//   void selectBannerImage() async {
//     final res = await pickImage();

//     if (res != null) {
//       if (kIsWeb) {
//         setState(() {
//           bannerWebFile = res.files.first.bytes;
//         });
//       } else {
//         setState(() {
//           bannerFile = File(res.files.first.path!);
//         });
//       }
//     }
//   }

//   void selectProfileImage() async {
//     final res = await pickImage();

//     if (res != null) {
//       if (kIsWeb) {
//         setState(() {
//           profileWebFile = res.files.first.bytes;
//         });
//       } else {
//         setState(() {
//           profileFile = File(res.files.first.path!);
//         });
//       }
//     }
//   }

//   void saveProfileChanges() {
//     ref.read(userProfileControllerProvider.notifier).editProfile(
//           profileFile: profileFile,
//           bannerFile: bannerFile,
//           context: context,
//           name: nameController.text.trim(),
//           bannerWebFile: bannerWebFile,
//           profileWebFile: profileWebFile,
//         );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isLoading = ref.watch(userProfileControllerProvider);
//     final currentTheme = ref.watch(themeNotifierProvider);

//     return ref.watch(getUserDataProvider(widget.uid)).when(
//           data: (user) => Scaffold(
//             backgroundColor: currentTheme.scaffoldBackgroundColor,
//             appBar: AppBar(
//               title: const Text(
//                 'Edit Profile',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: Colors.deepOrange,
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: saveProfileChanges,
//                   child: const Text(
//                     'Save',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             body: isLoading
//                 ? const Loader()
//                 : Responsive(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         children: [
//                           SizedBox(
//                             height: 200,
//                             child: Stack(
//                               children: [
//                                 GestureDetector(
//                                   onTap: selectBannerImage,
//                                   child: DottedBorder(
//                                     borderType: BorderType.RRect,
//                                     radius: const Radius.circular(10),
//                                     dashPattern: const [10, 4],
//                                     strokeCap: StrokeCap.round,
//                                     color: currentTheme
//                                         .textTheme.bodySmall!.color!,
//                                     child: Container(
//                                       width: double.infinity,
//                                       height: 150,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       child: bannerWebFile != null
//                                           ? Image.memory(bannerWebFile!)
//                                           : bannerFile != null
//                                               ? Image.file(bannerFile!)
//                                               : user.banner.isEmpty ||
//                                                       user.banner ==
//                                                           Constants
//                                                               .bannerDefault
//                                                   ? const Center(
//                                                       child: Icon(
//                                                         Icons
//                                                             .camera_alt_outlined,
//                                                         size: 40,
//                                                       ),
//                                                     )
//                                                   : Image.network(user.banner),
//                                     ),
//                                   ),
//                                 ),
//                                 Positioned(
//                                   bottom: 20,
//                                   left: 20,
//                                   child: GestureDetector(
//                                     onTap: selectProfileImage,
//                                     child: profileWebFile != null
//                                         ? CircleAvatar(
//                                             backgroundImage:
//                                                 MemoryImage(profileWebFile!),
//                                             radius: 32,
//                                           )
//                                         : profileFile != null
//                                             ? CircleAvatar(
//                                                 backgroundImage:
//                                                     FileImage(profileFile!),
//                                                 radius: 32,
//                                               )
//                                             : CircleAvatar(
//                                                 backgroundImage: NetworkImage(
//                                                     user.profilePic),
//                                                 radius: 32,
//                                               ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           CustomTextfield(
//                               controller: nameController, hintText: 'Name'),
//                         ],
//                       ),
//                     ),
//                   ),
//           ),
//           error: (error, stackTrace) => ErrorText(error: error.toString()),
//           loading: () => const Loader(),
//         );
//   }
// }













// // import 'dart:io';

// // import 'package:dotted_border/dotted_border.dart';
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:reddit_tutorial/core/common/error_text.dart';
// // import 'package:reddit_tutorial/core/common/loader.dart';
// // import 'package:reddit_tutorial/core/constants/constants.dart';
// // import 'package:reddit_tutorial/core/utils.dart';
// // import 'package:reddit_tutorial/features/auth/controlller/auth_controller.dart';
// // import 'package:reddit_tutorial/features/user_profile/controller/user_profile_controller.dart';
// // import 'package:reddit_tutorial/responsive/responsive.dart';
// // import 'package:reddit_tutorial/theme/pallete.dart';

// // class EditProfileScreen extends ConsumerStatefulWidget {
// //   final String uid;
// //   const EditProfileScreen({
// //     super.key,
// //     required this.uid,
// //   });

// //   @override
// //   ConsumerState<ConsumerStatefulWidget> createState() => _EditProfileScreenState();
// // }

// // class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
// //   File? bannerFile;
// //   File? profileFile;

// //   Uint8List? bannerWebFile;
// //   Uint8List? profileWebFile;
// //   late TextEditingController nameController;

// //   @override
// //   void initState() {
// //     super.initState();
// //     nameController = TextEditingController(text: ref.read(userProvider)!.name);
// //   }

// //   @override
// //   void dispose() {
// //     super.dispose();
// //     nameController.dispose();
// //   }

// //   void selectBannerImage() async {
// //     final res = await pickImage();

// //     if (res != null) {
// //       if (kIsWeb) {
// //         setState(() {
// //           bannerWebFile = res.files.first.bytes;
// //         });
// //       } else {
// //         setState(() {
// //           bannerFile = File(res.files.first.path!);
// //         });
// //       }
// //     }
// //   }

// //   void selectProfileImage() async {
// //     final res = await pickImage();

// //     if (res != null) {
// //       if (kIsWeb) {
// //         setState(() {
// //           profileWebFile = res.files.first.bytes;
// //         });
// //       } else {
// //         setState(() {
// //           profileFile = File(res.files.first.path!);
// //         });
// //       }
// //     }
// //   }

// //   void save() {
// //     ref.read(userProfileControllerProvider.notifier).editCommunity(
// //           profileFile: profileFile,
// //           bannerFile: bannerFile,
// //           context: context,
// //           name: nameController.text.trim(),
// //           bannerWebFile: bannerWebFile,
// //           profileWebFile: profileWebFile,
// //         );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final isLoading = ref.watch(userProfileControllerProvider);
// //     final currentTheme = ref.watch(themeNotifierProvider);

// //     return ref.watch(getUserDataProvider(widget.uid)).when(
// //           data: (user) => Scaffold(
// //             backgroundColor: currentTheme.backgroundColor,
// //             appBar: AppBar(
// //               title: const Text('Edit Profile'),
// //               centerTitle: false,
// //               actions: [
// //                 TextButton(
// //                   onPressed: save,
// //                   child: const Text('Save'),
// //                 ),
// //               ],
// //             ),
// //             body: isLoading
// //                 ? const Loader()
// //                 : Responsive(
// //                     child: Padding(
// //                       padding: const EdgeInsets.all(8.0),
// //                       child: Column(
// //                         children: [
// //                           SizedBox(
// //                             height: 200,
// //                             child: Stack(
// //                               children: [
// //                                 GestureDetector(
// //                                   onTap: selectBannerImage,
// //                                   child: DottedBorder(
// //                                     borderType: BorderType.RRect,
// //                                     radius: const Radius.circular(10),
// //                                     dashPattern: const [10, 4],
// //                                     strokeCap: StrokeCap.round,
// //                                     color: currentTheme.textTheme.bodyText2!.color!,
// //                                     child: Container(
// //                                       width: double.infinity,
// //                                       height: 150,
// //                                       decoration: BoxDecoration(
// //                                         borderRadius: BorderRadius.circular(10),
// //                                       ),
// //                                       child: bannerWebFile != null
// //                                           ? Image.memory(bannerWebFile!)
// //                                           : bannerFile != null
// //                                               ? Image.file(bannerFile!)
// //                                               : user.banner.isEmpty || user.banner == Constants.bannerDefault
// //                                                   ? const Center(
// //                                                       child: Icon(
// //                                                         Icons.camera_alt_outlined,
// //                                                         size: 40,
// //                                                       ),
// //                                                     )
// //                                                   : Image.network(user.banner),
// //                                     ),
// //                                   ),
// //                                 ),
// //                                 Positioned(
// //                                   bottom: 20,
// //                                   left: 20,
// //                                   child: GestureDetector(
// //                                     onTap: selectProfileImage,
// //                                     child: profileWebFile != null
// //                                         ? CircleAvatar(
// //                                             backgroundImage: MemoryImage(profileWebFile!),
// //                                             radius: 32,
// //                                           )
// //                                         : profileFile != null
// //                                             ? CircleAvatar(
// //                                                 backgroundImage: FileImage(profileFile!),
// //                                                 radius: 32,
// //                                               )
// //                                             : CircleAvatar(
// //                                                 backgroundImage: NetworkImage(user.profilePic),
// //                                                 radius: 32,
// //                                               ),
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                           TextField(
// //                             controller: nameController,
// //                             decoration: InputDecoration(
// //                               filled: true,
// //                               hintText: 'Name',
// //                               focusedBorder: OutlineInputBorder(
// //                                 borderSide: const BorderSide(color: Colors.blue),
// //                                 borderRadius: BorderRadius.circular(10),
// //                               ),
// //                               border: InputBorder.none,
// //                               contentPadding: const EdgeInsets.all(18),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //           ),
// //           loading: () => const Loader(),
// //           error: (error, stackTrace) => ErrorText(
// //             error: error.toString(),
// //           ),
// //         );
// //   }
// // }
