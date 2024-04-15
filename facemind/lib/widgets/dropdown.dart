// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';

// class Dropdown extends StatefulWidget {
//   const Dropdown({
//     super.key,
//   });

//   @override
//   State<Dropdown> createState() => _DropdownState();
// }

// class _DropdownState extends State<Dropdown> {
//   final List<String> items = [
//     '높은 순',
//     '낮은 순',
//   ];
//   String? selectedValue;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton2<String>(
//             isExpanded: true,
//             hint: Text(
//               '높은 순', // 기본: 높은 순
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Theme.of(context).hintColor,
//               ),
//             ),
//             items: items
//                 .map((String item) => DropdownMenuItem<String>(
//                       value: item,
//                       child: Text(
//                         item,
//                         style: const TextStyle(
//                           fontSize: 12,
//                         ),
//                       ),
//                     ))
//                 .toList(),
//             value: selectedValue,
//             onChanged: (String? value) {
//               setState(() {
//                 selectedValue = value;
//               });
//             },
//             buttonStyleData: const ButtonStyleData(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               height: 40,
//               width: 140,
//             ),
//             menuItemStyleData: const MenuItemStyleData(
//               height: 40,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
