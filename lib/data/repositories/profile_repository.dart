import '../services/firestore_service.dart';
import '../models/user_profile.dart';

class ProfileRepository {
  final FirestoreService _firestoreService;

  ProfileRepository(this._firestoreService);

  Future<UserProfile?> getProfile(String uid) async {
    return await _firestoreService.getUserProfile(uid);
  } 

  Future<void> updateName(String uid, String name) async {
    await _firestoreService.updateUserProfile(uid, {'name': name});
  }


}