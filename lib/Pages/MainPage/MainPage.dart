import 'package:flutter/material.dart';
import 'package:krankmelde_app/Utility/ButtonGenerator.dart';
import 'package:krankmelde_app/Pages/UserdataPage/UserDataPage.dart';
import 'package:krankmelde_app/Pages/PagesInterface.dart';
import 'package:krankmelde_app/Pages/WriteMailPage/WriteMailPage.dart';
import 'package:krankmelde_app/main.dart';

class MainPage extends StatefulWidget {
  static final MainPage _instance = MainPage._();

  const MainPage._();

  factory MainPage() => _instance;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<PagesInterface> pages = [];
  int _currentIndex = 0;

  List<NavigationDestination> pagesNavigationDestinations = [];

  @override
  void initState() {
    super.initState();
    MyApp.emailTemplate.initJson().then((_) {
      pages = [UserData(), WriteMailPage()];

      for (var page in pages) {
        if(!mounted) return;
        pagesNavigationDestinations.add(page.getNavigationDestination());
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    if (pages.isEmpty || pagesNavigationDestinations.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      //Bar am oberen Rand des Bilschirms mit App Logo
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: 
        Container(
          alignment: Alignment.centerLeft,
            child: Column(
              children: [
                Image.asset('assets/AppLogoAppBar.png', scale: 17),
                SizedBox(height: 10),
              ],
            ),
        ),
      ),

      //BottomNavigationBar mit pfaden zu den unterschiedlichen Seiten
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
      labelTextStyle: WidgetStateProperty.resolveWith(
        (state){
          if(state.contains(WidgetState.selected)) return TextStyle(color: Colors.white);
          return TextStyle(color: Colors.white);
        }
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (state){
          if(state.contains(WidgetState.selected)) return IconThemeData(color: Colors.black);
          return IconThemeData(color: Colors.white);
        }
      ),
    ), 
        child: NavigationBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onDestinationSelected: (int index) {
          if(pages[_currentIndex].runtimeType == UserData ) pages[_currentIndex].getFunction(context);
          setState(() {
            _currentIndex = index;
          });

        },
        indicatorColor: const Color.fromARGB(200, 255, 255, 255),
        selectedIndex: _currentIndex,
        destinations: pagesNavigationDestinations,
      ),
      ),

      // zeigt entweder wenn di Json läd oder noch leer ist einen Loadingscreen an oder die ausgewählte Seite
      body: MyApp.emailTemplate.getIsLoading() || MyApp.emailTemplate.jsonData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                pages[_currentIndex].getWidget(),
                if (!keyboardOpen)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ButtonGenerator(
                        width: 175,
                        height: 75,
                        text: pages[_currentIndex].getButtonText(),
                        function: () {
                          pages[_currentIndex].getFunction(context);
                          setState(() {});
                        },
                      ).getWidget(),
                    ),
                  ),
              ],
            ),
      // }
    );
    // );
  }
}
