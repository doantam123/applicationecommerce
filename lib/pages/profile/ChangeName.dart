import 'package:flutter/material.dart';


class ChangeNameScreen extends StatelessWidget {
  final String oldName;
  const ChangeNameScreen(this.oldName, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Đổi tên',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: buildBody(context, oldName),
    );
  }
}

Widget buildBody(BuildContext context, String oldName) {
  final nameController = TextEditingController(text: oldName);
  final formKey = GlobalKey<FormState>();

  return SafeArea(
    child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Họ Tên', // Concise label
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                  borderSide:
                      BorderSide(color: Colors.grey[400]!), // Subtle border
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                      const BorderSide(color: Colors.red), // Error border
                ),
              ),
              controller: nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Vui Lòng Nhập Tên";
                }
                return null;
              },
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 30.0)),
            TextButton(
              onPressed: () async {
                // ... (form validation and name change logic)
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                backgroundColor: Theme.of(context)
                    .primaryColor
                    .withOpacity(0.8), // Gradient or softer background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                'Xác Nhận',
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Colors.white), // White text for better contrast
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
