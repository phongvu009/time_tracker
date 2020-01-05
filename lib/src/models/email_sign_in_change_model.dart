import 'package:flutter/foundation.dart';
import 'package:time_tracker/src/models/email_sign_in_model.dart';
import 'package:time_tracker/src/screens/sign_in/validator.dart';
import 'package:time_tracker/src/services/auth.dart';



class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;
  final AuthBase auth;

  EmailSignInChangeModel({
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
    @required this.auth,
  });

  String get primaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Sign In'
        : 'Create an account';
  }

  String get secondaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Need an account ? Register'
        : 'Have an account ? Sign in';
  }
  
  void toggleFormType() {
    final formType = this.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
      email: '',
      password: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  void updateEmail(String email) {
    updateWith(email: email);
  }

  void updatePassword(String password) => updateWith(password: password);

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(
            email, password);
      } else {
        await auth.createUserWithEmailAndPassword(
            email, password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    } 
  }


  bool get canSubmit {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  String get emailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailError : null;
  }

  String get passwordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordError : null;
  }

  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    
      this.email = email ?? this.email;
      this.password = password ?? this.password;
      this.formType = formType ?? this.formType;
      this.isLoading =  isLoading ?? this.isLoading;
      this.submitted = submitted ?? this.submitted;
      notifyListeners( );
  }
}