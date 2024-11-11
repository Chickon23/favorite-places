import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/new_place_provider.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewPlaceScreen extends ConsumerStatefulWidget {
  const NewPlaceScreen({super.key});

  @override
  ConsumerState<NewPlaceScreen> createState() => _NewPlaceScreenState();
}

class _NewPlaceScreenState extends ConsumerState<NewPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  var enteredTitle = '';
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  void _saveNewPlace() {
    if (_formKey.currentState!.validate() ||
        _selectedImage != null ||
        _selectedLocation != null) {
      _formKey.currentState!.save();

      ref
          .read(userPlaceProvider.notifier)
          .addNewPlace(enteredTitle, _selectedImage!, _selectedLocation!);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Add new Place')),
        body: Container(
          margin: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(label: Text('Title')),
                      maxLength: 50,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1 ||
                            value.trim().length > 50) {
                          return 'Must be bewtween 1 and 50 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        enteredTitle = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    ImageInput(
                      onPickImage: (image) {
                        _selectedImage = image;
                      },
                    ),
                    const SizedBox(height: 20),
                    LocationInput(
                        onSelectLocation: (location) =>
                            _selectedLocation = location),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _saveNewPlace,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Place'),
                    )
                  ],
                ),
              ),
            ]),
          ),
        ));
  }
}
