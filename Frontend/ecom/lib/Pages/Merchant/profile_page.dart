import 'package:ecom/Pages/auth/login_page.dart';
import 'package:ecom/Services/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class MerchantProfilePage extends StatefulWidget {
  const MerchantProfilePage({super.key});

  @override
  State<MerchantProfilePage> createState() => _MerchantProfilePageState();
}

class _MerchantProfilePageState extends State<MerchantProfilePage> {
  String fullName = "";
  String email = "";
  String role = "";

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final token = await TokenStorage.getToken();

    if (token == null) return;

    final decoded = JwtDecoder.decode(token);

    setState(() {
      fullName =
          decoded["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"] ??
          "";

      email =
          decoded["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"] ??
          "";

      role =
          decoded["http://schemas.microsoft.com/ws/2008/06/identity/claims/role"] ??
          "";
    });
  }

  Future<void> logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (shouldLogout != true) return;

    await TokenStorage.clearToken();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  Widget buildTile(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        subtitle: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 55,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),

            const SizedBox(height: 20),

            Text(
              fullName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            Text(email, style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 30),

            buildTile(Icons.person, "Full Name", fullName),

            buildTile(Icons.email, "Email", email),

            buildTile(Icons.badge, "Role", role),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: logout,
                icon: const Icon(Icons.logout),
                label: const Text("Logout", style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
