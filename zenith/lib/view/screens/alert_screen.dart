import 'package:flutter/material.dart';
import 'package:zenith/constants/app_colors.dart';
import 'package:zenith/constants/font_styles.dart';
import 'package:zenith/view/components/main_bottom_navigation_bar.dart';
import 'package:zenith/view/screens/home_screen_with_portfolio.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({Key? key}) : super(key: key);

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  TextEditingController controller1 = TextEditingController();
  int _currentIndex = 1; // Defina o índice atual conforme necessário

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryBackgroundColor,
        title: Text(
          'Alerts',
          style: FontStyles.montserratStyle(18),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      body: Container(
        color: AppColors.mainBackgroundColor,
      ),
      bottomNavigationBar: MainBottomNavigationBar(
        currentIndex: _currentIndex,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: FloatingActionButton(
          onPressed: () {
            addNewCurrencyDialog();
            // Add your functionality when the button is pressed
          },
          backgroundColor: AppColors.secondaryBackgroundColor, // Set the background color as needed
          child: const Icon(Icons.add), // You can change the icon as needed
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }

  void addNewCurrencyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            color: AppColors.mainBackgroundColor,
            height: MediaQuery.of(context).size.height * 0.55,
            width: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    'Add new token',
                    style: FontStyles.montserratStyle(18, color: Colors.white),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03125),
                TextField(
                  controller: controller1,
                  style: FontStyles.montserratStyle(15, color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Symbol',
                    labelStyle: FontStyles.montserratStyle(15, color: Colors.white),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03125),
                TextField(
                  controller: controller1,
                  style: FontStyles.montserratStyle(15, color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    labelStyle: FontStyles.montserratStyle(15, color: Colors.white),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03125),
                TextField(
                  controller: controller1,
                  style: FontStyles.montserratStyle(15, color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Average purchase price',
                    labelStyle: FontStyles.montserratStyle(15, color: Colors.white),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.0625),
                ElevatedButton(
                  onPressed: () {
                    
                    
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryBackgroundColor,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    "Confirm",
                    style: FontStyles.montserratStyle(15, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
