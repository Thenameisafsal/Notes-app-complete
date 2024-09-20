// import 'package:flutter/material.dart';
import 'package:notes/services/auth/auth_exceptions.dart';
import 'package:notes/services/auth/auth_provider.dart';
import 'package:notes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  // group all the unit tests together
  group("unit tests", () {
    final provider = MockAuthProvider();
    test('should not be initialized to begin with', () {
      expect(provider.isInitialized, false);
    }); // make sure it is not initialized in beginning

    test("can't logout if not initialized", () {
      expect(provider.logout(),
          throwsA(const TypeMatcher<NotInitializedException>()));
    });

    test("is the initializer working?", () async {
      await provider.startService(); // call initializer
      expect(provider.isInitialized, true); // make sure it is true
    });

    test("user to be null after initialization", () {
      expect(provider.currentUser, null); // current user to be null
    });

    test("Should be able to initialize within 2 seconds", () async {
      await provider.startService(); // initialize
      expect(provider.isInitialized, true);
    },
        timeout:
            const Timeout(Duration(seconds: 2))); // set timeout to 2 seconds

    test("create user should delegate to login function",() async{
      final badUser = provider.createUser(email:"foo@bar.com",password:"somepassword");
      expect(badUser,throwsA(const TypeMatcher<UserNotFoundAuthException>()));
      final badPassword = provider.createUser(email: "someone@gmail.com", password: "foobarbaz");
      expect(badPassword,throwsA(const TypeMatcher<InvalidPasswordAuthException>()));
      final user = await provider.createUser(email: "bar", password: "baz");
      expect(provider.currentUser,user); // make sure current user is the user who logged in
      expect(user.isEmailVerified,false); // user should not be verified now
    });

    test("user should be able to verify after login",() async{
      await provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user,isNotNull); // user shouldn't be null
      expect(user!.isEmailVerified,true); // user to be verified
    });
// note that the expect function will check for synchronous results only, if you provide asynchronous results it will fail
    test("should be able to login after logout",() async{
      await provider.logout();
      await provider.login(email: 'email', password: 'password');
      final user = provider.currentUser;
      expect(user,isNotNull); // if user is logged in he won't be null
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized; // getter
  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) async {
    if (!isInitialized) throw NotInitializedException();
    if(email == "foo@bar.com") throw UserNotFoundAuthException();
    if(password == "foobarbaz") throw InvalidPasswordAuthException();
    await Future.delayed(const Duration(
        seconds: 2)); // create an effect to mimic the backend connection time
    return login(
        email: email, password: password); // login the user for simplicity
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<AuthUser> login({required String email, required String password}) {
    if (!isInitialized) throw NotInitializedException();
    if(email == "foo@bar.com") throw UserNotFoundAuthException();
    if(password == "foobarbaz") throw InvalidPasswordAuthException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logout() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true); // verify the guy
    _user = newUser;
  }

  @override
  Future<void> startService() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }
}
