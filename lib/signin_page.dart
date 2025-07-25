// import 'package:flutter/material.dart';
// import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:test_app/welcome_page.dart';

// class SigninPage extends StatefulWidget {
//   const SigninPage({super.key});

//   @override
//   State<SigninPage> createState() => _SigninPageState();
// }

// class _SigninPageState extends State<SigninPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _isLoading = false;
//   bool _isGoogleLoading = false;

//   // Initialize Google Sign In
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     scopes: ['email', 'profile'],
//   );

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _signIn() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final user = ParseUser(
//         _emailController.text.trim(), 
//         _passwordController.text,
//         _emailController.text.trim(),
//       );

//       final response = await user.login();

//       if (response.success) {
//         final loggedInUser = response.result as ParseUser?;
//         final displayName = loggedInUser?.get('email') ?? 
//                            loggedInUser?.username ?? 
//                            _emailController.text.trim();
        
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (context) => WelcomePage(username: displayName),
//           ),
//         );
//       } else {
//         _showDialog('Login Failed', response.error?.message ?? 'Login failed.');
//       }
//     } catch (e) {
//       _showDialog('Error', 'An unexpected error occurred: $e');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _signInWithGoogle() async {
//     setState(() {
//       _isGoogleLoading = true;
//     });

//     try {
//       // Trigger the authentication flow
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
//       if (googleUser == null) {
//         // User canceled the sign-in
//         setState(() {
//           _isGoogleLoading = false;
//         });
//         return;
//       }

//       // Obtain the auth details from the request
//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

//       // Try to login directly with Google email as username
//       // This assumes users signed up with email as username
//       final user = ParseUser(googleUser.email, '', googleUser.email);
      
//       // Attempt login - if user exists, this will succeed
//       final loginResponse = await user.login();
      
//       if (loginResponse.success) {
//         // Login successful
//         final loggedInUser = loginResponse.result as ParseUser?;
//         final displayName = loggedInUser?.get('displayName') ?? 
//                            loggedInUser?.get('email') ?? 
//                            loggedInUser?.username ?? 
//                            googleUser.displayName ?? 
//                            googleUser.email;
        
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (context) => WelcomePage(username: displayName),
//           ),
//         );
//       } else {
//         // Login failed - user doesn't exist or wrong credentials
//         if (loginResponse.error?.code == 101) {
//           // Invalid username/password - user doesn't exist
//           _showDialog('Account Not Found', 
//             'No account found with this Google email. Please sign up first or use a different login method.');
//         } else {
//           // Other login error
//           throw Exception(loginResponse.error?.message ?? 'Login failed');
//         }
//       }

//     } catch (error) {
//       _showDialog('Google Sign-In Error', 'Failed to sign in with Google: $error');
//     } finally {
//       setState(() {
//         _isGoogleLoading = false;
//       });
//     }
//   }

//   void _showDialog(String title, String message, {bool isSuccess = false}) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(title),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sign In'),
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const Text(
//                 'Welcome Back',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 32),
              
//               // Google Sign In Button
//               Container(
//                 height: 50,
//                 margin: const EdgeInsets.only(bottom: 16),
//                 child: ElevatedButton.icon(
//                   onPressed: _isGoogleLoading ? null : _signInWithGoogle,
//                   icon: _isGoogleLoading 
//                     ? const SizedBox(
//                         height: 20,
//                         width: 20,
//                         child: CircularProgressIndicator(strokeWidth: 2))
//                     : Image.asset(
//                         'assets/images/google_logo.png', // You'll need to add this asset
//                         height: 24,
//                         width: 24,
//                         errorBuilder: (context, error, stackTrace) => const Icon(Icons.login),
//                       ),
//                   label: Text(_isGoogleLoading ? 'Signing in...' : 'Continue with Google'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     foregroundColor: Colors.black87,
//                     side: const BorderSide(color: Colors.grey),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                 ),
//               ),
              
//               // Divider
//               const Row(
//                 children: [
//                   Expanded(child: Divider()),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 16),
//                     child: Text('OR'),
//                   ),
//                   Expanded(child: Divider()),
//                 ],
//               ),
//               const SizedBox(height: 16),

//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.email),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your email';
//                   }
//                   if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//                     return 'Please enter a valid email';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _passwordController,
//                 obscureText: true,
//                 decoration: const InputDecoration(
//                   labelText: 'Password',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.lock),
//                 ),
//                 validator: (value) =>
//                     value == null || value.isEmpty ? 'Enter your password' : null,
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: _isLoading ? null : _signIn,
//                 child: _isLoading
//                     ? const SizedBox(
//                         height: 20,
//                         width: 20,
//                         child: CircularProgressIndicator(strokeWidth: 2))
//                     : const Text('Sign In'),
//               ),
//               const SizedBox(height: 16),
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(); 
//                 },
//                 child: const Text("Don't have an account? Sign Up"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test_app/welcome_page.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  // Initialize Google Sign In
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = ParseUser(
        _emailController.text.trim(), 
        _passwordController.text,
        _emailController.text.trim(),
      );

      final response = await user.login();

      if (response.success) {
        final loggedInUser = response.result as ParseUser?;
        final displayName = loggedInUser?.get('email') ?? 
                           loggedInUser?.username ?? 
                           _emailController.text.trim();
        
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => WelcomePage(username: displayName),
          ),
        );
      } else {
        _showDialog('Login Failed', response.error?.message ?? 'Login failed.');
      }
    } catch (e) {
      _showDialog('Error', 'An unexpected error occurred: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isGoogleLoading = true;
    });

    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // User canceled the sign-in
        setState(() {
          _isGoogleLoading = false;
        });
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Use Parse's third-party authentication for Google
      final authData = {
        'google': {
          'id': googleUser.id,
          'access_token': googleAuth.accessToken,
          'id_token': googleAuth.idToken,
        }
      };

      final user = ParseUser(null, null, googleUser.email);
      user.set('authData', authData);

      // Login with Google auth data
      final loginResponse = await ParseUser.loginWith('google', authData);
      
      if (loginResponse.success) {
        // Login successful
        final loggedInUser = loginResponse.result as ParseUser?;
        final displayName = loggedInUser?.get('displayName') ?? 
                           loggedInUser?.get('email') ?? 
                           loggedInUser?.username ?? 
                           googleUser.displayName ?? 
                           googleUser.email;
        
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => WelcomePage(username: displayName),
          ),
        );
      } else {
        // Login failed - user doesn't exist
        if (loginResponse.error?.code == 101 || loginResponse.error?.code == 203) {
          // User doesn't exist or linked account not found
          _showDialog('Account Not Found', 
            'No account found with this Google email. Please sign up first or use a different login method.');
        } else {
          // Other login error
          throw Exception(loginResponse.error?.message ?? 'Login failed');
        }
      }

    } catch (error) {
      _showDialog('Google Sign-In Error', 'Failed to sign in with Google: $error');
    } finally {
      setState(() {
        _isGoogleLoading = false;
      });
    }
  }

  void _showDialog(String title, String message, {bool isSuccess = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome Back',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              // Google Sign In Button
              Container(
                height: 50,
                margin: const EdgeInsets.only(bottom: 16),
                child: ElevatedButton.icon(
                  onPressed: _isGoogleLoading ? null : _signInWithGoogle,
                  icon: _isGoogleLoading 
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : Image.asset(
                        'assets/images/google_logo.png', // You'll need to add this asset
                        height: 24,
                        width: 24,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.login),
                      ),
                  label: Text(_isGoogleLoading ? 'Signing in...' : 'Continue with Google'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              
              // Divider
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('OR'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your password' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _signIn,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Sign In'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); 
                },
                child: const Text("Don't have an account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}