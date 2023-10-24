import 'package:automasters/utils/size_config.dart';
import 'package:automasters/widgets/column_builder.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_bottom_sheet.dart';

class SearchHistory extends StatelessWidget {
  const SearchHistory({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return CustomBottomSheet(
      initialChildSize: 0.2,
      child: ColumnBuilder(
        itemBuilder: (context, index) {
          return Card(
            child: Text("Steve $index"),
          );
        },
        itemCount: 30,
      ),
    );
  }
}
