import 'package:aetheric/elements/custom_field_button.dart';
import 'package:flutter/material.dart';
import 'package:aetheric/elements/custom_edit_text_field.dart';

class EditProfilePage extends StatefulWidget {
  final String name;
  final String status;
  final String website;
  final String location;

  const EditProfilePage({
    super.key,
    required this.name,
    required this.status,
    required this.website,
    required this.location,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.name;
    _statusController.text = widget.status;
    _websiteController.text = widget.website;
    _locationController.text = widget.location;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => _saveData(context),
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: 16.0,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16.0),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 128.0,
            margin: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    fit: BoxFit.cover,
                    width: 114.0,
                    height: 114.0,
                    'https://picsum.photos/200',
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomFieldButton(
                        icon: Icons.camera_alt_rounded,
                        text: 'Take a picture',
                        function: () => {},
                      ),
                      CustomFieldButton(
                        icon: Icons.file_download_sharp,
                        text: 'Search through gallery',
                        function: () => {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          CustomEditTextField(
            icon: Icons.person,
            hintText: 'Enter your name',
            controller: _nameController,
          ),
          CustomEditTextField(
            icon: Icons.info,
            hintText: 'Enter your bio',
            controller: _statusController,
          ),
          CustomEditTextField(
            icon: Icons.link,
            hintText: 'Enter your website',
            controller: _websiteController,
          ),
          CustomEditTextField(
            icon: Icons.location_on,
            hintText: 'Enter your location',
            controller: _locationController,
          ),
        ],
      ),
    );
  }

  // Function to write our data to the database
  _saveData(BuildContext context) {
    debugPrint('Saving data...');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Saving data...',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
