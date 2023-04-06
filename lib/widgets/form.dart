import 'package:flutter/material.dart';

Column drawTitle(String title, double hSize){
  return Column(
    children: [
      SizedBox(height: hSize),
      Text(title),
      const SizedBox(height: 10),
    ],
  );
}

InputDecoration formDecoration(String title){
  return InputDecoration(
      hintText: title,
      filled: true,
      fillColor: Colors.grey[200],
      enabled: true,
      enabledBorder: const UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.grey)
      ),
      border: InputBorder.none
  );
}

renderTextFormField({
  required FormFieldSetter onSaved,
  required FormFieldValidator validator,
  required String hintLabel
}){
  return TextFormField(
    decoration: formDecoration(hintLabel),
    onSaved: onSaved,
    validator: validator,
  );
}
