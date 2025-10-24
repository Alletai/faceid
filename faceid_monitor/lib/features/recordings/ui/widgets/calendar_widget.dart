import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/k_spacers.dart';

/// Widget de calendário personalizado
class CalendarWidget extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const CalendarWidget({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _displayMonth;

  @override
  void initState() {
    super.initState();
    _displayMonth = DateTime(widget.selectedDate.year, widget.selectedDate.month);
  }

  void _changeMonth(int delta) {
    setState(() {
      _displayMonth = DateTime(_displayMonth.year, _displayMonth.month + delta);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: KPadding.a16,
      child: Column(
        children: [
          // Header com mês/ano e navegação
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_getMonthName(_displayMonth.month)} ${_displayMonth.year}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(BootstrapIcons.chevron_left),
                    onPressed: () => _changeMonth(-1),
                  ),
                  IconButton(
                    icon: const Icon(BootstrapIcons.chevron_right),
                    onPressed: () => _changeMonth(1),
                  ),
                ],
              ),
            ],
          ),
          KSpacer.v16,

          // Grid do calendário
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final daysInMonth = DateTime(_displayMonth.year, _displayMonth.month + 1, 0).day;
    final firstWeekday = DateTime(_displayMonth.year, _displayMonth.month, 1).weekday;

    // Ajustar para domingo ser 0
    final startOffset = firstWeekday == 7 ? 0 : firstWeekday;

    return Column(
      children: [
        // Dias da semana
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['D', 'S', 'T', 'Q', 'Q', 'S', 'S']
              .map((day) => SizedBox(
                    width: 40,
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ))
              .toList(),
        ),
        KSpacer.v8,

        // Grid de dias
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: startOffset + daysInMonth,
          itemBuilder: (context, index) {
            if (index < startOffset) {
              return const SizedBox.shrink();
            }

            final day = index - startOffset + 1;
            final date = DateTime(_displayMonth.year, _displayMonth.month, day);
            final isSelected = date.day == widget.selectedDate.day &&
                date.month == widget.selectedDate.month &&
                date.year == widget.selectedDate.year;
            final isToday = date.day == DateTime.now().day &&
                date.month == DateTime.now().month &&
                date.year == DateTime.now().year;

            return _buildDayCell(day, isSelected, isToday, date);
          },
        ),
      ],
    );
  }

  Widget _buildDayCell(int day, bool isSelected, bool isToday, DateTime date) {
    return InkWell(
      onTap: () => widget.onDateSelected(date),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.accentCyan
              : isToday
                  ? AppTheme.secondaryNavy
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isToday && !isSelected
              ? Border.all(color: AppTheme.accentCyan)
              : null,
        ),
        child: Center(
          child: Text(
            day.toString(),
            style: TextStyle(
              color: isSelected
                  ? AppTheme.primaryNavy
                  : AppTheme.textPrimary,
              fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];
    return months[month - 1];
  }
}
