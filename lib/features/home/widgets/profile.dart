import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskati/core/functions/dialogs.dart';
import 'package:taskati/core/functions/navigations.dart';
import 'package:taskati/core/services/local_storage.dart';
import 'package:taskati/core/utils/colors.dart';
import 'package:taskati/core/widgets/mainbutton.dart';
import 'package:taskati/features/home/page/home_screen.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  String? path;
  var NameCotroller = TextEditingController();
  String ?userName ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primaryColor),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                if (path != null && NameCotroller.text.isNotEmpty) {
                  LocalStorage.cacheData(LocalStorage.name, NameCotroller.text);
                  LocalStorage.cacheData(LocalStorage.image, path!);
                  pushTo(context, homeScreen());
                } else if (path == null && NameCotroller.text.isNotEmpty) {
                  showmaindialog(context, "please select an image !");
                } else if (path != null && NameCotroller.text.isEmpty) {
                  showmaindialog(context, "please enter your name !");
                } else {
                  showmaindialog(
                    context,
                    "please select an image and enter your name !",
                  );
                }
              },

              child: Text(
                "Done",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),

              GestureDetector(
                onTap: () {
                  showUploadBottomSheet(context);
                },
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    path != null
                        ? ClipOval(
                          child: Image.file(
                            File(path!),
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        )
                        : CircleAvatar(radius: 60),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: AppColors.primaryColor,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Divider(),
              SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    userName??"",
                    style: TextStyle(
                      fontSize: 18,

                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        border: Border.all(color: AppColors.primaryColor),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.all(2.5),
                        onPressed: () {
                          showEditNameBottomSheet(context);
                        },
                        icon: Icon(Icons.edit),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  showUploadBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                mainbutton(
                  title: "Upload From Camera",
                  onpreesed: () {
                    UploadImage(true);
                  },
                ),
                SizedBox(height: 7),
                mainbutton(
                  title: "Upload From Gallery",
                  onpreesed: () {
                    UploadImage(false);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showEditNameBottomSheet(BuildContext context) {
    NameCotroller.text = userName??"";
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: NameCotroller,
                decoration: InputDecoration(
                  hintText: "Enter Your Name",
                  suffix: Icon(Icons.edit),

                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              mainbutton(
                title: "Update Your Name",
                onpreesed: () {
                  setState(() {
                    userName = NameCotroller.text;
                  });
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  UploadImage(bool IsCamera) async {
    var imagePicker = ImagePicker();
    var PickedImage = await imagePicker.pickImage(
      source: IsCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (PickedImage != null) {
      setState(() {
        path = PickedImage.path;
      });
    }
    Navigator.pop(context);
  }
}
