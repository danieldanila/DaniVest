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
  static const String or = "OR";
  static const String success = "Success";

  static const String loginButtonMessage = "Login";
  static const String signupButtonMessage = "Signup";
  static const String logoutButtonMessage = "Logout";
  static const String sendButtonMessage = "Send";
  static const String seeAllTransactions = "See all transactions";

  static const String loginAppBarTitle = "Login into your account";
  static const String signupAppBarTitle = "Signup for a DaniVest account";
  static const String homepageAppBarTitle = "DaniVest";
  static const String alreadyHasAccount = "Already have an account?";
  static const String forgotMyPassword = "Forgot my password";
  static const String successfulLogout = "You successfully logout";

  static const String hideTheAmount = "Hide the amount";
  static const String showTheAmount = "Show the amount";
  static const String defaultCurrency = "RON";
  static const String defaultAmount = "0 $defaultCurrency";
  static const String amountObscured = "***** $defaultCurrency";

  // Page names
  static const String homepagePageName = "Home";
  static const String transferPageName = "Transfer";
  static const String transactionPageName = "Transactions";
  static const String myAccountPageName = "My account";
  static const String addWithdrawMoneyPageName = "Add/withdraw money";
  static const String shareIbanPageName = "Share IBAN";
  static const String showCardDetailsPageName = "Show card details";

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

  // RegExp strings
  static const String nameRegExp = r"^[A-Za-z]+(?:[ -][A-Za-z]+)*$";
  static const String phoneNumberRegExp = r"^\+?[0-9]+$";
  static const String lowercaseLetterRegExp = r"[a-z]";
  static const String uppercaseLetterRegExp = r"[A-Z]";
  static const String numberRegExp = r"[0-9]";
  static const String specialCharacterRegExp = r"[!@#$%^&*()<>{}\|;:<>,]";

  // Back-end server details
  static const String backendScheme = "http";
  static const String backendHost = "192.168.1.36";
  static const String backendPort = "3000";
  static const String backendURL = "$backendScheme://$backendHost:$backendPort";

  // Resources paths
  static const String createUserPath = "/api/user/create";
  static const String getUserBankAccount = "/api/user/:id/bank";
  static const String getUserAllTransactions = "/api/user/:id/transactions";
  static const String loginUserPath = "/api/auth/login";
  static const String userAuthenticatedPath = "/api/auth/me";
  static const String authPasscodePath = "/api/auth/passcode";
  static const String forgotPasswordPath = "/api/auth/forgotPassword";
  static const String resetPasswordPath = "/api/auth/resetPassword";

  // Standard response field names
  static const String responseMessageFieldName = "message";
  static const String androidIntentHost = "resetpassword";
}

class Properties {
  static const double buttonPadding = 50;
  static const double containerHorizontalMargin = 50;
  static const double containerVerticalMargin = 50;
  static const double sizedBoxHeight = 50;
  static const double sizedBoxWidth = 5;
  static const double columnSpacing = 10;
  static const double fontSizeMainTitle = 54;
  static const int minimumBirthdateYear = 1920;
  static const int minimumUsernameFieldLength = 6;
  static const int minimumEmailFieldLength = 3;
  static const int minimumFirstNameFieldLength = 3;
  static const int minimumLastNameFieldLength = 3;
  static const int minimumPhoneNumberFieldLength = 10;
  static const int minimumBirthdateFieldLength = 10;
  static const int minimumPasswordFieldLength = 8;
  static const int maximumListPreviewNumber = 4;
  static const int transactionPageIndex = 3;
}
