import 'dart:io';
import 'package:articles_app/utils/app_colors.dart';
import 'package:articles_app/views/custom_widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class P3GalleryScreen extends StatefulWidget {
  const P3GalleryScreen({super.key});

  @override
  State<P3GalleryScreen> createState() => _P3GalleryScreenState();
}

class _P3GalleryScreenState extends State<P3GalleryScreen> {
  final List<String> _selectedMediaList = [];

  Future<void> _pickFile(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? result = await _picker.pickImage(source: ImageSource.gallery);
    final prefs = await SharedPreferences.getInstance();
    if (result != null) {
      setState(() {
        _selectedMediaList.add(result.path);
      });
      await saveImagesToLocalStorage();
    }
  }

  Future<void> saveImagesToLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? existingImages = prefs.getStringList('pickedImages');
    if (existingImages == null) {
      await prefs.setStringList('pickedImages', _selectedMediaList);
    } else {
      Set<String> uniqueImages = Set.from(existingImages)
        ..addAll(_selectedMediaList);
      await prefs.setStringList('pickedImages', uniqueImages.toList());
    }
  }

  void _removeMedia(int index) {
    setState(() {
      _selectedMediaList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CustomappBar(text: 'File to do'),
              SizedBox(
                height: 30.h,
              ),
              SizedBox(
                height: 660.h,
                width: 380.w,
                child: GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                  ),
                  itemCount: _selectedMediaList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      children: [
                        Image.file(
                          File(_selectedMediaList[index]),
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => _removeMedia(index),
                            child: const Icon(
                              Icons.delete,
                              color: kContainer1Color,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.h, left: 320.w),
                child: FloatingActionButton(
                  onPressed: () => _pickFile(context),
                  backgroundColor: kPrimaryMainColor,
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 40,
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
