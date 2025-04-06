import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/search_cubit.dart';
import '../../../core/constants/kapi.dart';
import '../../../core/constants/kcolors.dart';
import '../../../core/widgets/custom_text.dart';
class SearchRadioButtons extends StatefulWidget {
  const SearchRadioButtons({super.key, this.onChange});
  final void Function()? onChange;
  @override
  State<SearchRadioButtons> createState() => SearchRadioButtonsState();
}

class SearchRadioButtonsState extends State<SearchRadioButtons> {
  static String selectedValue = KApi.speciesList;

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> radioButtons = [
      {"title": "Plant", "value": KApi.speciesList},
      {"title": "Disease", "value": KApi.disease},
      {"title": "FAQ", "value": KApi.faq},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: radioButtons.map((button) {
        return Expanded(
          child: RadioListTile<String>(
            contentPadding: EdgeInsets.zero,
            title: CustomText(
              text: button["title"]!,
              textSize: 14,
              textColor: selectedValue == button["value"] ? baseColor : Colors.black,
              textWeight: selectedValue == button["value"] ? FontWeight.bold : FontWeight.normal,
            ),
            value: button["value"]!,
            groupValue: selectedValue,
            activeColor: baseColor,
            onChanged: (value) {
              setState(() {
                selectedValue = value!;
              });
              widget.onChange!();
              context.read<SearchCubit>().searchProduct(null, value!);
            },
          ),
        );
      }).toList(),
    );
  }
}

