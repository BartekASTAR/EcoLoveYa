import 'package:flutter/material.dart';

class WeeklyBar extends StatefulWidget {
  @override
  _WeeklyBarState createState() => _WeeklyBarState();
}

class _WeeklyBarState extends State<WeeklyBar> {
  int selectedDayIndex = 0; // Jeden wspólny wskaźnik dla wszystkich tygodni
  late DateTime currentWeekStart;
  PageController _pageController = PageController(
      initialPage: 1000); // Środek dla przeglądania poprzednich tygodni
  final List<String> days = ['P', 'W', 'Ś', 'C', 'P', 'S', 'N'];
  List<int> dates = [];

  @override
  void initState() {
    super.initState();
    _initializeCurrentWeek();
  }

  void _initializeCurrentWeek() {
    DateTime now = DateTime.now();
    currentWeekStart = now.subtract(
        Duration(days: now.weekday - 1)); // Poniedziałek tego tygodnia
    _updateWeekDates();
    selectedDayIndex =
        now.weekday - 1; // Ustawienie zaznaczenia na bieżący dzień tygodnia
  }

  void _updateWeekDates() {
    // Ustalanie dni miesiąca dla bieżącego tygodnia
    dates = List.generate(
        7, (index) => currentWeekStart.add(Duration(days: index)).day);
    setState(() {});
  }

  void _updateWeekForPage(int page) {
    setState(() {
      // Obliczamy początek tygodnia na podstawie strony (page)
      currentWeekStart = DateTime.now()
          .subtract(Duration(days: DateTime.now().weekday - 1))
          .add(Duration(days: (page - 1000) * 7));
      _updateWeekDates();
      selectedDayIndex = -1;
    });
  }

  // Metoda drukująca datę na podstawie indeksu dnia
  void _returnSelectedDate(int dayIndex) {
    DateTime selectedDate = currentWeekStart.add(Duration(days: dayIndex));
    print(
        "Wybrana data: ${selectedDate.day}-${selectedDate.month}-${selectedDate.year}");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          _pageController.nextPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut); // Przesunięcie w lewo
        } else if (details.primaryVelocity! > 0) {
          _pageController.previousPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut); // Przesunięcie w prawo
        }
      },
      child: Container(
        height: 100,
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (page) {
            _updateWeekForPage(page);
          },
          itemBuilder: (context, index) {
            return _buildWeekView();
          },
        ),
      ),
    );
  }

  Widget _buildWeekView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(days.length, (index) {
        bool isSelected = index ==
            selectedDayIndex; // Jeden wspólny wskaźnik dla wszystkich tygodni

        // Dodajemy margines dla pierwszego i ostatniego elementu
        EdgeInsetsGeometry margin = EdgeInsets.symmetric(horizontal: 8);
        if (index == 0) {
          margin = EdgeInsets.only(left: 16, right: 8); // Pierwszy element
        } else if (index == days.length - 1) {
          margin = EdgeInsets.only(left: 8, right: 16); // Ostatni element
        }

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedDayIndex =
                  index; // Zmieniamy selectedDayIndex dla wszystkich tygodni
              _returnSelectedDate(
                  index); // Wywołujemy funkcję, która drukuje datę dla klikniętego dnia
            });
          },
          child: Container(
            margin: margin,
            child: Column(
              children: [
                Text(
                  days[index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.green : Colors.grey,
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.green : Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    dates[index].toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
