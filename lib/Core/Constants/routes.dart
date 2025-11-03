import 'package:get/get.dart';
import 'package:idealize_new_version/Features/Base/presentation/screens/chat_screen.dart';
import 'package:idealize_new_version/Features/edit_profile/presentation/edit_profile_screen.dart';
import 'package:idealize_new_version/Features/Splash/presentation/splash_screen.dart';
import 'package:idealize_new_version/Features/authentication/presentation/screens/reset_password_screen.dart';
import 'package:idealize_new_version/Features/delete_account/presentation/binding/delete_account_binding.dart';
import 'package:idealize_new_version/Features/delete_account/presentation/pages/delete_account_ananymize_page.dart';
import 'package:idealize_new_version/Features/delete_account/presentation/pages/delete_account_complete_page.dart';
import 'package:idealize_new_version/Features/delete_account/presentation/pages/delete_account_keep_data_page.dart';
import 'package:idealize_new_version/Features/delete_account/presentation/pages/delete_account_page.dart';
import 'package:idealize_new_version/Features/project_details/presentation/binding/project_details_binding.dart';
import 'package:idealize_new_version/Features/project_details/presentation/project_details_screen.dart';

import 'package:idealize_new_version/Features/profile/presentation/profile_screen.dart';
import 'package:idealize_new_version/Features/notification/presentation/notification_screen.dart';
import 'package:idealize_new_version/Features/my_projects/presentation/binding/my_projects_binding.dart';
import 'package:idealize_new_version/Features/my_projects/presentation/my_projects_screen.dart';
import 'package:idealize_new_version/Features/app_setting/presentation/screens/text_size_view.dart';
import 'package:idealize_new_version/Features/authentication/presentation/screens/authentication_data_screen.dart';
import 'package:idealize_new_version/Features/authentication/presentation/screens/authentication_base_screen.dart';
import 'package:idealize_new_version/Features/authentication/presentation/bindings/authentication_binding.dart';
import 'package:idealize_new_version/Features/Base/Binding/base_binding.dart';
import 'package:idealize_new_version/Features/Base/base_view.dart';
import 'package:idealize_new_version/Features/Create_New_Project/presentation/views/create_new_project_base_screen.dart';
import 'package:idealize_new_version/Features/Create_New_Project/presentation/views/create_new_project_completed_screen.dart';
import 'package:idealize_new_version/Features/Create_New_Project/presentation/views/create_new_project_screen.dart';
import 'package:idealize_new_version/Features/home/presentation/home_view.dart';

import 'package:idealize_new_version/Features/Register/presentation/View/register_firs_step_screen.dart';
import 'package:idealize_new_version/Features/Register/presentation/View/register_second_step_screen.dart';
import 'package:idealize_new_version/Features/Register/presentation/View/registration_completed_screen.dart';

import 'package:idealize_new_version/Features/archived_projcts/presentation/archived_projcts_screen.dart';
import 'package:idealize_new_version/Features/register/presentation/binding/register_binding.dart';
import 'package:idealize_new_version/Features/report_bug/presentation/binding/report_bug_binding.dart';
import 'package:idealize_new_version/Features/report_bug/presentation/screens/report_bug_screen.dart';
import 'package:idealize_new_version/Features/userSuggestionProfile/presentation/binding/user_suggestion_profile_binding.dart';
import 'package:idealize_new_version/Features/userSuggestionProfile/presentation/user_suggestion_profile_screen.dart';

import '../../Features/Register/presentation/View/register_third_step_screen.dart';

class AppRoutes {
  final splash = '/';
  final authentication = '/authentication';
  final resetPassword = '/reset-password';
  final chatScreen = '/chat-screen';
  final externalAuth = '/external-authentication';
  final home = '/home';
  final createNewProjectBase = '/create-new-project-base';
  final createNewProjectScreen = '/create-new-project-screen';
  final createNewProjectCompleted = '/create-new-project-completed';
  final base = '/base';
  final projectDetails = '/project-details';
  final profile = '/profile';
  final registrationFirstStep = '/registrationFirstStep';
  final registrationSecondStep = '/registrationSecondStep';
  final registrationThirdStep = '/registrationThirdStep';
  final registrationComleted = '/registrationComleted';
  final myProjects = '/myProjects';
  final editProfile = '/editProfile';
  final textSizeView = '/textSizeView';
  final notification = '/notification';
  final archivedProject = '/archivedProject';
  final userSuggestionProfile = '/userSuggestionProfile';
  final reportaBug = '/reportaBug';
  final deleteAccount = '/deleteAccount';
  final deleteAccountOption0 = '/deleteAccount/keepdata';
  final deleteAccountOption1 = '/deleteAccount/anonymize';
  final deleteAccountOption2 = '/deleteAccount/delete';

  List<GetPage> get pages {
    return [
      GetPage(
        name: splash,
        page: () => SplashScreen(),
      ),
      GetPage(
        name: resetPassword,
        page: () => const ResetPasswordScreen(),
      ),
      GetPage(
        name: authentication,
        page: () => const AuthenticationBaseScreen(),
        binding: AuthenticationBinding(),
      ),
      GetPage(
        name: externalAuth,
        page: () => const AuthenticationDataScreen(),
        binding: AuthenticationBinding(),
      ),
      GetPage(
        name: createNewProjectBase,
        page: () => const CreateNewProjectBaseScreen(),
      ),
      GetPage(
        name: createNewProjectScreen,
        page: () => const CreateNewProjectScreen(),
        binding: BaseBinding(),
      ),
      GetPage(
          name: createNewProjectCompleted,
          page: () => const CreateNewProjectCompletedScreen()),
      GetPage(name: home, page: () => const HomeView()),
      GetPage(
        name: profile,
        page: () => const ProfileScreen(),
        binding: BaseBinding(),
      ),
      GetPage(
        name: registrationFirstStep,
        page: () => const RegisterFirstStepScreen(),
        binding: RegisterBinding(),
      ),
      GetPage(
        name: registrationSecondStep,
        page: () => const RegisterSecondStepScreen(),
        binding: RegisterBinding(),
      ),
      GetPage(
          name: registrationThirdStep,
          page: () => const RegisterThirdStepScreen(),
          binding: RegisterBinding()),
      GetPage(
          name: registrationComleted,
          page: () => const RegistrationCompletedScreen()),
      GetPage(
          name: projectDetails,
          binding: ProjectDetailsBinding(),
          page: () => const ProjectDetailsScreen()),
      GetPage(
        name: myProjects,
        page: () => const MyProjectsScreen(),
        binding: MyProjectsBinding(),
      ),
      GetPage(
        name: editProfile,
        page: () => const EditProfileScreen(),
        binding: BaseBinding(),
      ),
      GetPage(name: textSizeView, page: () => const TextSizeView()),
      GetPage(
        name: notification,
        page: () => const NotificationScreen(),
        binding: BaseBinding(),
      ),
      GetPage(
          name: base, binding: BaseBinding(), page: () => const AppBaseView()),
      GetPage(
        name: archivedProject,
        page: () => const ArchivedProjctsScreen(),
        binding: BaseBinding(),
      ),
      GetPage(
        name: chatScreen,
        page: () => const ChatScreen(),
        binding: BaseBinding(),
      ),
      GetPage(
        name: userSuggestionProfile,
        page: () => const UserSuggestionProfileScreen(),
        binding: UserSuggestionProfileBinding(),
      ),
      GetPage(
        name: reportaBug,
        page: () => const ReportBugScreen(),
        binding: ReportBugBinding(),
      ),
      GetPage(
        name: deleteAccount,
        page: () => const DeleteAccountPage(),
        binding: DeleteAccountBinding(),
      ),
      GetPage(
        name: deleteAccountOption0,
        page: () => const DeleteAccountKeepDataPage(),
        binding: DeleteAccountBinding(),
      ),
      GetPage(
        name: deleteAccountOption1,
        page: () => const DeleteAccountAnanymizePage(),
        binding: DeleteAccountBinding(),
      ),
      GetPage(
        name: deleteAccountOption2,
        page: () => const DeleteAccountCompletelyPage(),
        binding: DeleteAccountBinding(),
      ),
    ];
  }
}
