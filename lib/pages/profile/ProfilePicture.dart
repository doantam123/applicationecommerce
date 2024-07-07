import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: SizedBox(
        width: 115,
        height: 115,
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('images/item.png'),
            ),
            Positioned(
                bottom: 20,
                right: -8,
                child: SizedBox(
                  height: 15,
                  width: 15,
                  child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: Colors.white),
                        ),
                        backgroundColor: Colors.grey.shade200,
                      ),
                      onPressed: () {},
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.grey,
                        size: 20,
                      )),
                ))
          ],
        ),
      ),
    );
  }
}
