import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/photo_view_model.dart';


class PhotoPage extends StatefulWidget {
  const PhotoPage({Key? key}) : super(key: key);

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _albumIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<PhotoApiProvider>(context, listen: false).fetchPhotos();
  }

  void _showModalBottomSheet({Map<String, dynamic>? photo}) {
    if (photo != null) {
      _titleController.text = photo['title'];
      _albumIdController.text = photo['albumId'].toString();
    } else {
      _titleController.clear();
      _albumIdController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 15),
            Center(
              child: Text(
                photo != null ? 'Update Photo' : 'Add Photo',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Title',
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _albumIdController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Album ID',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(int photoId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this photo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          // TextButton(
          //   onPressed: () async {
          //     Navigator.pop(context);
          //     try {
          //       Map<String, dynamic> result = await Provider.of<ProductViewModel>(context, listen: false).deletePhotoApi(photoId);
          //       bool success = result["success"];
          //       int? statusCode = result["statusCode"];
          //       if (success) {
          //         ScaffoldMessenger.of(context).showSnackBar(
          //           SnackBar(content: Text('Deleted: $statusCode')),
          //         );
          //         Provider.of<ProductViewModel>(context, listen: false).getPhoto();
          //       } else {
          //         ScaffoldMessenger.of(context).showSnackBar(
          //           SnackBar(content: Text('Failed: $statusCode')),
          //         );
          //       }
          //     } catch (e) {
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         SnackBar(content: Text('Error: $e')),
          //       );
          //     }
          //   },
          //   child: const Text('Delete'),
          // ),
        ],
      ),
    );
  }

  void _showPhotoDetails(Map<String, dynamic> photo) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${photo['title']}', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Album ID: ${photo['albumId']}', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Image.network(photo['url']),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _albumIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var photoData = Provider.of<PhotoApiProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        title: const Text('Photo API MVVM', style: TextStyle(color: Colors.white)),
      ),

      body: photoData.photos.isEmpty
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: photoData.photos.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Image.network('https://hips.hearstapps.com/hmg-prod/images/hummingbird-feeding-at-bleeding-heart-bloom-royalty-free-image-1656108706.jpg?crop=0.536xw:1.00xh;0.116xw,0&resize=980:*=${index + 1}'),
              // leading: Image.network(photoData.photos[index]['url']),
              title: Text('Title: ${photoData.photos[index]['title']}'),
              subtitle: Text('Album ID: ${photoData.photos[index]['albumId']}'),
            ),
          );
        },
      ),
    );
  }
}
