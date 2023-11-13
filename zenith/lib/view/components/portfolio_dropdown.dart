import 'package:flutter/material.dart';
import 'package:zenith/constants/app_colors.dart';
import 'package:zenith/constants/font_styles.dart';
import 'package:zenith/data/cryptocurrency_helper.dart';
import 'package:zenith/databases/database_helper.dart';

class PortfolioDropdown extends StatefulWidget {
  @override
  _PortfolioDropdownState createState() => _PortfolioDropdownState();

  List<String>? portfolios = [];
  String? selectedPortfolio;

  PortfolioDropdown({
    this.portfolios,
    this.selectedPortfolio,
  });
}

class _PortfolioDropdownState extends State<PortfolioDropdown> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget!.portfolios!.isEmpty) {
      return CircularProgressIndicator();
    }

    return Container(
      margin: EdgeInsets.all(10.0), 
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0), 
        color: AppColors.secondaryBackgroundColor, 
      ),
      child: DropdownButton<String>(
        value: widget!.selectedPortfolio,
        onChanged: (String? newValue) {
          setState(() {
            widget!.selectedPortfolio = newValue!;
          });
        },
        items: widget!.portfolios!.map((String portfolio) {
          return DropdownMenuItem<String>(
            value: portfolio,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(portfolio, style: FontStyles.montserratStyle(15)),
            ),
          );
        }).toList(),
        icon: Icon(Icons.arrow_drop_down, color: Colors.black), 
        iconSize: 24.0,
        elevation: 16,
        style: FontStyles.montserratStyle(15, color: AppColors.secondaryBackgroundColor),
        underline: Container(
          height: 2,
          color: AppColors.secondaryBackgroundColor,
        ),
        dropdownColor: AppColors.secondaryBackgroundColor, 
      ),
    );
  }
}
