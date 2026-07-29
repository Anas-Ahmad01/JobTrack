import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Users collection reference
  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  // Create user profile
  Future<void> createUserProfile(UserProfile profile) async {
    await _usersCollection.doc(profile.uid).set(profile.toJson());
  }

  // Get user profile
  Future<UserProfile?> getUserProfile(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return UserProfile.fromJson(doc.data()!);
  }

  // Update user profile
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    await _usersCollection.doc(uid).update(data);
  }

  // Saved jobs sub-collection
  CollectionReference<Map<String, dynamic>> _savedJobsCollection(String uid) =>
      _usersCollection.doc(uid).collection('savedJobs');

  // Applications sub-collection
  CollectionReference<Map<String, dynamic>> _applicationsCollection(String uid) =>
      _usersCollection.doc(uid).collection('applications');

  // --- Saved Jobs ---

  Future<void> saveJob(String uid, Map<String, dynamic> jobData) async {
    await _savedJobsCollection(uid).doc(jobData['id']).set(jobData);
  }

  Future<void> removeSavedJob(String uid, String jobId) async {
    await _savedJobsCollection(uid).doc(jobId).delete();
  }

  Stream<List<Map<String, dynamic>>> getSavedJobs(String uid) {
    return _savedJobsCollection(uid)
        .orderBy('savedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // --- Applications ---

  Future<void> addApplication(String uid, Map<String, dynamic> appData) async {
    await _applicationsCollection(uid).doc(appData['id']).set(appData);
  }

  Future<void> updateApplication(
      String uid, String appId, Map<String, dynamic> data) async {
    await _applicationsCollection(uid).doc(appId).update(data);
  }

  Future<void> deleteApplication(String uid, String appId) async {
    await _applicationsCollection(uid).doc(appId).delete();
  }

  Stream<List<Map<String, dynamic>>> getApplications(String uid) {
    return _applicationsCollection(uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<Map<String, dynamic>?> getApplication(String uid, String appId) async {
    final doc = await _applicationsCollection(uid).doc(appId).get();
    if (!doc.exists) return null;
    return doc.data();
  }
}