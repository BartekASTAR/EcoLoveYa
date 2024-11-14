import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_life/data_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WeeklyBarStats extends StatefulWidget {
  @override
  _WeeklyBarStatsState createState() => _WeeklyBarStatsState();
}

class _WeeklyBarStatsState extends State<WeeklyBarStats> {
  int selectedDayIndex = 0; // Jeden wspólny wskaźnik dla wszystkich tygodni
  late DateTime currentWeekStart;
  PageController _pageController = PageController(
      initialPage: 1000); // Środek dla przeglądania poprzednich tygodni
  final List<String> days = ['P', 'W', 'Ś', 'C', 'P', 'S', 'N'];
  List<int> dates = [];
  List<String> currentWeekDatesList = [];
  final User user = FirebaseAuth.instance.currentUser!;
  int totalMass = 0;
  int totalEmission = 0;
  int totalUsage = 0;
  bool isLoading = true;
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    totalMass = 0;
    totalEmission = 0;
    _initializeCurrentWeek();
  }

  void _initializeCurrentWeek() {
    DateTime now = DateTime.now();
    currentWeekStart = now.subtract(
        Duration(days: now.weekday - 1)); // Poniedziałek tego tygodnia
    _updateWeekDates();
    selectedDayIndex =
        now.weekday - 1; // Ustawienie zaznaczenia na bieżący dzień tygodnia
    _returnSelectedDateHabits(selectedDayIndex);
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

  Future _returnSelectedDateHabits(int dayIndex) async {
    _changeSelectedDate(dayIndex);
    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection("dates")
        .doc(context.read<DataProvider>().selectedDate)
        .get();
    if (document.exists) {
      //await FirebaseFirestore.instance.collection('users').doc(user.uid).collection("dates").doc(context.read<DateProvider>().selectedDate);
    } else {
      _createDate(context.read<DataProvider>().selectedDate);
    }
  }

  Future _createDate(String selectedDate) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection("dates")
        .doc(selectedDate)
        .set({
      'bag_mass': 0,
      'bag_emission': 0,
      'bottle_mass': 0,
      'bottle_emission': 0,
      'trash_mass': 0,
      'trash_emission': 0,
      'water_usage': 0,
      'car_emission': 0,
      'meat_emission': 0,
    });
  }

  void _changeSelectedDate(int dayIndex) {
    DateTime selectedDate = currentWeekStart.add(Duration(days: dayIndex));
    String date = "";

    if (selectedDate.day < 10) {
      date += "0" + selectedDate.day.toString() + "-";
    } else {
      date += selectedDate.day.toString() + "-";
    }
    if (selectedDate.month < 10) {
      date += "0" + selectedDate.month.toString() + "-";
    } else {
      date += selectedDate.month.toString() + "-";
    }
    date += selectedDate.year.toString();
    //print(date);

    if (currentWeekDatesList.contains(date)) {
      context.read<DataProvider>().changeSelectedDate(newSelectedDate: date);
    } else {
      context.read<DataProvider>().changeSelectedDate(newSelectedDate: date);
      fetchStats();
    }
  }

  Widget buildButton(BuildContext context, String value, String text) =>
      MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: () {},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      );

  Widget buildDivider() => Container(
        height: 28,
        child: VerticalDivider(),
      );

  List<String> getWeekDates(String date) {
    // Format daty wejściowej
    DateFormat inputFormat = DateFormat('dd-MM-yyyy');
    DateTime inputDate = inputFormat.parse(date);

    // Znajdź pierwszy dzień tygodnia (poniedziałek)
    int dayOfWeek = inputDate.weekday; // 1 - poniedziałek, 7 - niedziela
    DateTime monday = inputDate.subtract(Duration(days: dayOfWeek - 1));

    // Przygotowanie formatu wyjściowego
    DateFormat outputFormat = DateFormat('dd-MM-yyyy');

    // Lista, która przechowa wszystkie daty tygodnia
    List<String> weekDates = [];

    // Dodaj wszystkie dni tygodnia do listy (poniedziałek - niedziela)
    for (int i = 0; i < 7; i++) {
      DateTime currentDay = monday.add(Duration(days: i));
      weekDates.add(outputFormat.format(currentDay));
    }
    return weekDates;
  }

  Future<void> fetchStats() async {
    // Pobranie listy dat dla bieżącego tygodnia
    currentWeekDatesList =
        getWeekDates(context.read<DataProvider>().selectedDate);
    totalMass = 0;
    totalEmission = 0;
    totalUsage = 0;

    CollectionReference collectionRef = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("dates");

    // Zapytanie z filtrem "whereIn" na liście currentWeekDatesList
    QuerySnapshot querySnapshot = await collectionRef
        .where(FieldPath.documentId, whereIn: currentWeekDatesList)
        .get();

    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      data.forEach((key, value) {
        if (key.endsWith('_mass') && value is int) {
          totalMass += value;
        }
        if (key.endsWith('_emission') && value is int) {
          totalEmission += value;
        }
        if (key.endsWith('_usage') && value is int) {
          totalUsage += value;
        }
      });
    });

    setState(() {
      isLoading = false;
    });
  }

  Future<void> checkIfRefresh() async {
    if (context.watch<DataProvider>().shouldRefresh) {
      isLoading = true;
      await Future.delayed(Duration(milliseconds: (0.4 * 1000).toInt()));
      await fetchStats().then((_) {
        setState(() {});
        isLoading = false;
      });
      context.read<DataProvider>().setShouldRefresh(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    checkIfRefresh();
    if (isLoading) {
      return Column(
        children: [
          GestureDetector(
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
              height: 65,
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
          ),
          CircularProgressIndicator(
            color: Colors.green.shade400,
          )
        ],
      );
    }

    return Column(
      children: [
        GestureDetector(
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
            height: 65,
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
        ),
        SizedBox(
          height: 5,
        ),
        Text(textAlign: TextAlign.center, "Statystyki tygodnia:"),
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildButton(context, totalMass.toString(), 'g plastiku'),
              buildDivider(),
              buildButton(context, totalUsage.toString(), 'l wody'),
              // tu można podmienić na inną wartość
              buildDivider(),
              buildButton(context, (totalEmission / 1000).toString(), 'kg CO2'),
            ],
          ),
        )
      ],
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
              _returnSelectedDateHabits(index);
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
                    color: isSelected ? Colors.green[400] : Colors.grey,
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color:
                        isSelected ? Colors.green[400] : Colors.grey.shade200,
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
