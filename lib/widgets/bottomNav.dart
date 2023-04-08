import 'package:flutter/material.dart';

Widget bottomNavBar(_selectedIndex, _onItemTapped){
  return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 18,),
            label: '홈',
        ),
        BottomNavigationBarItem(
            icon: Icon( Icons.camera, size: 18,),
            label: 'cctv'
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.menu_book, size: 18,),
            label: '일기'
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 18,),
            label: '마이 자취'
        )
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      unselectedItemColor: Colors.grey,
      selectedItemColor: const Color(0xfffa625f),
  );
}