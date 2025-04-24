import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:developer';

import '../../../core/ui/screens/base_view.dart';

class AuthViewParam {}

class AuthView extends BaseView<AuthViewParam> {
  const AuthView({required AuthViewParam param, Key? key})
      : super(param: param, key: key);
  static const routeName = "/AuthView";
  @override
  _AuthViewState createState() => _AuthViewState();
}

class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final bool isAdmin;
  final String? photoURL;
  final DateTime? lastUpdated;
  final DateTime? createdAt;
  final String? phoneNumber;
  final String? department;

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.isAdmin,
    this.photoURL,
    this.lastUpdated,
    this.createdAt,
    this.phoneNumber,
    this.department,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      isAdmin: data['isAdmin'] ?? false,
      photoURL: data['photoURL'],
      lastUpdated: data['lastUpdated']?.toDate(),
      createdAt: data['createdAt']?.toDate(),
      phoneNumber: data['phoneNumber'],
      department: data['department'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'isAdmin': isAdmin,
      'photoURL': photoURL,
      'lastUpdated': FieldValue.serverTimestamp(),
      'phoneNumber': phoneNumber,
      'department': department,
    };
  }

  UserModel copyWith({
    String? fullName,
    bool? isAdmin,
    String? phoneNumber,
    String? department,
  }) {
    return UserModel(
      uid: this.uid,
      email: this.email,
      fullName: fullName ?? this.fullName,
      isAdmin: isAdmin ?? this.isAdmin,
      photoURL: this.photoURL,
      lastUpdated: DateTime.now(),
      createdAt: this.createdAt,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      department: department ?? this.department,
    );
  }
}

class _AuthViewState extends State<AuthView> {
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
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  // State variables
  bool _isAdmin = false;
  bool _isRegistrationComplete = false;
  List<String> departments = ['IT', 'Marketing', 'Sales', 'Finance', 'HR', 'Other'];

  @override
  void initState() {
    super.initState();
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
        setState(() {
          _userData = UserModel.fromFirestore(snapshot);
          _fullNameController.text = _userData!.fullName;
          _isAdmin = _userData!.isAdmin;
          _phoneController.text = _userData!.phoneNumber ?? '';
          _departmentController.text = _userData!.department ?? '';
          _isRegistrationComplete = true;
          _isLoading = false; // Ensure loading is turned off when data is loaded
        });
      } else if (_user!.displayName != null) {
        // New user, pre-fill with Google data
        setState(() {
          _fullNameController.text = _user!.displayName!;
          _isRegistrationComplete = false;
          _isLoading = false; // Ensure loading is turned off
        });
      } else {
        // No data and no display name
        setState(() {
          _isLoading = false; // Ensure loading is turned off
        });
      }
    }, onError: (error) {
      setState(() {
        _errorMessage = 'Error loading user data: $error';
        _isLoading = false; // Ensure loading is turned off on error
      });
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _departmentController.dispose();
    _userDataSubscription?.cancel();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    log('Starting Google Sign-In process',name:'firebase-log');
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Trigger the Google Sign-In flow
      log('Triggering Google Sign-In flow',name:'firebase-log');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in flow
        log('Google Sign-In canceled by user',name:'firebase-log');
        setState(() {
          _isLoading = false;
          _errorMessage = 'Sign in canceled';
        });
        return;
      }

      log('Google Sign-In successful for user: ${googleUser.email}',name:'firebase-log');
      
      // Obtain the auth details from the request
      log('Obtaining auth details',name:'firebase-log');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential for Firebase
      log('Creating Firebase credential',name:'firebase-log');
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      log('Signing in to Firebase with Google credential',name:'firebase-log');
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      log('Firebase sign-in successful for user: ${userCredential.user?.uid}',name:'firebase-log');
      setState(() {
        _user = userCredential.user;
      });
      
      // Setup listener for user data
      log('Setting up user data listener',name:'firebase-log');
      _setupUserDataListener();
      
      // Check if user exists in Firestore
      final userDoc = await _firestore.collection('pro_users').doc(_user!.uid).get();
      if (!userDoc.exists && _user!.displayName != null) {
        // If user doesn't exist in Firestore but has a display name, pre-fill form
        setState(() {
          _fullNameController.text = _user!.displayName!;
          _isRegistrationComplete = false;
          _isLoading = false;
        });
      }
      
    } catch (e) {
      log('Sign-in error: $e',name:'firebase-log');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Sign in failed: ${e.toString()}';
      });
    } finally {
      // Ensure loading state is reset even if there's an unhandled exception
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signOut() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _userDataSubscription?.cancel();
      await _auth.signOut();
      await _googleSignIn.signOut();

      setState(() {
        _user = null;
        _isLoading = false;
        _isRegistrationComplete = false;
        _userData = null;
        _fullNameController.clear();
        _phoneController.clear();
        _departmentController.clear();
        _isAdmin = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Sign out failed: ${e.toString()}';
      });
    }
  }

  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }
    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value != null && value.isNotEmpty) {
      if (!RegExp(r'^\d{10}$').hasMatch(value)) {
        return 'Please enter a valid 10-digit phone number';
      }
    }
    return null;
  }

  Future<void> _completeRegistration() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Create user model
      final newUser = UserModel(
        uid: _user!.uid,
        email: _user!.email!,
        fullName: _fullNameController.text.trim(),
        isAdmin: _isAdmin,
        photoURL: _user!.photoURL,
        phoneNumber: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
        department: _departmentController.text.trim().isEmpty ? null : _departmentController.text.trim(),
      );

      // Save user data to Firestore
      await _firestore.collection('pro_users').doc(_user!.uid).set({
        ...newUser.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration completed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      setState(() {
        _isRegistrationComplete = true;
        _isLoading = false;
      });
      
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Registration failed: ${e.toString()}';
      });
    }
  }

  Future<void> _updateUserData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Update user data in Firestore
      await _firestore.collection('pro_users').doc(_user!.uid).update({
        'fullName': _fullNameController.text.trim(),
        'isAdmin': _isAdmin,
        'phoneNumber': _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
        'department': _departmentController.text.trim().isEmpty ? null : _departmentController.text.trim(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      setState(() {
        _isRegistrationComplete = true;
      });
      
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Update failed: ${e.toString()}';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Update failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Registration'),
        actions: _user != null && _isRegistrationComplete
            ? [
                IconButton(
                  icon: const Icon(Icons.exit_to_app),
                  onPressed: _signOut,
                  tooltip: 'Sign Out',
                ),
              ]
            : null,
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Please wait...'),
                ],
              ),
            )
          : _user != null
              ? _isRegistrationComplete 
                  ? _buildUserInfoScreen() 
                  : _buildRegistrationForm()
              : _buildSignInScreen(),
    );
  }

  Widget _buildUserInfoScreen() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  if (_user?.photoURL != null)
                    CircleAvatar(
                      backgroundImage: NetworkImage(_user!.photoURL!),
                      radius: 60,
                    )
                  else
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/default_avatar.png'),
                      radius: 60,
                    ),
                  const SizedBox(height: 20),
                  Text(
                    _userData?.fullName ?? 'User',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    _userData?.email ?? '',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Account Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _infoTile('Role', _userData?.isAdmin == true ? 'Administrator' : 'Regular User'),
            if (_userData?.department != null)
              _infoTile('Department', _userData!.department!),
            if (_userData?.phoneNumber != null)
              _infoTile('Phone', _userData!.phoneNumber!),
            if (_userData?.createdAt != null)
              _infoTile('Account Created', _formatDate(_userData!.createdAt!)),
            if (_userData?.lastUpdated != null)
              _infoTile('Last Updated', _formatDate(_userData!.lastUpdated!)),
            const SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _isRegistrationComplete = false;
                      });
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 45),
                    ),
                  ),
                  const SizedBox(height: 15),
                  OutlinedButton.icon(
                    onPressed: _signOut,
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign Out'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(200, 45),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildRegistrationForm() {
    final bool isNewUser = _userData == null;
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Column(
                  children: [
                    if (_user?.photoURL != null)
                      CircleAvatar(
                        backgroundImage: NetworkImage(_user!.photoURL!),
                        radius: 60,
                      ),
                    const SizedBox(height: 20),
                    Text(
                      isNewUser ? 'Complete Your Registration' : 'Edit Profile',
                      style: const TextStyle(
                        fontSize: 22, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _user?.email ?? '',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: _validateFullName,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number (Optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: _validatePhone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _departmentController.text.isEmpty ? null : _departmentController.text,
                decoration: InputDecoration(
                  labelText: 'Department (Optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.business),
                ),
                items: departments.map((String department) {
                  return DropdownMenuItem<String>(
                    value: department,
                    child: Text(department),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    _departmentController.text = newValue;
                  }
                },
              ),
              const SizedBox(height: 20),
              ListTile(
                title: const Text('Administrator Access'),
                subtitle: const Text('Grant administrator privileges to this account'),
                leading: const Icon(Icons.admin_panel_settings),
                trailing: Switch(
                  value: _isAdmin,
                  onChanged: (bool value) {
                    setState(() {
                      _isAdmin = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: isNewUser ? _completeRegistration : _updateUserData,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  isNewUser ? 'Complete Registration' : 'Update Profile',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: isNewUser 
                    ? _signOut 
                    : () {
                        setState(() {
                          _isRegistrationComplete = true;
                        });
                      },
                child: Text(isNewUser ? 'Cancel and Sign Out' : 'Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignInScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.account_circle,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 30),
            const Text(
              'Welcome',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Sign in to continue to the application',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.red),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ElevatedButton.icon(
              icon: Image.network(
                'https://www.citypng.com/public/uploads/preview/google-logo-icon-gsuite-hd-701751694791470gzbayltphh.png',
                height: 24.0,
              ),
              label: const Text('Sign in with Google'),
              onPressed: _signInWithGoogle,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // TODO: Implement other authentication methods if needed
              },
              child: const Text('Other Sign In Options'),
            ),
          ],
        ),
      ),
    );
  }
}