import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  Future signUp({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future signIn({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    print('iiiiiiiiii');
  }
}
