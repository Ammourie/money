import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slim_starter_application/core/common/validators.dart';
import 'package:slim_starter_application/features/account/model/response/user_model.dart';
import 'package:slim_starter_application/features/home/view/app_main_view.dart';
import 'dart:async';
import 'dart:developer';

import '../../../core/common/view_model/base_view_model.dart';
import '../../../core/navigation/nav.dart';
import '../view/auth_view.dart';

class AuthViewModel extends BaseViewModel<AuthViewParam> {
  AuthViewModel(super.param);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  String? _errorMessage;
  User? _user;
  UserModel? _userData;
  StreamSubscription<DocumentSnapshot>? _userDataSubscription;
  bool _isObscurePassword = true;

  // Form controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // State variables
  bool _isAdmin = false;
  bool _isRegistrationComplete = false;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;
  UserModel? get userData => _userData;
  bool get isAdmin => _isAdmin;
  bool get isRegistrationComplete => _isRegistrationComplete;
  bool get isObscurePassword => _isObscurePassword;

  void init() {
    // Check if user is already signed in
    _user = _auth.currentUser;

    if (_user != null) {
      _setupUserDataListener();
    }
  }

  void _setupUserDataListener() {
    // Listen for real-time updates to user data
    _userDataSubscription = _firestore
        .collection('pro_users')
        .doc(_user!.uid)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        _userData = UserModel.fromFirestore(snapshot);
        fullNameController.text = _userData!.fullName;
        _isAdmin = _userData!.isAdmin;
        phoneController.text = _userData!.phoneNumber ?? '';
        _isRegistrationComplete = true;
        _isLoading = false;
        notifyListeners();

        // Navigate to home screen when profile is complete
        _navigateToHomeIfProfileComplete();
      } else if (_user!.displayName != null) {
        // New user, pre-fill with Google data
        fullNameController.text = _user!.displayName!;
        _isRegistrationComplete = false;
        _isLoading = false;
        notifyListeners();
      } else {
        // No data and no display name
        _isLoading = false;
        notifyListeners();
      }
    }, onError: (error) {
      _errorMessage = 'Error loading user data: $error';
      _isLoading = false;
      notifyListeners();
    });
  }

  // Method to navigate to home screen if profile is complete
  void _navigateToHomeIfProfileComplete() {
    if (_isRegistrationComplete && _userData != null) {
      // Use the BuildContext from your param to navigate
      // Assuming param.context is accessible or you have another way to get the context
      Nav.to(AppMainView.routeName, arguments: AppMainViewParam());
      // OR use your navigation service if you have one
      // param.navigationService.navigateToReplacement('/home');
    }
  }

  Future<void> signInWithGoogle() async {
    log('Starting Google Sign-In process', name: 'firebase-log');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Trigger the Google Sign-In flow
      log('Triggering Google Sign-In flow', name: 'firebase-log');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in flow
        log('Google Sign-In canceled by user', name: 'firebase-log');
        _isLoading = false;
        _errorMessage = 'Sign in canceled';
        notifyListeners();
        return;
      }

      log('Google Sign-In successful for user: ${googleUser.email}',
          name: 'firebase-log');

      // Obtain the auth details from the request
      log('Obtaining auth details', name: 'firebase-log');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential for Firebase
      log('Creating Firebase credential', name: 'firebase-log');
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      log('Signing in to Firebase with Google credential',
          name: 'firebase-log');
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      log('Firebase sign-in successful for user: ${userCredential.user?.uid}',
          name: 'firebase-log');
      _user = userCredential.user;
      notifyListeners();

      // Setup listener for user data
      log('Setting up user data listener', name: 'firebase-log');
      _setupUserDataListener();

      // Check if user exists in Firestore
      final userDoc =
          await _firestore.collection('pro_users').doc(_user!.uid).get();
      if (!userDoc.exists && _user!.displayName != null) {
        // If user doesn't exist in Firestore but has a display name, pre-fill form
        fullNameController.text = _user!.displayName!;
        _isRegistrationComplete = false;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      log('Sign-in error: $e', name: 'firebase-log');
      _isLoading = false;
      _errorMessage = 'Sign in failed: ${e.toString()}';
      notifyListeners();
    } finally {
      // Ensure loading state is reset even if there's an unhandled exception
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      _userDataSubscription?.cancel();
      await _auth.signOut();
      await _googleSignIn.signOut();

      _user = null;
      _isLoading = false;
      _isRegistrationComplete = false;
      _userData = null;
      fullNameController.clear();
      phoneController.clear();
      _isAdmin = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Sign out failed: ${e.toString()}';
      notifyListeners();
    }
  }

  String? validateFullName(String? value) {
    if (!Validators.isValidFullName(value)) {
      return 'Please enter your full name';
    }

    return null;
  }

  String? validatePhone(String? value) {
    if ((value?.isEmpty ?? true)) return null;
    if (!Validators.isValidPhoneNumber(value)) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  Future<void> completeRegistration() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Create user model
      final newUser = UserModel(
        uid: _user!.uid,
        email: _user!.email!,
        fullName: fullNameController.text.trim(),
        isAdmin: _isAdmin,
        photoURL: _user!.photoURL,
        phoneNumber: phoneController.text.trim().isEmpty
            ? null
            : phoneController.text.trim(),
      );

      // Save user data to Firestore
      await _firestore.collection('pro_users').doc(_user!.uid).set({
        ...newUser.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      _isRegistrationComplete = true;
      _userData = newUser;
      _isLoading = false;
      notifyListeners();

      // Navigate to home after successful registration
      _navigateToHomeIfProfileComplete();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Registration failed: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> updateUserData() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Update user data in Firestore
      await _firestore.collection('pro_users').doc(_user!.uid).update({
        'fullName': fullNameController.text.trim(),
        'isAdmin': _isAdmin,
        'phoneNumber': phoneController.text.trim().isEmpty
            ? null
            : phoneController.text.trim(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      // Update local userData model with new values
      if (_userData != null) {
        _userData = _userData!.copyWith(
          fullName: fullNameController.text.trim(),
          isAdmin: _isAdmin,
          phoneNumber: phoneController.text.trim().isEmpty
              ? null
              : phoneController.text.trim(),
        );
      }

      _isRegistrationComplete = true;
      _isLoading = false;
      notifyListeners();

      // Navigate to home after successful profile update
      _navigateToHomeIfProfileComplete();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Update failed: ${e.toString()}';
      notifyListeners();
    }
  }

  void setAdmin(bool value) {
    _isAdmin = value;
    notifyListeners();
  }

  void setRegistrationComplete(bool value) {
    _isRegistrationComplete = value;
    notifyListeners();
  }

  @override
  void closeModel() {
    fullNameController.dispose();
    phoneController.dispose();
    _userDataSubscription?.cancel();
    super.dispose();
  }
}
