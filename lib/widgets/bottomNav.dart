import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget bottomNavBar(_selectedIndex, _onItemTapped){
  return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          //icon: FaIcon(FontAwesomeIcons.cameraRetro),
            icon: Icon(Icons.home_outlined, size: 20,),
            label: '홈',
        ),
        BottomNavigationBarItem(
            icon: Icon( Icons.camera, size: 20,),
            label: 'cctv'
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.menu_book, size: 20,),
            label: '일기'
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 20,),
            label: '마이 자취'
        )
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      unselectedItemColor: Colors.grey,
      selectedItemColor: const Color(0xfffa625f),
  );
}