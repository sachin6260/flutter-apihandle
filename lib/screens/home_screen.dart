import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import 'favorites_screen.dart';
import '../widgets/user_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<UserModel>> users;
  List<int> favoriteIds = [];

  @override
  void initState() {
    super.initState();
    users = ApiService.fetchUsers();
    loadFavorites();
  }

  void loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final savedFavs = prefs.getStringList("favorites") ?? [];
    setState(() {
      favoriteIds = savedFavs.map((e) => int.parse(e)).toList();
    });
  }

  void toggleFavorite(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (favoriteIds.contains(userId)) {
        favoriteIds.remove(userId);
      } else {
        favoriteIds.add(userId);
      }
    });
    prefs.setStringList(
      "favorites",
      favoriteIds.map((e) => e.toString()).toList(),
    );
  }

  void showInfoDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              "Favorites Info",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            content: Text(
              "Tap the heart icon to add or remove a user from favorites. "
              "You can view all favorite users by clicking the red heart icon in the top right.",
              style: GoogleFonts.poppins(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "OK",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
              ),
            ],
            backgroundColor: Colors.white,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "Users List",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.blueGrey),
            onPressed: showInfoDialog,
          ),
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FavoritesScreen(favoriteIds: favoriteIds),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<UserModel>>(
        future: users,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final userList = snapshot.data!;
          return ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              final user = userList[index];
              final isFav = favoriteIds.contains(user.id);
              return UserListItem(
                user: user,
                isFavorite: isFav,
                onToggleFavorite: () => toggleFavorite(user.id),
              );
            },
          );
        },
      ),
    );
  }
}
