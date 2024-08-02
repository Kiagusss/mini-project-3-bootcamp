import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:mini_project_3_bootcamp/model/profile_model.dart';

class ProfileRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final Logger logger;

  ProfileRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    Logger? logger,
  })  : firestore = firestore ?? FirebaseFirestore.instance,
        auth = auth ?? FirebaseAuth.instance,
        logger = logger ?? Logger();

  Future<Profile> fetchProfile() async {
    User? user = auth.currentUser;
    logger.d("Current user: $user");

    if (user == null) {
      throw Exception('User not logged in');
    }

    try {
      DocumentSnapshot doc = await firestore.collection('users').doc(user.uid).get();
      logger.d("Document data: ${doc.data()}");

      if (!doc.exists) {
        // Tambahkan data sementara jika dokumen tidak ada
        Map<String, dynamic> defaultData = {
          'displayName': user.displayName ?? 'No Display Name',
          'email': user.email,
          'photoUrl': user.photoURL ?? 'https://images.pexels.com/photos/845457/pexels-photo-845457.jpeg?auto=compress&cs=tinysrgb&w=600',
        };

        await firestore.collection('users').doc(user.uid).set(defaultData);
        logger.d("Created new document for user: ${user.uid}");

        return Profile.fromJson(defaultData);
      }

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['displayName'] = user.displayName;
      data['photoUrl'] = user.photoURL;

      return Profile.fromJson(data);
    } catch (e) {
      logger.e("Error fetching profile: $e");
      throw Exception('Failed to fetch profile');
    }
  }
}
