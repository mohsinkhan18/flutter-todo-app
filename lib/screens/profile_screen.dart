import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'login_screens/signin_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _imageFile;
  String? dpimage;
  bool isUploading = false;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  Future pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
      showConfirmationDialog();
    }
  }

  Future<void> getUserData() async {
    if (user == null) return;
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("user")
          .doc(user!.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          dpimage = userDoc.get('profile_url');
        });
      }
    } catch (e) {
      print("Error fetching user data");
    }
  }

  Future<void> uploadImage() async {
    if (_imageFile == null) return;
    setState(() => isUploading = true);

    try {
      final uid = user!.uid;
      final fileName = DateTime.now().microsecondsSinceEpoch.toString();
      final path = 'upload/$fileName';

      await Supabase.instance.client.storage
          .from('images')
          .upload(path, _imageFile!);
      var imageUrl = Supabase.instance.client.storage
          .from('images')
          .getPublicUrl(path);

      await FirebaseFirestore.instance.collection('user').doc(uid).update({
        'profile_url': imageUrl,
      });

      setState(() {
        dpimage = imageUrl;
        _imageFile = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Upload failed")));
    } finally {
      setState(() => isUploading = false);
    }
  }

  Future<void> deletePhoto() async {
    if (user == null) return;
    await FirebaseFirestore.instance.collection('user').doc(user!.uid).update({
      'profile_url': FieldValue.delete(),
    });
    setState(() {
      dpimage = null;
      _imageFile = null;
    });
    Navigator.pop(context);
  }

  void showEditOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.gallery);
              },
            ),
            if (dpimage != null || _imageFile != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Delete Photo',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: deletePhoto,
              ),
          ],
        );
      },
    );
  }

  void showConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Upload"),
        content: const Text("Do you want to set this as your profile picture?"),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _imageFile = null);
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              uploadImage();
            },
            child: const Text("Done"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1253AA),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Color(0xff63D9F3)),
        ),
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff1253AA), Color(0xff05243E)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 70,
                backgroundImage: _imageFile != null
                    ? FileImage(_imageFile!) as ImageProvider
                    : (dpimage != null
                          ? NetworkImage(dpimage!) as ImageProvider
                          : null),
                child: (_imageFile == null && dpimage == null)
                    ? Icon(Icons.person, size: 100, color: Colors.grey)
                    : null,
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: showEditOptions,
                child: Text(
                  "Edit",
                  style: TextStyle(
                    color: Color(0xff63D9F3),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 60),
              ListTile(
                leading: Icon(Icons.person_pin, size: 40, color: Colors.white),
                title: Text(
                  "Name",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  FirebaseAuth.instance.currentUser!.displayName.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.email, size: 40, color: Colors.white),
                title: Text(
                  "Email",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  FirebaseAuth.instance.currentUser!.email.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: 260,
                height: 62,
                child: OutlinedButton.icon(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignInScreen()),
                    );
                  },
                  icon: Icon(
                    Icons.logout_outlined,
                    color: Colors.red,
                    size: 30,
                  ),
                  label: Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
