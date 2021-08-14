
// import 'package:jfl2/Screens/sign_in_sign_up/sign_in.dart';
// import 'package:jfl2/components/locator.dart';
// import 'package:jfl2/components/navigation_service.dart';
//
// class DynamicLinkService{
//   final NavigationService _navigationService = locator<NavigationService>();
//   Future handleDynamicLinks() async{
//     //Get initial dynamic link if the app is started using the dynamic link
//
//     //foreground from dynamic link logic
//     FirebaseDynamicLinks.instance.onLink(
//       onSuccess: (PendingDynamicLinkData dynamicLinkData) async {
//         _handleDeepLink(dynamicLinkData);
//       },
//       onError: (OnLinkErrorException e) async {
//         print('Dynamic Link Failed:${e.message}');
//     }
//     );
//     // https://hakimottey.page.link/test
//   }
//   void _handleDeepLink(PendingDynamicLinkData data){
//     final Uri deepLink = data?.link;
//     if(deepLink != null){
//       print('handleDeepLink | deepLink: $deepLink');
//       var test = deepLink.pathSegments.contains('test');
//       if(test){
//         print("---------------tesst---------------------");
//         _navigationService.navigateTo(SignIn.id);
//       }
//     }
//   }
// }