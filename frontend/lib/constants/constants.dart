class Colors {
  static const int orange = 0xFFF15412;
  static const int blue = 0xFF34B3F1;
  static const int grey = 0xFFEEEEEE;
  static const int black = 0xFF000000;
}

class Strings {
  static const String applicationTitle = "DaviVest";
  static const String logoUrl = "assets/images/logo.png";
  static const String logoIconUrl = "assets/images/logo-icon.png";
  static const String dateDelimiter = '/';
  static const String dateFormat = "yyyy-MM-dd'T'HH:mm";
  static const String or = "OR";
  static const String success = "Success";

  static const String loginButtonMessage = "Login";
  static const String signupButtonMessage = "Signup";
  static const String logoutButtonMessage = "Logout";
  static const String sendButtonMessage = "Send";
  static const String saveButtonMessage = "Save";
  static const String seeAllTransactions = "See all transactions";
  static const String shareToOhterApps = "Share to ohter app";
  static const String changeButtonMessage = "Change";
  static const String changeTransferDirectionButtonMessage =
      "Change transfer direction";
  static const String changePasscodeButtonText = "Change passcode";
  static const String changePasswordButtonText = "Change password";
  static const String addFriendButtonText = "Add friend";
  static const String addNewFriendText = "Add new friend";
  static const String onlyOneFieldMustBeCompletedText =
      "Only one field must be completed";
  static const String friendSinceText = "Friends since: ";

  static const String loginAppBarTitle = "Login into your account";
  static const String signupAppBarTitle = "Signup for a DaniVest account";
  static const String homepageAppBarTitle = "DaniVest";
  static const String friendsTitle = "Friends";
  static const String alreadyHasAccount = "Already have an account?";
  static const String forgotMyPassword = "Forgot my password";
  static const String successfulLogout = "You successfully logout";

  static const String hideTheAmount = "Hide the amount";
  static const String showTheAmount = "Show the amount";
  static const String obscuredText = "***";
  static const String defaultCurrency = "RON";
  static const String defaultAmount = "0 $defaultCurrency";
  static const String amountObscured = "$obscuredText $defaultCurrency";
  static const String bankTransferText = "Transfer between bank accounts";
  static const String changeOtherAccount = "Change other account";
  static const String personalDetailsText = "Personal details";
  static const String accountDetailsText = "Account details";
  static const String otherDetailsText = "Other";
  static const String changeMyPasswordText = "Change my password";
  static const String noActivityRecordedText = "No activity recorded";
  static const String sendMoneyText = "Send money";

  static const String cardNumberTitle = "Card Number";
  static const String copyCardNumberTitle = "Copy the card number";
  static const String cvvTitle = "CVV";
  static const String expiryDateTitle = "Expiry date";
  static const String balanceText = "Balance";
  static const String myAccountText = "My account";
  static const String otherAccountText = "Other account";
  static const String transferText = "Transfer";
  static const String sentYouText = "Sent you";
  static const String youSentText = "You sent";
  static const String noneText = "None";

  // Page names
  static const String homepagePageName = "Home";
  static const String transferPageName = "Transfer";
  static const String transactionPageName = "Transactions";
  static const String myAccountPageName = "My account";
  static const String addWithdrawMoneyPageName = "Add/withdraw money";
  static const String shareIbanPageName = "Share IBAN";
  static const String showCardDetailsPageName = "Show card details";
  static const String transferInformation =
      "$defaultCurrency will be transferred from :first to :second";

  // Signup fields
  static const String usernameFieldLabel = "Username";
  static const String usernameFieldHint = "Enter a username";

  static const String emailFieldLabel = "Email";
  static const String emailFieldHint = "Enter your email";

  static const String firstNameFieldLabel = "First name";
  static const String firstNameFieldHint = "Enter your first name";

  static const String lastNameFieldLabel = "Last name";
  static const String lastNameFieldHint = "Enter your last name";

  static const String phoneNumberFieldLabel = "Phone number";
  static const String phoneNumberFieldHint = "Enter your phone number";

  static const String birthdateFieldLabel = "Birthdate";
  static const String birthdateFieldHint = "Enter your birthdate";

  static const String passwordFieldLabel = "Password";
  static const String passwordFieldHint = "Enter a password";

  static const String confirmPasswordFieldLabel = "Confirm Password";
  static const String confirmPasswordFieldHint = "Enter again the password";

  static const String passcodeFieldLabel = "Passcode";
  static const String passcodeFieldHint = "Enter a passcode";

  static const String confirmPasscodeFieldLabel = "Confirm passcode";
  static const String confirmPasscodeFieldHint = "Enter again the passcode";

  static const String amountFieldLabel = "Amount";
  static const String amountFieldHint = "... $defaultCurrency";

  static const String cardNumberFieldLabel = "Card number";
  static const String cardNumberFieldHint = "Enter a card number";

  static const String cvvFieldLabel = "CVV";
  static const String cvvFieldHint = "Enter a CVV";

  static const String expiryDateFieldLabel = "Expiry date";
  static const String expiryDateFieldHint = "Enter a expiry date";

  static const String currentPasswordFieldLabel = "Current password";
  static const String currentPasswordFieldHint = "Enter current password";

  static const String currentPasscodeFieldLabel = "Current passcode";
  static const String currentPasscodeFieldHint = "Enter current passcode";

  static const String ibanFieldLabel = "IBAN";
  static const String ibanFieldHint = "Enter a IBAN";

  static const String detailsFieldLabel = "Details";
  static const String detailsFieldHint = "Enter details";

  static const String messageFieldLabel = "Message";
  static const String messageFieldHint = "Type a message";

  static const String localizedReasonBiometric = "Login to gain access";

  // Generic error
  static const String genericError = "An unknown error has occured.";

  // Signup fields errors
  static const String fieldRequired = "This field is required";
  static const String fieldWithoutSpaces =
      "This field must not contain any spaces";
  static const String fieldWithoutLeadingNumber =
      "This field must not start with a number";
  static const String fieldMinimumLength =
      "This field must have a minimum length of";
  static const String fieldValidEmail =
      "This field must have the 'abc@xyz' format";
  static const String fieldValidName = "This field must be a valid name";
  static const String fieldValidPhoneNumber =
      "This field must be a valid phone number";
  static const String fieldValidDate =
      "This field must have the 'dd/mm/yyyy' date format";
  static const String fieldWithLowercaseLetter =
      "This field must have at least one lowercase character";
  static const String fieldWithUppercaseLetter =
      "This field must have at least one uppercase character";
  static const String fieldWithNumber =
      "This field must have at least one number";
  static const String fieldWithSpecialCharacter =
      "This field must have at least one special character";
  static const String fieldEqualToOtherValue =
      "This field must match the original";
  static const String fieldWithAmount = "This field must be a valid amount";

  // RegExp strings
  static const String nameRegExp = r"^[A-Za-z]+(?:[ -][A-Za-z]+)*$";
  static const String phoneNumberRegExp = r"^\+?[0-9]+$";
  static const String lowercaseLetterRegExp = r"[a-z]";
  static const String uppercaseLetterRegExp = r"[A-Z]";
  static const String numberRegExp = r"[0-9]";
  static const String specialCharacterRegExp = r"[!@#$%^&*()<>{}\|;:<>,]";
  static const String amountRegExp = r"^\d+(\.\d{1,2})?$";

  // Back-end server details
  static const String backendScheme = "http";
  static const String backendHost = "192.168.1.34";
  static const String backendPort = "3000";
  static const String backendURL = "$backendScheme://$backendHost:$backendPort";

  static const String analysisHost = "192.168.1.34"; // or "10.0.2.2"
  static const analysisPort = "8000";
  static const String analysisURL =
      "$backendScheme://$analysisHost:$analysisPort";

  // Resources paths
  static const String createUserPath = "/api/user/create";
  static const String getUserBankAccount = "/api/user/:id/bank";
  static const String getUserOtherBankAccount = "/api/user/:id/bank/other";
  static const String getUserOtherBankAccountByCardDetails =
      "/api/user/:id/bank/other/cardNumber/:cardNumber/cvv/:cvv/expiryDate/:expiryDate";
  static const String updateMePath = "/api/user/updateMe";
  static const String createTransaction = "/api/transaction/create";
  static const String createConversationPath = "/api/conversation/create";
  static const String getUserAllTransactions = "/api/user/:id/transactions";
  static const String getUserAllFriends = "/api/user/:id/friends";
  static const String getUserAllConversations = "/api/user/:id/conversations";
  static const String createNewUserFriendPath = "/api/user/createNewFriend";
  static const String loginUserPath = "/api/auth/login";
  static const String userAuthenticatedPath = "/api/auth/me";
  static const String authPasscodePath = "/api/auth/passcode";
  static const String forgotPasswordPath = "/api/auth/forgotPassword";
  static const String resetPasswordPath = "/api/auth/resetPassword";
  static const String updateMyPasswordPath = "/api/auth/updateMyPassword";
  static const String updateMyPasscodePath = "/api/auth/updateMyPasscode";
  static const String createKeyPressEventPath = "/api/keypressevent/create";
  static const String createOneFingerTouchEventPath =
      "/api/onefingertouchevent/create";
  static const String createTouchEventPath = "/api/touchevent/create";
  static const String createScrollEventPath = "/api/scrollevent/create";
  static const String createStrokeEventPath = "/api/strokeevent/create";

  static const String latestPredictionsPath = "/latest-predictions";

  // Standard response field names
  static const String responseMessageFieldName = "message";
  static const String responseDataFieldName = "data";
  static const String androidIntentHost = "resetpassword";

  static const String endOfPage =
      "You have gracefully arrived at the concluding boundary of this document. At this juncture, there remains no further content to traverse, no additional information to peruse, and no extended sections to engage with beyond this point. It is, therefore, with a sense of completion and finality that we convey to you that the entirety of the presented material has now been fully revealed. Should you wish to revisit any portion of the content, we encourage you to scroll upward at your leisure. Otherwise, we extend our sincere appreciation for your attention, patience, and thoughtful engagement throughout your journey to this terminus.";
}

class Properties {
  static const double buttonPadding = 50;
  static const double textButtonPadding = 5;
  static const double containerHorizontalMargin = 50;
  static const double containerVerticalMargin = 50;
  static const double listVerticalMargin = 10;
  static const double sizedBoxHeight = 50;
  static const double sizedBoxWidth = 5;
  static const double amountFieldWidth = 70;
  static const double columnSpacing = 10;
  static const double fontSizeMainTitle = 54;
  static const double fontSizeMainText = 20;
  static const double fontSizeMediumText = 15;
  static const double fonstSizeSmallText = 10;
  static const double iconSize = 20;
  static const double largeIconSize = 40;
  static const double rowPadding = 15;

  static const int minimumBirthdateYear = 1920;
  static const int minimumUsernameFieldLength = 6;
  static const int minimumEmailFieldLength = 3;
  static const int minimumFirstNameFieldLength = 3;
  static const int minimumLastNameFieldLength = 3;
  static const int minimumPhoneNumberFieldLength = 10;
  static const int minimumBirthdateFieldLength = 10;
  static const int minimumPasswordFieldLength = 8;
  static const int maximumListPreviewNumber = 4;
  static const int homePageIndex = 0;
  static const int transferPageIndex = 1;
  static const int addWithdrawMoneyPageIndex = 2;
  static const int transactionPageIndex = 3;
  static const int myAccountPageIndex = 4;
  static const int timerSeconds = 1;
  static int appStartEpochMillis = DateTime.now().millisecondsSinceEpoch;
  static const int secondsBeforeSentToDb = 2;
}
