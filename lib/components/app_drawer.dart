import 'package:ct312h_project/pages/order_page.dart';
import 'package:ct312h_project/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Drawer(
          child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 50.0),
            color: Color(0xFF25833F),
            child: Center(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 35,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50), // Bo tròn góc
                    child: Image.asset(
                      'assets/logo1.jpg', // Đường dẫn đến hình ảnh của bạn
                      width: 100, // Kích thước ảnh
                      height: 100,
                      fit: BoxFit.cover, // Đảm bảo ảnh lấp đầy khung
                    ),
                  ),
                ),
              ),
            ),
          ),
          ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.grey.shade500,
              ),
              title: Text('Homepage'),
              onTap: () {
                Navigator.of(context).pushNamed(HomePage.routeName);
              }),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 17.0),
            child: Divider(
              color: Colors.grey.shade300,
              thickness: 3.0,
            ),
          ),
          ListTile(
              leading: Icon(
                Icons.info,
                color: Colors.grey.shade500,
              ),
              title: Text('Profile'),
              onTap: () {
                Navigator.of(context).pushNamed(ProfileEditPage.routeName);
              }),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 17.0),
            child: Divider(
              color: Colors.grey.shade300,
              thickness: 3.0,
            ),
          ),
          ListTile(
              leading: Icon(
                Icons.receipt_long,
                color: Colors.grey.shade500,
              ),
              title: Text('Orders'),
              onTap: () {
                Navigator.of(context).pushNamed(OrdersPage.routeName);
              }),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 17.0),
            child: Divider(
              color: Colors.grey.shade300,
              thickness: 3.0,
            ),
          ),
          const Spacer(),
          ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.grey.shade500,
              ),
              title: Text('Logout'),
              onTap: () {
                Navigator.of(context)
                  ..pop()
                  ..pushReplacementNamed('/');
                context.read<AuthManager>().logout();
              })
        ],
      )),
    );
  }
}
