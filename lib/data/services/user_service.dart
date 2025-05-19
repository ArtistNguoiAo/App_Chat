import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/user_model.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Connectivity _connectivity = Connectivity();

  // Update user status
  Future<void> updateUserStatus(String status) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'status': status,
      });
    }
  }

  // Initialize status monitoring
  Future<void> initializeStatusMonitoring() {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) async {
      if (result == ConnectivityResult.none) {
        if (_auth.currentUser != null) { // Kiểm tra trước khi gọi
          await updateUserStatus('offline');
        }
      } else {
        if (_auth.currentUser != null) {
          await updateUserStatus('online');
        }
      }
    });

    // Update status when app goes to background/foreground
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChannels.lifecycle.setMessageHandler((msg) async {
        if (_auth.currentUser != null) {
          if (msg == AppLifecycleState.resumed.toString()) {
            await updateUserStatus('online');
          } else if (msg == AppLifecycleState.paused.toString() ||
              msg == AppLifecycleState.inactive.toString() ||
              msg == AppLifecycleState.detached.toString()) {
            await updateUserStatus('offline');
          }
        }
        return null;
      });
    });

    return Future.value();
  }

  // Update status when user logs in
  Future<void> onLogin() async {
    await updateUserStatus('online');
  }

  // Update status when user logs out
  Future<void> onLogout() async {
    await updateUserStatus('offline');
  }
}
