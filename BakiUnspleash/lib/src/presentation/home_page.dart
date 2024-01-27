import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../actions/get_comments.dart';
import '../actions/load_items.dart';
import '../actions/set.dart';
import '../models/app_state.dart';
import '../models/app_user.dart';
import '../models/unsplash_image.dart';
import 'containers/app_user_container.dart';
import 'containers/images_container.dart';
import 'containers/is_loading_container.dart';
import 'extensions.dart';
import 'user_picture.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController controller = ScrollController();
  final TextEditingController textController = TextEditingController();
  List<String> selectedColors = <String>[];

  @override
  void initState() {
    super.initState();
    context.dispatch(const LoadItems());
    controller.addListener(_onScroll);
  }

  Future<void> followLink(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _onScroll() {
    final double offset = controller.offset;
    final double maxExtend = controller.position.maxScrollExtent;

    if (!context.state.isLoading && offset > maxExtend * 0.8) {
      context.dispatch(const LoadItems());
    }
  }

  @override
  void dispose() {
    controller.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ImagesContainer(
      builder: (BuildContext context, List<UnsplashImage> images) {
        return IsLoadingContainer(
          builder: (BuildContext context, bool isLoading) {
            return RefreshIndicator(
              onRefresh: () async {
                textController.clear();
                context
                  ..dispatch(const SetQuery(''))
                  ..dispatch(const SetColor(''))
                  ..dispatch(const LoadItems());

                await context.store.onChange.firstWhere((AppState state) => !state.isLoading);
              },
              child: AppUserContainer(
                builder: (BuildContext context, AppUser? user) {
                  // Now 'user' is defined within this scope
                  return Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      backgroundColor: Colors.pinkAccent,
                      title: const Text(
                        'Photo Gallery, Explore and Comment',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pacifico',
                        ),
                      ),
                      actions: <Widget>[
                        if (user != null)
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/profile');
                            },
                            child: const UserPicture(),
                          ),
                        if (user == null)
                          TextButton(
                            onPressed: () {
                              // Placeholder for login functionality
                              Navigator.pushNamed(context, '/loginUser');
                            },
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                            ),
                            child: const Text('Login'),
                          ),
                      ],
                    ),
                    body: Column(
                      children: <Widget>[
                        if (images.isEmpty && !isLoading)
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('No photos found. Showing most popular pictures.'),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            style: TextStyle(color: Colors.pinkAccent),
                            controller: textController, // Add this line to connect the controller
                            onChanged: (String value) {
                              context.dispatch(SetQuery(value));
                              if (context.state.query.isEmpty) {
                                context.dispatch(const SetColor(''));
                              }
                              context.dispatch(const LoadItems());
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ExpansionTile(
                            title: const Text(
                              'Colors',
                              style: TextStyle(
                                color: Colors.pinkAccent,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            children: [
                              for (String color in allColors)
                                CheckboxListTile(
                                  title: Text(
                                    color,
                                    style: TextStyle(
                                      color: Colors.pinkAccent,
                                    ),
                                  ),
                                  value: selectedColors.contains(color),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value != null) {
                                        if (value) {
                                          selectedColors.add(color);
                                        } else {
                                          selectedColors.remove(color);
                                        }
                                        context.dispatch(SetColor(selectedColors.join(',')));
                                        context.dispatch(const LoadItems());
                                      }
                                    });
                                  },
                                ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (ScrollNotification scrollInfo) {
                              if (!context.state.isLoading &&
                                  scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                                context.dispatch(const LoadItems());
                              }
                              return false;
                            },
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  for (int i = 0; i < images.length; i += 2)
                                    Row(
                                      children: <Widget>[
                                        if (i < images.length)
                                          _buildImageCard(context, images[i], user),
                                        if (i + 1 < images.length)
                                          _buildImageCard(context, images[i + 1], user)
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (isLoading)
                          Padding(
                            padding: MediaQuery.of(context).padding,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildImageCard(BuildContext context, UnsplashImage unsplashImage, AppUser? user) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (user != null) {
            context
              ..dispatch(SetSelectedImage(unsplashImage))
              ..dispatch(GetComments(unsplashImage.imageId));
            Navigator.pushNamed(context, '/image');
          } else {
            Navigator.pushNamed(context, '/createUser');
          }
        },
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 150,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.network(
                    unsplashImage.smallImage.thumb,
                    width: 100,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          unsplashImage.description,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {
                            followLink(Uri.parse(unsplashImage.authorPage.links.html));
                          },
                          child: Text(unsplashImage.authorPage.links.html),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  final List<String> allColors = <String>[
    'black_and_white',
    'black',
    'white',
    'yellow',
    'orange',
    'red',
    'purple',
    'magenta',
    'green',
    'teal',
    'blue'
  ];
}
