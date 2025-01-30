
import 'dart:math';

import 'package:ecoplates_web/src/constant/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../constant/user_or_company_status.dart';
import '../../data/model/company_info.dart';
import 'build_summary_card.dart';

final List<CompanyInfo> companyData = [
  CompanyInfo(
    company_id: 1,
    company_name: 'Tech Innovators',
    phone_number: '+1234567890',
    logo_url: 'https://www.example.com/logo1.png',
    rating: '4.5',
    location_latitude: 37.7749,
    location_longitude: -122.4194,
    working_hours: 'Mon-Fri, 9:00 AM - 6:00 PM',
    telegram_link: 'https://t.me/techinnovators',
    social_profile_link: 'https://facebook.com/techinnovators',
    createdAt: DateTime(2022, 5, 10),
    updatedAt: DateTime(2023, 1, 15),
    status: UserOrCompanyStatus.ACTIVE,
    deleted: false,
  ),
  CompanyInfo(
    company_id: 2,
    company_name: 'Green Solutions',
    phone_number: '+1987654321',
    logo_url: 'https://www.example.com/logo2.png',
    rating: '4.8',
    location_latitude: 34.0522,
    location_longitude: -118.2437,
    working_hours: 'Mon-Fri, 8:00 AM - 4:00 PM',
    telegram_link: 'https://t.me/greensolutions',
    social_profile_link: 'https://facebook.com/greensolutions',
    createdAt: DateTime(2020, 9, 22),
    updatedAt: DateTime(2023, 2, 10),
    status: UserOrCompanyStatus.BANNED,
    deleted: false,
  ),
  CompanyInfo(
    company_id: 3,
    company_name: 'Global Enterprises',
    phone_number: '+1122334455',
    logo_url: 'https://www.example.com/logo3.png',
    rating: '3.9',
    location_latitude: 51.5074,
    location_longitude: -0.1278,
    working_hours: 'Mon-Fri, 10:00 AM - 6:00 PM',
    telegram_link: 'https://t.me/globalenterprises',
    social_profile_link: 'https://facebook.com/globalenterprises',
    createdAt: DateTime(2018, 3, 14),
    updatedAt: DateTime(2022, 7, 25),
    status: UserOrCompanyStatus.NONE,
    deleted: true,
  ),
  CompanyInfo(
    company_id: 4,
    company_name: 'HealthCare Corp',
    phone_number: '+1777888999',
    logo_url: 'https://www.example.com/logo4.png',
    rating: '4.2',
    location_latitude: 40.7128,
    location_longitude: -74.0060,
    working_hours: 'Mon-Fri, 9:00 AM - 5:00 PM',
    telegram_link: 'https://t.me/healthcarecorp',
    social_profile_link: 'https://facebook.com/healthcarecorp',
    createdAt: DateTime(2021, 11, 1),
    updatedAt: DateTime(2023, 1, 10),
    status: UserOrCompanyStatus.NONE,
    deleted: true,
  ),
];

class CompanyDashBoard extends StatefulWidget{
  const CompanyDashBoard({super.key});

  @override
  State<CompanyDashBoard> createState()  => _CompanyDashBoard();
}

class _CompanyDashBoard extends State<CompanyDashBoard>{

  @override
  Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final availableWidth = constraints.maxWidth;
                final cardWidth = availableWidth > 800 ? 200.0 : (availableWidth / 2) - 16;

                return Wrap(
                  spacing: 16.0,
                  runSpacing: 16.0,
                  children: [
                    SizedBox(
                      width: cardWidth,
                      child: buildSummaryCard(
                        title: "Companies",
                        titleColor: Colors.blue,
                        value: "4520",
                        percentage: "",
                        percentageColor: Colors.transparent,
                        description: "The number of companies",
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: buildSummaryCard(
                        title: "Active Companies",
                        titleColor: Colors.green,
                        value: "3200",
                        percentage: "70%",
                        percentageColor: Colors.green,
                        description: "The number of active companies",
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: buildSummaryCard(
                        title: "Inactive Companies",
                        titleColor: Colors.orange,
                        value: "1000",
                        percentage: "22%",
                        percentageColor: Colors.orange,
                        description: "The number of inactive companies",
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: buildSummaryCard(
                        title: "Banned Companies",
                        titleColor: Colors.red,
                        value: "320",
                        percentage: "8%",
                        percentageColor: Colors.red,
                        description: "The number of banned companies",
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: CompanyGridView(),
              //child: UserGridWidget(),
            ),
          ],
        ),
      );
  }
}

class CompanyGridView extends StatefulWidget{
  const CompanyGridView({super.key});

  @override
  State<CompanyGridView> createState()  => _CompanyGridView();
}

class _CompanyGridView extends State<CompanyGridView> {
  late PlutoGridStateManager stateManager;

  final List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];

  List<PlutoRow> generateRows() {
    return companyData.map((item) {
      return PlutoRow(cells: {
        'col1': PlutoCell(value: item.company_id.toString()),
        'col2': PlutoCell(value: item.company_name ?? ''),
        'col3': PlutoCell(value: item.phone_number ?? ''),
        'col4': PlutoCell(value: item.logo_url ?? ''),
        'col5': PlutoCell(value: item.rating ?? ''),
        'col6': PlutoCell(value: item.working_hours ?? ''),
        'col7': PlutoCell(value: item.status.value),
        'col8': PlutoCell(value: item.formatDateTime(item.updatedAt)),
        'col9': PlutoCell(value: item.formatDateTime(item.createdAt)),
        'col10': PlutoCell(value: item.isBanned() ? Constants.BANNED : Constants.BAN),
        'col11': PlutoCell(value: item.deleted == true ?  Constants.DELETED : Constants.DELETE),
      });
    }).toList();
  }

  @override
  void initState(){
    super.initState();

    columns.addAll([
      PlutoColumn(
        title: 'Id',
        field: 'col1',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      PlutoColumn(
        title: 'Company name',
        field: 'col2',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      PlutoColumn(
        title: 'Phone number',
        field: 'col3',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      PlutoColumn(
        title: 'Logo',
        field: 'col4',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      PlutoColumn(
        title: 'Rating',
        field: 'col5',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      PlutoColumn(
        title: 'Working hours',
        field: 'col6',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      PlutoColumn(
        title: 'Status',
        field: 'col7',
        type: PlutoColumnType.text(),
        readOnly: true,
        renderer: (PlutoColumnRendererContext ctx) {
          Color textColor;

          switch (ctx.cell.value) {
            case 'ACTIVE':
              textColor = Colors.green;
              break;
            case 'INACTIVE':
              textColor = Colors.orange;
              break;
            case 'BANNED':
              textColor = Colors.red;
              break;
            default:
              textColor = Colors.grey;
          }

          return Text(
            ctx.column.type.applyFormat(ctx.cell.value),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
      PlutoColumn(
        title: 'Updated',
        field: 'col8',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      PlutoColumn(
        title: 'Created',
        field: 'col9',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      //Ban
      PlutoColumn(
        title: Constants.BAN,
        field: 'col10',
        type: PlutoColumnType.text(),
        readOnly: true,
        enableFilterMenuItem: true,
        renderer: (rendererContext) {
          final company = companyData[rendererContext.rowIdx];
          bool isBanned = rendererContext.cell.value == Constants.BANNED;
          return ElevatedButton(
            onPressed: (company.deleted ?? false) ? null : () {
              rendererContext.stateManager.changeCellValue(
                rendererContext.cell,
                isBanned ? Constants.BAN : Constants.BANNED,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isBanned ? Colors.red : Colors.green,
              foregroundColor: Colors.white,
            ),
            child: Text(isBanned ? Constants.BANNED : Constants.BAN),
          );
        },
      ),
      //Delete
      PlutoColumn(
        title: Constants.DELETE,
        field: 'col11',
        type: PlutoColumnType.text(),
        readOnly: true,
        enableFilterMenuItem: true,
        renderer: (rendererContext) {
          bool isDeleted = rendererContext.cell.value == Constants.DELETED;
          return ElevatedButton(
            onPressed: () {
              rendererContext.stateManager.changeCellValue(
                rendererContext.cell,
                isDeleted ? Constants.DELETE : Constants.DELETED,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDeleted ? Colors.grey : Colors.blueGrey,
              foregroundColor: Colors.white,
            ),
            child: Text(isDeleted ? Constants.DELETED : Constants.DELETE),
          );
        },
      ),
    ]);
    rows = generateRows();
  }

  @override
  Widget build(BuildContext context) {
    return PlutoGrid(
      columns: columns,
      rows: rows,
      configuration: const PlutoGridConfiguration(),
      createFooter: (stateManager) {
        stateManager.setPageSize(100, notify: false);
        return PlutoPagination(stateManager);
      },
      onLoaded: (PlutoGridOnLoadedEvent event) {
        stateManager = event.stateManager;
        stateManager.setShowColumnFilter(true);
      },
      onChanged: (PlutoGridOnChangedEvent event) {

      },
    );
  }
}