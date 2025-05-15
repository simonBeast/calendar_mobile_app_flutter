import 'package:calendar_app/My_Drawer.dart';
import 'package:intl/intl.dart';
import 'package:geezdate/geezdate.dart' hide DateFormat;
import 'package:flutter/material.dart';

class CalendarHomePage extends StatefulWidget {

  CalendarHomePage({super.key,required this.isDarkMode,required this.setIsDarkMode});
  
  final isDarkMode; 
  void Function() setIsDarkMode;
  @override
  State<CalendarHomePage> createState() => _CalendarHomePageState();
}

class _CalendarHomePageState extends State<CalendarHomePage> {
  DateTime _selectedDate = DateTime.now();
  final FormatLanguage _language = FormatLanguage.am;

  List<DateTime> _generateMonthDates(DateTime date) {
    final lastDay = DateTime(date.year, date.month + 1, 0);
    return List.generate(lastDay.day, (index) => DateTime(date.year, date.month, index + 1));
  }

  String _getFormattedEthiopianDate(DateTime gregorianDate) {
    final ethiopianDate = GeezDate.fromDateTime(gregorianDate);
    return ethiopianDate.format(
      '.D, .M .d, .Y .E',
      lang: _language
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beast Calendar',style:TextStyle(
          color: Theme.of(context).colorScheme.onPrimary
        ) ,),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: MyDrawer(setIsDarkMode: widget.setIsDarkMode, isDark: widget.isDarkMode),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
         Text(
              'Gregorian: ${DateFormat('EEEE, MMMM d, y').format(_selectedDate)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Theme.of(context).colorScheme.onBackground ),
            ),
            
            Text(
              'Ethiopian: ${_getFormattedEthiopianDate(_selectedDate)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Theme.of(context).colorScheme.onBackground),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
              IconButton(onPressed: (){
                setState(() {
                  _selectedDate = _selectedDate.subtract(Duration(days: 30));
                });
                
              }, icon: Icon(Icons.arrow_left)),
              Text('${DateFormat('MMMM').format(_selectedDate)}(${GeezDate.fromDateTime(_selectedDate).format('.M', lang: _language )})'),
               IconButton(onPressed: (){
                 setState(() {
                  _selectedDate =  _selectedDate.add(Duration(days: 30));
               });
              }, icon: Icon(Icons.arrow_right)),
            ]),
            const SizedBox(height: 20),
            Text(
              'Select a Day:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.onBackground),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                itemCount: _generateMonthDates(_selectedDate).length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                ),
                itemBuilder: (context, index) {
                  final day = _generateMonthDates(_selectedDate)[index];
                  final isSelected = _selectedDate.year == day.year &&
                      _selectedDate.month == day.month &&
                      _selectedDate.day == day.day;

                  return GestureDetector(
                    onTap: () => setState(() => _selectedDate = day),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(10),),
                      alignment: Alignment.center,
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSecondary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.calendar_month,color: Theme.of(context).colorScheme.onPrimary,),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary
              ),
              label: Text('Pick a Date',style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() => _selectedDate = picked);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}