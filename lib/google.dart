import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> authenticateWithGoogle() async {
  try {
    // Initialize Google Sign-In
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
    );

    // Trigger Google authentication flow
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    
    if (googleUser == null) {
      throw Exception('Google sign-in cancelled');
    }

    // Get authentication tokens
    final GoogleSignInAuthentication googleAuth = 
        await googleUser.authentication;

    // Prepare auth data for Parse
    final authData = {
      'id': googleUser.id,
      'id_token': googleAuth.idToken,
      'access_token': googleAuth.accessToken,
    };

    // Log in to Parse with Google credentials
    final ParseUser user = await ParseUser.loginWith(
      'google',
      authData,
    ) as ParseUser;

    print('Logged in user: ${user.username}');
    print('User objectId: ${user.objectId}');
  } catch (e) {
    print('Google login failed: $e');
    // Handle specific error types
    if (e is ParseError) {
      print('Parse error code: ${e.code} - ${e.message}');
    }
  }
}