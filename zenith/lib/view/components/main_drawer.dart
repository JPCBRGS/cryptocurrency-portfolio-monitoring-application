import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:zenith/constants/app_colors.dart';
import 'package:zenith/constants/font_styles.dart';
import 'package:zenith/data/cryptocurrency_helper.dart';
import 'package:zenith/databases/database_helper.dart';
import 'package:zenith/models/cryptocurrency.dart';
import 'package:zenith/utils/csv_utils.dart';

class MainDrawer extends StatelessWidget {
  final Function? loadedDropdownState;

  MainDrawer({
    this.loadedDropdownState,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColors.mainBackgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 94,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: AppColors.secondaryBackgroundColor,
                ),
                child: Text(
                  'Actions',
                  style: FontStyles.montserratStyle(15, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Add new portfolio from files',
                style: FontStyles.montserratStyle(15),
              ),
              onTap: () async {
                CsvUtils csvUtils = CsvUtils();
                var csvResult = await csvUtils.selectCsvFile();
                if (csvResult != null) {
                  List<Cryptocurrency> cryptocurrencies = csvUtils.parseCSVIntoCryptocurrencyList(
                    csvResult['fileName'],
                    csvResult['csvString'],
                  );
                  final dbHelper = DatabaseHelper.instance;
                  final database = await dbHelper.database;
                  CryptocurrencyHelper cryptocurrencyHelper = CryptocurrencyHelper(database);
                  for (Cryptocurrency cryptocurrency in cryptocurrencies) {
                    await cryptocurrencyHelper.insertCryptocurrency(cryptocurrency);
                  }
                  loadedDropdownState!();
                  await dbHelper.copyFileToExternalStorage();
                } else {
                  final _log = Logger();
                  _log.i('No file selected.');
                }
              },
            ),
            ListTile(
              title: Text(
                'Add new empty .CSV portfolio file',
                style: FontStyles.montserratStyle(15),
              ),
              onTap: () async {
                // Your implementation for adding an empty CSV portfolio file
              },
            ),
            ListTile(
              title: Text(
                'View settings',
                style: FontStyles.montserratStyle(15),
              ),
              onTap: () async {
                // Your implementation for viewing settings
              },
            ),
            ListTile(
              title: Text(
                'Help',
                style: FontStyles.montserratStyle(15),
              ),
              onTap: () async {
                // Your implementation for help
              },
            ),
          ],
        ),
      ),
    );
  }
}
