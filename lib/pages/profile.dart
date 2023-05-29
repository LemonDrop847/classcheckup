import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

import 'landing.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({super.key, required this.uid});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;
  late File _pickedImage;
  bool _isEditMode = false;
  String photoURL = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();

    _pickedImage = File('');

    _loadUserData();
  }

  void _loadUserData() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();

    final userData = userDoc.data() as Map<String, dynamic>;

    setState(() {
      _nameController.text = userData['name'] ?? '';
      photoURL = userData['photoURL'] ?? '';
    });
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _pickedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    final newName = _nameController.text.trim();

    if (newName.isNotEmpty) {
      if (_pickedImage.path.isNotEmpty) {
        final fileName = 'profile_images/${widget.uid}';
        final firebaseStorageRef =
            firebase_storage.FirebaseStorage.instance.ref().child(fileName);
        await firebaseStorageRef.putFile(_pickedImage);

        final photoURL = await firebaseStorageRef.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .update({
          'name': newName,
          'photoURL': photoURL,
        });
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .update({
          'name': newName,
        });
      }

      setState(() {
        _isEditMode = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name is Required')),
      );
    }
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut().then(
          (value) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LandingPage()),
            (Route<dynamic> route) => false,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(_isEditMode ? Icons.done : Icons.edit),
            onPressed: _isEditMode ? _updateProfile : _toggleEditMode,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _isEditMode ? _pickImage : null,
              child: CircleAvatar(
                radius: 100,
                backgroundImage: _pickedImage.path.isNotEmpty
                    ? FileImage(_pickedImage)
                    : NetworkImage(photoURL) as ImageProvider,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: TextFormField(
                controller: _nameController,
                enabled: _isEditMode,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signOut,
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
