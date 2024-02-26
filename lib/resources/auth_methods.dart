import 'package:dio/dio.dart';
import 'package:event_scheduler_project/models/user.dart';

class AuthMethods {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  // Future<model.User> getUserDetails() async {
  //   User currentUser = _auth.currentUser!;

  //   DocumentSnapshot documentSnapshot =
  //       await _firestore.collection('users').doc(currentUser.uid).get();

  //   return model.User.fromSnap(documentSnapshot);
  // }

  // Signing Up User

  // Future<String> signUpUser({
  //   required String email,
  //   required String password,
  // }) async {
  //   String res = "Some error Occurred";
  //   try {
  //     if (email.isNotEmpty || password.isNotEmpty) {
  //       // registering user in auth with email and password
  //       UserCredential cred = await _auth.createUserWithEmailAndPassword(
  //         email: email,
  //         password: password,
  //       );

  //       model.User user = model.User(
  //         email: email,
  //         uid: cred.user!.uid,
  //         myEvents: [],
  //       );

  //       // adding user in our database
  //       await _firestore
  //           .collection("users")
  //           .doc(cred.user!.uid)
  //           .set(user.toJson());

  //       res = "success";
  //     } else {
  //       res = "Please enter all the fields";
  //     }
  //   } catch (err) {
  //     return err.toString();
  //   }
  //   return res;
  // }
  Future<User> signUp({
    required String password,
    required String username,
    required String name,
    required String surname,
  }) async {
    try {
      if (name.isNotEmpty && password.isNotEmpty && username.isNotEmpty) {
        Dio dio = Dio();
        final response = await dio.post(
          'http://192.168.0.11:8080/api/user/register',
          data: {
            'username': username,
            'password': password,
            'name': name,
            'surname': surname,
          },
        );

        if (response.statusCode == 200) {
          print(response.data);
          User user = User.fromJson(response.data);
          return user;
        } else {
          throw Exception("Signup failed");
        }
      } else {
        throw Exception("Email, password, and username cannot be empty");
      }
    } catch (error) {
      throw Exception("Error occurred during signup: $error");
    }
  }

  // logging in user
  Future<User> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        Dio dio = Dio();
        final response = await dio.post(
          'http://192.168.0.11:8080/api/user/login',
          data: {
            'username': email,
            'password': password,
          },
        );
        if (response.statusCode == 200) {
          print(response
              .data); // Print response from server (for debugging purposes;
          User user = User.fromJson(response.data);
          return user; // Return user if login is successful
        } else {
          throw Exception("Login failed"); // Throw an exception if login fails
        }
      } else {
        throw Exception("Email and password cannot be empty");
      }
    } catch (error) {
      throw Exception("Error occurred during login: $error");
    }
  }
}
