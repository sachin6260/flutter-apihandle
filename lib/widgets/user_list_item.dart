import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_model.dart';

class UserListItem extends StatelessWidget {
  final UserModel user;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const UserListItem({
    super.key,
    required this.user,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(user.avatar)),
        title: Text(
          "${user.firstName} ${user.lastName}",
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          user.email,
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]),
        ),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.grey,
          ),
          onPressed: onToggleFavorite,
        ),
      ),
    );
  }
}
