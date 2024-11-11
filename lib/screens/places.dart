import 'package:favorite_places/providers/new_place_provider.dart';
import 'package:favorite_places/screens/new_place.dart';
import 'package:favorite_places/widgets/place_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() => _PlaceScreenState();
}

class _PlaceScreenState extends ConsumerState<PlacesScreen> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    _placesFuture = ref.read(userPlaceProvider.notifier).loadPlace();
    super.initState();
  }

  void _savePlace(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return const NewPlaceScreen();
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(userPlaceProvider);
    return Scaffold(
        appBar: AppBar(title: const Text('Your Places'), actions: [
          IconButton(
              onPressed: () => _savePlace(context),
              icon: const Icon(Icons.add)),
        ]),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: _placesFuture,
              builder: (context, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? const Center(child: CircularProgressIndicator())
                      : PlaceList(places: userPlaces),
            )));
  }
}
