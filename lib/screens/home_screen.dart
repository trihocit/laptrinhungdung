import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Facebook Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
        ],
      ),

      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.redAccent,
              floating: true,
              pinned: false,
              snap: true,
              expandedHeight: 250.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  children: [
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage('assets/hinhtri.jpg'),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Bạn đang nghĩ gì?",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: ListView.builder(
          itemCount: 20,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: AssetImage('assets/hinhtri.jpg'),
                    ),
                    title: Text('Đức Trí'),
                    subtitle: const Text('5 phút trước'),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('This is a post from User #$index. It could include text, photos, or other content.'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.thumb_up_alt_outlined),
                          label: const Text('Like'),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.comment_outlined),
                          label: const Text('Comment'),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.share_outlined),
                          label: const Text('Share'),
                        ),
                      ],
                    ),
                  ),
                ],

              ),
            );
          },
        ),
      ),
    );
  }
}
final List<Map<String, String>> stories = [
  {"imageUrl": "assets/sample_story_0.jpg", "userName": "User 1"},
  {"imageUrl": "assets/sample_story_1.jpg", "userName": "User 2"},
  {"imageUrl": "assets/sample_story_2.jpg", "userName": "User 3"},
  {"imageUrl": "assets/sample_story_3.jpg", "userName": "User 4"},
];

Widget _buildStoryItem(BuildContext context, String imageUrl, String userName) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: Text("Story của $userName")),
            body: Center(
              child: Image.asset(imageUrl, fit: BoxFit.cover),
            ),
          ),
        ),
      );
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(imageUrl),
          ),
          const SizedBox(height: 4),
          Text(
            userName,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    ),
  );
}