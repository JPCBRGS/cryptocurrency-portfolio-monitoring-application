import 'package:flutter/material.dart';
import 'package:zenith/constants/app_colors.dart';
import 'package:zenith/constants/font_styles.dart';

class PortfolioDropdown extends StatefulWidget {
  @override
  _PortfolioDropdownState createState() => _PortfolioDropdownState();

  List<String>? portfolios = [];
  String? selectedPortfolio;

  PortfolioDropdown({super.key, 
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
    if (widget.portfolios!.isEmpty) {
      return const CircularProgressIndicator();
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(10.0), 
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0), 
        color: AppColors.secondaryBackgroundColor, 
      ),
      child: DropdownButton<String>(
        value: widget.selectedPortfolio,
        onChanged: (String? newValue) {
          setState(() {
            widget.selectedPortfolio = newValue!;
          });
        },
        items: widget.portfolios!.map((String portfolio) {
          return DropdownMenuItem<String>(
            value: portfolio,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(portfolio, style: FontStyles.montserratStyle(15)),
            ),
          );
        }).toList(),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white), 
        iconSize: 40.0,
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
