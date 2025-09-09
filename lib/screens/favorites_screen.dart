import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:userlist/widgets/user_list_item.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class FavoritesScreen extends StatefulWidget {
  final List<int> favoriteIds;

  const FavoritesScreen({super.key, required this.favoriteIds});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late List<int> favoriteIds;

  @override
  void initState() {
    super.initState();
    favoriteIds = List.from(widget.favoriteIds);
  }

  void toggleFavorite(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteIds.remove(userId);
    });
    prefs.setStringList(
      "favorites",
      favoriteIds.map((e) => e.toString()).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "Favorite Users",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<List<UserModel>>(
        future: ApiService.fetchUsers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final favUsers =
              snapshot.data!
                  .where((user) => favoriteIds.contains(user.id))
                  .toList();

          if (favUsers.isEmpty) {
            return Center(
              child: Text(
                "No Favorites Added",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: favUsers.length,
            itemBuilder: (context, index) {
              final user = favUsers[index];
              return UserListItem(
                user: user,
                isFavorite: true,
                onToggleFavorite: () => toggleFavorite(user.id),
              );
            },
          );
        },
      ),
    );
  }
}
