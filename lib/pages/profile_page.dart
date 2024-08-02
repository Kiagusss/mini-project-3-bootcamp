import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_project_3_bootcamp/bloc/document_bloc/document_cubit.dart';
import 'package:mini_project_3_bootcamp/model/profile_model.dart';
import 'package:mini_project_3_bootcamp/shared/style.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../bloc/profile_bloc/profile_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ProfileBloc>().add(LoadProfileEvent());
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: whiteColor,
        title: Text(
          'Profile Page',
          style: title.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
        if (state is ProfileLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProfileLoadedState) {
          return ProfileView(profile: state.profile);
        } else if (state is ProfileErrorState) {
          return const Center(child: Text('Failed to fetch profile'));
        } else {
          return const Center(
            child: Text("No data"),
          );
        }
      }),
    );
  }
}

class ProfileView extends StatefulWidget {
  final Profile profile;

  const ProfileView({super.key, required this.profile});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late Profile _profile; // State lokal untuk menyimpan salinan Profile

  @override
  void initState() {
    super.initState();
    _profile = widget.profile;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 35, 16, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _profile.displayName ?? 'No Display Name',
                        style: title.copyWith(
                            fontWeight: FontWeight.bold, color: blackColor),
                      ),
                      Text(
                        _profile.email,
                        style: body.copyWith(color: const Color(0xffA4A8B5)),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: _pickDocument,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundImage: NetworkImage(
                            _profile.photoUrl ??
                                "https://images.pexels.com/photos/845457/pexels-photo-845457.jpeg?auto=compress&cs=tinysrgb&w=600",
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            onTap: _pickDocument,
                            child: const CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.blue,
                              child: Icon(
                                Icons.photo,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const CustomDivider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User Information',
                    style: title.copyWith(
                        fontWeight: FontWeight.bold, color: blackColor),
                  ),
                  const SizedBox(height: 10),
                  InfoRow(
                    icon: Icons.email,
                    title: 'Email',
                    value: _profile.email,
                  ),
                  const SizedBox(height: 10),
                  InfoRow(
                    icon: Icons.person,
                    title: 'Display Name',
                    value: _profile.displayName ?? 'No Display Name',
                  ),
                  // Add other information as needed
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickDocument() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      String? path = result.files.single.path;
      String fileName = result.files.single.name;

      if (path != null) {
        File file = File(path);
        try {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('profile_pictures/$fileName');
          await storageRef.putFile(file);

          final imageUrl = await storageRef.getDownloadURL();

       
          FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .update({'photoUrl': imageUrl});


          setState(() {
            _profile = _profile.copyWith(photoUrl: imageUrl);
          });
        } catch (e) {
          print('Error updating profile picture: $e');
        }
      }
    }
  }

  Widget _buildFileWidget(String fileUrl, String fileName) {
    String fileExtension = fileName.split('.').last.toLowerCase();

    bool isImage = ['jpg', 'jpeg', 'png', 'gif'].contains(fileExtension);

    return ListTile(
      leading: isImage
          ? CircleAvatar(
              child: Image.network(
                fileUrl,
              ),
            )
          : const Icon(Icons.insert_drive_file),
      title: Text(fileName),
      onTap: () async {
        // Aksi saat file diklik, jika diperlukan
      },
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: primaryColor.withOpacity(0.1),
      thickness: 20,
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const InfoRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: primaryColor),
        const SizedBox(width: 10),
        Text(
          '$title: ',
          style: body.copyWith(
            fontWeight: FontWeight.bold,
            color: blackColor,
          ),
        ),
        Text(
          value,
          style: body.copyWith(
            color: blackColor,
          ),
        ),
      ],
    );
  }
}
