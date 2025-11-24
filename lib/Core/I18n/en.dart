import 'package:idealize_new_version/Core/I18n/messages.dart';
import 'package:idealize_new_version/Core/I18n/translations.dart';

class EnLanguageData extends LanguageDataKeys {
  EnLanguageData();

  @override
  Map<String, String> get keys => {
        AppStrings.accept: "Accept",
        AppStrings.reject: "Reject",
        AppStrings.addTag: "Add Tag",
        AppStrings.addTags: "Add Tags",
        AppStrings.searchNotFound: "Search not found",
        AppStrings.createNewProject: "Create New Project",
        AppStrings.editProject: "Edit Project",
        AppStrings.addProjekt: "Add Project",
        AppStrings.tags: "Tags:*",
        AppStrings.members: "Members",
        AppStrings.teamMembers: "Team Members",
        AppStrings.addMembers: "Add Members",
        AppStrings.next: "Next",
        AppStrings.edit: "Edit",
        AppStrings.close: "Close",
        AppStrings.done: "Done",
        AppStrings.required: "required",
        AppStrings.home: "Home",
        AppStrings.profile: "Profile",
        AppStrings.settings: "Settings",
        AppStrings.projectTitle: "Project Title:*",
        AppStrings.projectTitleHint:
            "Enter a title for your project (3-50 characters)",
        AppStrings.projectTitleRangeError:
            "Title must be between 3 and 50 characters",
        AppStrings.projectTitleCharacterRange: "3-50 characters",
        AppStrings.desciption: "Description:",
        AppStrings.descriptionHint: "Enter description here",
        AppStrings.saveAsDraft: "Save as draft",
        AppStrings.editAndSave: "Edit and Save",
        AppStrings.save: "Save",
        AppStrings.forgotPassword: "Forgot Password?",
        AppStrings.forgotPasswordHint:
            "Enter your email for verification. We will send a 4-digit code to your email",
        AppStrings.emailHint: "Enter your user email address",
        AppStrings.enterVerificationCode: "Enter 4-digit Code",
        AppStrings.enterVerificationCodeHint:
            "Enter the 4-digit code that you received via email.",
        AppStrings.didntReceiveCode: "Didn't receive code?",
        AppStrings.resendCode: "resend code",
        AppStrings.verificationCodeNotCorrect:
            "The code you entered is not correct",
        AppStrings.resetPassword: "Reset Password",
        AppStrings.resetPasswordHint: "Set the new password for your account.",
        AppStrings.newPassword: "New Password",
        AppStrings.newPasswordHint: "Enter new password",
        AppStrings.reEnterNewPassword: "Re-enter new password",
        AppStrings.reEnterPassword: "Re-enter password",
        AppStrings.resetSuccesful: "Reset Successful",
        AppStrings.findProjects: "Find Projects",
        AppStrings.projects: "Projects",
        AppStrings.trendingTab: "Trending",
        AppStrings.latestTab: "Latest",
        AppStrings.favoritesTab: "Favorites",
        AppStrings.openProject: "Open Project",
        AppStrings.backToTop: "Back to top",
        AppStrings.pullDownToRefresh: "Pull down to refresh",
        AppStrings.emptyList:
            "Your list is empty, refresh to load new projects",
        AppStrings.selectLanguage: "Select Language",
        AppStrings.english: "English",
        AppStrings.german: "German",
        AppStrings.signIn: "Sign In",
        AppStrings.userName: "User Name:",
        AppStrings.userNameHint: "Enter your user name",
        AppStrings.password: "Password",
        AppStrings.passwordHint: "Enter your password",
        AppStrings.clickHere: "click here",
        AppStrings.login: "Login",
        AppStrings.signUpHere: "sign up here",
        AppStrings.wrongCredentials: "password or user name incorrect!",
        AppStrings.myProjects: "My Projects",
        AppStrings.favorites: "Favorites",
        AppStrings.interests: "Interests:",
        AppStrings.addInterest: "Add Interests",
        AppStrings.classes: "Classes",
        AppStrings.addClasses: "Add Classes",
        AppStrings.firstName: "First Name",
        AppStrings.lastName: "Last Name",
        AppStrings.changePicture: "Change Picture",
        AppStrings.editProfile: "Edit Profile",
        AppStrings.cancel: "Cancel",
        AppStrings.projectSuccesfullyCreated: "Project was created!!!",
        AppStrings.goToProjectProfile: "Go to Project Profile",
        AppStrings.goToHomepage: "Go to Homepage",
        AppStrings.owner: "Owner",
        AppStrings.likes: "Likes",
        AppStrings.like: "Like",
        AppStrings.comments: "Comments",
        AppStrings.comment: "Comment",
        AppStrings.copy: "Copy",
        AppStrings.drafts: "Drafts",
        AppStrings.darkMode: "Dark Mode",
        AppStrings.lightMode: "Light Mode",
        AppStrings.textSize: "Text Size",
        AppStrings.language: "Language",
        AppStrings.privacy: "Privacy",
        AppStrings.security: "Security",
        AppStrings.deleteAccount: "Delete Account",
        AppStrings.deleteMaterial: "Delete Material",
        AppStrings.logout: "Logout",
        AppStrings.splashScreenText:
            "Please log in or create an account to proceed",
        AppStrings.signUp: "Sign Up",
        AppStrings.addInterestHint: "Search interests",
        AppStrings.requestNewInterest:
            "Click here to send request for adding a new interest",
        AppStrings.email: "Email Address",
        AppStrings.recoveryEmail: "Recovery Email",
        AppStrings.recoveryEmailExplanation:
            "This email will be used to recover your HHN account if you lost access to it.",
        AppStrings.exitsitingAccount: "Already have an account?",
        AppStrings.loginHere: "login here",
        AppStrings.passwordCriteriaFailed: "Must contain numbers and symbols",
        AppStrings.profilePicture: "Profile Picture:",
        AppStrings.finish: "Finish",
        AppStrings.textSizeSample: "Text sample to demonstrate the size",
        AppStrings.thisFieldAreRequired: "Fields marked with * are required",
        AppStrings.here: "here",
        AppStrings.alreadyHaveAnAccount: "Already have an account?",
        AppStrings.iAgree: "I agree with the ",
        AppStrings.termsAndConditions: "Terms and conditions *.",
        AppStrings.isNotEmail: "Email is not valid",
        AppStrings.passIsNotStrong: "Password is not strong",
        AppStrings.passIsNotMatch: "Passwords do not match",
        AppStrings.couldNotBeEmpty: "Field cannot be empty",
        AppStrings.pleaseLoginOrSignUp:
            "Please login or create an account to proceed",
        AppStrings.resetIt: "Reset it ",
        AppStrings.dontHaveAnAccount: "Don't have an account?",
        AppStrings.addProgram: "Add Program",
        AppStrings.isEmpty: "Field cannot be empty",
        AppStrings.search: "Search",
        AppStrings.click: "Click",
        AppStrings.studyPrograms: "Study Programs:",
        AppStrings.addNewTagOrCourse: "Add new tag or course.",
        AppStrings.addNew: "Add new @name.",
        AppStrings.toAddNewTagOrCourse: "to add new tag or course.",
        AppStrings.toAddNew: "to add new @name.",
        AppStrings.confirmationRequired: "Confirmation Required",
        AppStrings.skipRegistrationStepsMsg:
            "You have the option to skip the registration steps and complete them later in your profile settings.",
        AppStrings.okay: "OK",
        AppStrings.gallery: "Gallery",
        AppStrings.camera: "Camera",
        AppStrings.registartionSuccessMsg:
            "Registration Completed Successfully 🎉",
        AppStrings.startUsingIdealize: "Start using Idealize",
        AppStrings.newHome: "New",
        AppStrings.forYou: "For You",
        AppStrings.addInterestsToGetRecommendations:
            "Add tags and courses to your profile to get personalized recommendations",
        AppStrings.weeklyTrend: "Weekly Trend",
        AppStrings.addNewProject: "Add New Project",
        AppStrings.or: "Or",
        AppStrings.workOnAProjectFromDraft: "Work on a project from draft:",
        AppStrings.emptyFavoriteProject:
            "You don't have any favorite projects yet.",
        AppStrings.emptyDraftProjectMessage:
            "You don't have any draft projects yet.",
        AppStrings.emptyDraftProject:
            "You don't have any draft projects yet. \n Start by creating a new project.",
        AppStrings.multiLineTextFieldHint: "Enter your text here",
        AppStrings.success: "Success",
        AppStrings.addLink: "Add Links:",
        AppStrings.addLinkTitle: "Link Name",
        AppStrings.addLinkUrl: "Add URL",
        AppStrings.courses: "Courses",
        AppStrings.addCourse: "Add Course",
        AppStrings.addCourses: "Add Courses",
        AppStrings.warningValidUrl: 'Please enter a valid URL',
        AppStrings.errorValidUrl: 'Please enter a valid URL',
        AppStrings.error: "Error",
        AppStrings.warning: "Warning",
        AppStrings.files: "Files:",
        AppStrings.uploadFile: "Upload File",
        AppStrings.uploadFiles: "Upload Files",
        AppStrings.media: "Media:",
        AppStrings.uploadMedia: "Upload Media",
        AppStrings.thumbnail: "Thumbnail:",
        AppStrings.uploadThumbnail: "Upload Thumbnail",
        AppStrings.publish: "Publish",
        AppStrings.emptyNotification: "No notifications yet.",
        AppStrings.notification: "Notifications",
        AppStrings.clearAll: "Clear all",
        AppStrings.clearNotificationsWarning:
            "⚠️ {count} pending request(s) kept - please respond to them",
        AppStrings.clearOnlyRead:
            "Notifications cleared (pending requests kept)",
        AppStrings.responseSent: "Response sent",
        AppStrings.responseSentMsg: "Response sent successfully",
        AppStrings.firstNameHint: "Your first name",
        AppStrings.lastNameHint: "Your last name",
        AppStrings.backToHome: "Back to Home",
        AppStrings.newProject: "New Project",
        AppStrings.addStudyPrograms: "Add Study Programs",
        AppStrings.projectDetails: "Project Details",
        AppStrings.aboutProject: "About Project",
        AppStrings.projectMaterials: "Project Materials",
        AppStrings.noComments:
            "No comments available!\nBe the first to comment!",
        AppStrings.noContributors: "No contributors",
        AppStrings.joinProject: "Join Project",
        AppStrings.joinProjectPending:
            "Your request to join the project has been sent. Please wait for the project owner to respond.",
        AppStrings.joinProjectAccepted: "You're part of the project!",
        AppStrings.joinProjectCancelled: "Join request cancelled",
        AppStrings.report: "Report",
        AppStrings.tagNameValid: "Tag name must be valid!",
        AppStrings.editInformation: "Edit information?",
        AppStrings.tooManyRequests:
            "Too many requests exception, please try again later!",
        AppStrings.enterValidEmail: "Please enter a valid email",
        AppStrings.enterCodePassword: "Please enter code and password",
        AppStrings.passIsReset:
            "Your password has been reset, you will redirect to auth page in 3 seconds.",
        AppStrings.profileUpdated: "Profile updated successfully",
        AppStrings.profileUpdateFailed: "Failed to update profile",
        AppStrings.downloadError:
            "An error occurred during download. Please try again later.",
        AppStrings.downloadComplete: "File downloaded to:",
        AppStrings.requestSent:
            "Your request to join the project has been sent. Please wait for the project owner to respond.",
        AppStrings.ownerNotAvailable:
            "The project owner is not available. Please try again later.",
        AppStrings.projectReported: "The project has been reported.",
        AppStrings.fillRequiredFields:
            "Please fill all the required fields correctly",
        AppStrings.fileNotSupportedFormat:
            "The file @keyword1 is not a supported format",
        AppStrings.fileTooLarge: "The file @keyword2 is too large",
        AppStrings.noMediafileSelected: "No media file was selected",
        AppStrings.maximumFilesReached: "You have reached the maximum files!",
        AppStrings.fileTooLargeNotSupportedFormat:
            "The file @keyword3 is too large or not a supported format",
        AppStrings.noFileSelected: "No file was selected",
        AppStrings.maximumMedias: "You have reached the maximum medias!",
        AppStrings.fileAlreadyAdded: "The file @keyword4 is already added",
        AppStrings.writeAComment: "Write a comment",
        AppStrings.commentTooShort: "Comment must be at least 2 characters",
        AppStrings.commentTooLong: "Comment cannot exceed 300 characters",
        AppStrings.noUsersToShow:
            "There are no users to show.\nPlease check later.",
        AppStrings.emptyHere: "It is empty here!",
        AppStrings.fileUploadInfo: "File Upload Info",
        AppStrings.uploadInformation:
            "You can upload files up to 10 MB in size. Supported formats are PDF, DOC, PPT and PPTX .",
        AppStrings.fillAllFields: "Please fill all the fields",
        AppStrings.sureAboutDeletingMaterial:
            "Are you sure you want to delete the material from the project ? It will delete the material permanantly from the project!",
        AppStrings.passwordInstructions:
            "Password Requirements:\n- Minimum of 8 characters\n- At least one uppercase letter\n- At least one numeric digit\n- At least one special character",
        AppStrings.termsCondifitonCheckbox:
            "You have accepted the terms and conditions checkbox",
        AppStrings.tag: "Tag",
        AppStrings.course: "Course",
        AppStrings.studyProgram: "Study Program",
        AppStrings.skip: "Save & Skip",
        AppStrings.photoAccessDenied:
            "Photo access denied, please allow access in settings",
        AppStrings.accessDenied: "Access Denied",
        AppStrings.okey: "OK",
        AppStrings.skipReqDesc:
            "You have the option to skip this steps and add it later in your profile.",
        AppStrings.noTitle: "No title",
        AppStrings.delete: "Delete",
        AppStrings.deletedUser: "Deleted User",
        AppStrings.deletedUserShort: "Deleted",
        AppStrings.institution: "Institution",
        AppStrings.selectInstitution: "Select your institution",
        AppStrings.institutionEmailHint:
            "Please use your institutional email address",
        // TODO is SH: Changed from overview to aboutYou for better UX
        AppStrings.aboutYou: "About You",
        AppStrings.aboutYouHint: "Tell us about yourself (max 500 characters)",
        AppStrings.aboutYouTooLong: "About You must be 500 characters or less",
        AppStrings.aboutYouDescription:
            "Share a bit about yourself, your interests, or what you're working on. This helps others connect with you better!",
        AppStrings.aboutUser: "About @name",
        AppStrings.deleteProject: "Delete Project",
        AppStrings.deleteProjectContent:
            "Are you sure you want to delete @projectKeyword? This action cannot be undone.",
        AppStrings.jrdTitle: "Join Request",
        AppStrings.jrdContent:
            "By joining a project, you can participate and collaborate with other users. You can send a membership request to the project owner, stating why you want to join the project and what your motivation is.",
        AppStrings.jrdContentHint: "Enter your message (Optional)",
        AppStrings.submit: "Submit",
        AppStrings.reply: "Reply",
        AppStrings.replyTo: "Reply to",
        AppStrings.hideComments: "Hide comments",
        AppStrings.showComments: "Show comments",
        AppStrings.deleteCommentTitle: "Delete Comment",
        AppStrings.deleteCommentContent:
            "Are you sure you want to delete this comment?",
        AppStrings.filePicker: "File Picker",
        AppStrings.mediaPicker: "Media Picker",
        AppStrings.unknown: "Unknown",
        AppStrings.descriptionWaring:
            "Description must be at least 100 characters.",
        AppStrings.linksWarningMoreThan5: "You cannot add more than 5 links.",
        AppStrings.linksWarningMoreThan15: "You cannot add more than 15 links.",
        AppStrings.permissionRequired: "Permission Required",
        AppStrings.permissionRequiredContent:
            "Please allow access to photos in your settings.",
        AppStrings.openSettings: "Open Settings",
        AppStrings.reportBug: "Report Bug",
        AppStrings.reportBugContent:
            "You noticed a bug in the app? you can easily report it here, please describe the bug for us.",
        AppStrings.reportBugDesc: "Enter your bug description/suggestion",
        AppStrings.addNewTag: "Add New Tag",
        AppStrings.addNewCourse: "Add New Course",
        AppStrings.addNewStudyProgram: "Add New Study Program",
        AppStrings.reportBugDescEmpty: "Please enter your bug description",
        AppStrings.tagName: "Tag name",
        AppStrings.add: "Add",
        AppStrings.reportedSuccessTitle: "Reported Successfully",
        AppStrings.reportedSuccessDesc:
            "Your report has been sent successfully",
        AppStrings.joinTeamMemberAcceptedByYou:
            "You accepted @name to join project @project",
        AppStrings.joinTeamMemberCanceledByYou:
            "You canceled @name to join project @project",
        AppStrings.joinTeamMemberAccepted:
            "@name accepted your join request on project @project",
        AppStrings.joinTeamMemberCanceled:
            "@name canceled your join request on project @project",
        AppStrings.joinTeamMember: "@name would like to join project @project",
        AppStrings.somebodyBookmarkedyou: "@name bookmarked project @project",
        AppStrings.somebodyLikedyou: "@name liked project @project",
        AppStrings.somebodyReportedyou: "@name reported project @project",
        AppStrings.somebodyCommentedyou: "@name commented on project @project",
        AppStrings.notifBookmar: "Bookmark",
        AppStrings.notifLike: "Like",
        AppStrings.notifComment: "Comment",
        AppStrings.notifReport: "Report",
        AppStrings.notifAddTeamMamber: "Add Team Member",
        AppStrings.notifJoinTeamMember: "Join Request",
        AppStrings.addTeamMember:
            "@name would like to add you to project @project",
        AppStrings.addTeamMemberAccepted: "@name accepted your join request",
        AppStrings.addTeamMemberCanceled: "@name canceled your join request",
        AppStrings.addTeamMemberAcceptedByYou:
            "You accepted to be a part of @project",
        AppStrings.addTeamMemberCanceledByYou:
            "You canceled to be a part of @project",
        AppStrings.message: "Message",
        AppStrings.deleteAccountDesc:
            "Before you delete your account, consider the impact on our community. You have two options:",
        AppStrings.deleteAccountDescOption0:
            "Option 1: Keep your account's name and projects visible to the community, but delete your account (email, password). This allows others to learn from and build upon your contributions.",
        AppStrings.deleteAccountDescOption1:
            "Option 2: Anonymize your account Delete your personal account information, but allow your projects to remain in the system anonymously. This helps preserve the ecosystem and allows others to learn from and build upon your contributions.",
        AppStrings.deleteAccountDescOption2:
            "Option 3: Permanently delete everything Completely remove your account and all associated projects from our system. This action is irreversible and will delete all your data.",
        AppStrings.deleteAccountDesc2:
            "Please choose an option below:\n\nYou could also add a warning or a note to emphasize the permanence of the deletion, such as:\n\nNote: Once you delete your account, it cannot be recovered. Please make sure you have exported any important data before proceeding.",
        AppStrings.yesDelete: "Yes, delete my account",
        AppStrings.youHaveToChangeTheOwner:
            "You have to change the owner of the projects, before you delete your account.",
        AppStrings.connectionProblem: "Connection Problem",
        AppStrings.project: "Project",
        AppStrings.draft: "Draft",
        // Dialogs
        AppStrings.dailogAddLinksTitle: "Add Links",
        AppStrings.dailogAddLinksContent:
            "The links could be shown in the project page, such as GitHub, LinkedIn, etc.",
        AppStrings.dailogAddTagsTitle: "Add Tags",
        AppStrings.dailogAddTagsContent:
            "Add tags to the project to make it easier to find it.",
        AppStrings.dailogProjectTitleInfo:
            "The project title should be between 3 and 50 characters. Choose a clear and descriptive title that represents your project well.",
        AppStrings.dailogAddCoursesTitle: "Add Courses",
        AppStrings.dailogAddCoursesContent:
            "Add courses to the project to make it easier to find it.",
        AppStrings.dailogAddTeamMemberTitle: "Add Team Member",
        AppStrings.dailogAddTeamMemberContent:
            "You can add members to the project, for contribution and more.",
        AppStrings.deleteAccountKeepData: "Keep my data",
        AppStrings.deleteAccountAnanymize: "Anonymize my account",
        AppStrings.deleteAccountComplete: "Permanently delete my account",

        AppStrings.deleteAccountOption0Desc:
            "Good choice!\n\n we keep your account's name and projects visible to the community, but delete your account (email, password). This allows others to learn from and build upon your contributions.",
        AppStrings.deleteAccountOption1Desc:
            "Good choice!\n\n Now we require your confirmation to delete your account, so please tap! on the button below to get a confirmation code sent to your email.",
        AppStrings.deleteAccountOption0Button: "Send confirmation code",
        AppStrings.deleteAccountOption1Button: "Send confirmation code",
        AppStrings.deleteAccountOption0TextField: "Enter code",
        AppStrings.deleteAccountOption1TextField: "Enter code",
        AppStrings.deleteAccountOption2Desc:
            "Okey, let's do it!\n\nNow we require your confirmation to delete your account, so please tap! on the button below to get a confirmation code sent to your email.",
        AppStrings.deleteAccountOption3Desc:
            "Opss, you've some projects, with team members, please remove them, or change the owner, before deleting your account.",
        AppStrings.pickMember: "Pick a member",
        AppStrings.rightsForMedia:
            "I confirm that I have the right to use the images or links I have uploaded.",
        AppStrings.mediaStoredPlace:
            "Media storage location\nAndroid: Uploaded images and media are stored on your device at Files > IdeaLize > Media.\niPhone: Uploaded images and media are stored on your device at Files > IdeaLize > Media.\nThe exact storage location may vary depending on the device model and operating system version.",
        AppStrings.pickMoreThan3Error:
            "You can\'t select more than @count @name",
        AppStrings.minimum100Characters: "must be at least 100 characters.",
        AppStrings.enterYourEmailAdr: "Enter Your Email Address",
        AppStrings.enterYourPassword: "Enter Your Password",
        AppStrings.resetPasswordCaption:
            "Enter your email address and we will send you a link to reset your password",
        AppStrings.alreadyReported: "Already Reported",
        AppStrings.alreadyReportedCaption:
            "You have already reported this project.",
        AppStrings.reportReason:
            "Please enter the reason for reporting this project. We will review your report and take necessary actions.",
        AppStrings.reason: "Reason",
        AppStrings.enterYourReason: "Enter Your Reason",
        AppStrings.createNewProjectStepTwoCaption:
            "Your project will be more successful, if you add some tags, team members or links.",
        AppStrings.createNewProjectStepThreeCaption:
            "Adding more information such as Files, Media and Thumbnail, could make your project, more attractive.",

        AppStrings.links: "Links",
        AppStrings.noLinksAvailable: "No Links Available!",
        AppStrings.mediaFiles: "Media Files",
        AppStrings.noMediaAvailable: "No Media Available!",
        AppStrings.documentFiles: "Document Files",
        AppStrings.noDocumentFilesAvailable: "No Document Files Available!",
        AppStrings.timeLeft: "Time Left: @time",
        AppStrings.signUpStep2InterestsCaption:
            "Select the topics that interest you the most",
        AppStrings.signUpStep2StudyProgramsCaption:
            "Select your study programs",
        AppStrings.reportComment: "Report Comment",
        AppStrings.commentReportReason:
            "Please enter the reason for reporting this comment. We will review your report and take necessary actions.",
        AppStrings.createNewProjectStepTwoCaptionForCourses:
            'Choosing a course will help you to be visible to more people, with the same interest or study program.',
        AppStrings.createNewProjectStepTwoCaptionForTeamMembers:
            'You can add team members to the project, for contribution and more.',
        AppStrings.createNewProjectStepTwoCaptionForLinks:
            'The links could be shown in the project page, such as GitHub, LinkedIn, etc.',
        AppStrings.userForbidden: 'Forbidden',
        AppStrings.userForbiddenCaption: 'User is not activated',
        AppStrings.userBlockedAdminCaption: 'User is blocked by admin',
        AppStrings.tryAgain: 'Try Again',
        AppStrings.teamMember: "Member",
        AppStrings.weakPassword: "Password is weak, follow the requirements",
        AppStrings.emailShouldBeHHNHint:
            "Your email should be @hs-heilbronn.de or @stud.hs-heilbronn.de",
        AppStrings.storageAccessFailed: "Could not access storage",
        AppStrings.downloadFailed: "Download failed",
        AppStrings.couldNotOpenDownloadedFile: "Could not open downloaded file",
        AppStrings.faq: "FAQ",
        AppStrings.faq1:
            "Where do my downloaded materials go after I click download?",
        AppStrings.faq1A: """
Downloads are usually saved in your device’s:

Android: Files > Downloads > materials > {project_name}
iOS: Files app > Downloads > materials > {project_name}
        """,

        AppStrings.faq2:
            "What can I do if I lose access to my school or work email?",
        AppStrings.faq2A: """
	1.	Add a Secondary Email
	•	Go to Account Settings (⚙️) → Email & Security.
	•	Under Secondary Email, enter your personal email address and click Add.
	•	You’ll receive a confirmation message at that address—click the link to verify.
	2.	Use Your Secondary Email for Password Resets
	•	If you ever get locked out or forget your password, choose “Reset via secondary email” on the password-reset page.
	•	We’ll send the reset link to your personal email so you can securely create a new password.
	3.	Deleting Your Account
	•	If you decide to close your account and can’t access your primary email, select “Delete via secondary email” in the account-deletion workflow.
	•	We’ll email you a one-time link at your personal address to confirm and complete the deletion process.
        """,
        AppStrings.impressum: "Imprint",
        AppStrings.useRecoveryEmail: "Send OTP to my recovery email.",
        AppStrings.useRecoveryEmailDesc:
            "You don't access to your HHN account? tap here to receive OTP on your recovery email",
      };
}
