import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thinknest/core/common/error_text.dart';
import 'package:thinknest/core/common/sign_in_button.dart';
import 'package:thinknest/features/auth/controlller/auth_controller.dart';
import 'package:thinknest/features/community/controller/community_controller.dart';
import 'package:thinknest/models/community_model.dart';

import 'package:routemaster/routemaster.dart';

import '../../../core/common/loader.dart';

// class CommunityListDrawer extends ConsumerWidget {
//   const CommunityListDrawer({super.key});

//   void navigateToCreateCommunity(BuildContext context) {
//     Routemaster.of(context).push('/create-community');
//   }

//   void navigateToCommunity(BuildContext context, Community community) {
//     Routemaster.of(context).push('/d/${community.name}');
//   }

//   void signInWithGoogle(BuildContext context, WidgetRef ref) {
//     ref.read(authControllerProvider.notifier).signInWithGoogle(context);
//   }

//   void useEmail(BuildContext context) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => const EmailUsernameLogin(),
//       ),
//     );
//   }

//   void useEmailSignUp(BuildContext context) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => const EmailSignup(),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Drawer(
//       child: SafeArea(
//         child: Column(
//           children: [
//             ListTile(
//               title: const Text('Create a community'),
//               leading: const Icon(Icons.add),
//               onTap: () => navigateToCreateCommunity(context),
//             ),
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 4),
//               child: Divider(height: 0),
//             ),
//             const SizedBox(height: 10),
//             ref.watch(userCommunitiesProvider).when(
//                   data: (communities) => Expanded(
//                     child: ListView.builder(
//                       itemCount: communities.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         final community = communities[index];
//                         return ListTile(
//                           leading: CircleAvatar(
//                             backgroundImage: NetworkImage(community.avatar),
//                           ),
//                           title: Text('d/${community.name}'),
//                           onTap: () {
//                             navigateToCommunity(context, community);
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                   error: (error, stackTrace) =>
//                       ErrorText(error: error.toString()),
//                   loading: () => const Loader(),
//                 ),
//           ],
//         ),
//       ),
//     );
//   }
// }


class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  void navigateToCommunity(BuildContext context, Community community) {
    Routemaster.of(context).push('/r/${community.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            isGuest
                ? const SignInButton()
                : ListTile(
                    title: const Text('Create a community'),
                    leading: const Icon(Icons.add),
                    onTap: () => navigateToCreateCommunity(context),
                  ),
            if (!isGuest)
              ref.watch(userCommunitiesProvider).when(
                    data: (communities) => Expanded(
                      child: ListView.builder(
                        itemCount: communities.length,
                        itemBuilder: (BuildContext context, int index) {
                          final community = communities[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(community.avatar),
                            ),
                            title: Text('r/${community.name}'),
                            onTap: () {
                              navigateToCommunity(context, community);
                            },
                          );
                        },
                      ),
                    ),
                    error: (error, stackTrace) => ErrorText(
                      error: error.toString(),
                    ),
                    loading: () => const Loader(),
                  ),
          ],
        ),
      ),
    );
  }
}








// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:reddit_tutorial/core/common/sign_in_button.dart';
// import 'package:reddit_tutorial/features/auth/controlller/auth_controller.dart';
// import 'package:reddit_tutorial/models/community_model.dart';
// import 'package:routemaster/routemaster.dart';
// import '../../../core/common/error_text.dart';
// import '../../../core/common/loader.dart';
// import '../../community/controller/community_controller.dart';

// class CommunityListDrawer extends ConsumerWidget {
//   const CommunityListDrawer({super.key});

//   void navigateToCreateCommunity(BuildContext context) {
//     Routemaster.of(context).push('/create-community');
//   }

//   void navigateToCommunity(BuildContext context, Community community) {
//     Routemaster.of(context).push('/r/${community.name}');
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final user = ref.watch(userProvider)!;
//     final isGuest = !user.isAuthenticated;

//     return Drawer(
//       child: SafeArea(
//         child: Column(
//           children: [
//             isGuest
//                 ? const SignInButton()
//                 : ListTile(
//                     title: const Text('Create a community'),
//                     leading: const Icon(Icons.add),
//                     onTap: () => navigateToCreateCommunity(context),
//                   ),
//             if (!isGuest)
//               ref.watch(userCommunitiesProvider).when(
//                     data: (communities) => Expanded(
//                       child: ListView.builder(
//                         itemCount: communities.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           final community = communities[index];
//                           return ListTile(
//                             leading: CircleAvatar(
//                               backgroundImage: NetworkImage(community.avatar),
//                             ),
//                             title: Text('r/${community.name}'),
//                             onTap: () {
//                               navigateToCommunity(context, community);
//                             },
//                           );
//                         },
//                       ),
//                     ),
//                     error: (error, stackTrace) => ErrorText(
//                       error: error.toString(),
//                     ),
//                     loading: () => const Loader(),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class NetworkImage {
// }

// class CircleAvatar {
// }
