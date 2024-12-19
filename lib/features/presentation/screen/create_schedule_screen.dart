import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:singerapp/core/native_toast.dart';
import 'package:singerapp/features/domain/models/schedule.dart';
import 'package:singerapp/features/presentation/cubits/schedule_cubit.dart';

class CreateScheduleScreen extends StatefulWidget {
  const CreateScheduleScreen({super.key});

  @override
  State<CreateScheduleScreen> createState() => _CreateScheduleScreenState();
}

class _CreateScheduleScreenState extends State<CreateScheduleScreen> {
  final _feeController = MoneyMaskedTextController(
    decimalSeparator: ',',
    thousandSeparator: '.',
    leftSymbol: 'R\$ ',
  );
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _additionalMusicianFeeController =
      TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _paidInAdvance = false;
  bool _hasAdditionalMusicians = false;

  @override
  void dispose() {
    _locationController.dispose();
    _feeController.dispose();
    _additionalMusicianFeeController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedDate == null || _selectedTime == null) {
        NativeToast.show(
          'Por favor, selecione data e horário!',
          duration: ToastDuration.long,
        );
        return;
      }

      final DateTime scheduleTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      if (scheduleTime.isBefore(DateTime.now())) {
        NativeToast.show(
          'Não é possível criar agendamento para o passado.',
          duration: ToastDuration.long,
        );
        return;
      }

      final schedule = Schedule(
        id: DateTime.now().millisecondsSinceEpoch,
        location: _locationController.text,
        amount: double.parse(_feeController.text
            .replaceAll('R\$', '')
            .replaceAll('.', '')
            .replaceAll(',', '.')),
        isPaid: _paidInAdvance,
        showTime: scheduleTime,
        hasAdditionalMusicians: _hasAdditionalMusicians,
        additionalMusicianFee: _hasAdditionalMusicians
            ? double.parse(_additionalMusicianFeeController.text)
            : 0.0,
      );

      context.read<ScheduleCubit>().addSchedule(schedule);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Agendamento'),
      ),
      body: BlocListener<ScheduleCubit, ScheduleState>(
        listener: (context, state) {
          if (state is ScheduleConflictError) {
            NativeToast.show(
              state.message,
              duration: ToastDuration.long,
            );
          } else if (state is ScheduleLoaded) {
            NativeToast.show(
              'Agendamento criado com sucesso!',
              duration: ToastDuration.long,
            );
            Navigator.pop(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Local',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Insira o local' : null,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _feeController,
                  decoration: const InputDecoration(
                    labelText: 'Valor do Acerto',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => _feeController.numberValue <= 0
                      ? 'Insira um valor válido'
                      : null,
                ),
                const SizedBox(height: 16.0),
                ListTile(
                  title: Text(
                    'Data do Show: ${_selectedDate != null ? dateFormat.format(_selectedDate!) : 'Selecionar'}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: _pickDate,
                ),
                const SizedBox(height: 16.0),
                ListTile(
                  title: Text(
                    'Horário do Show: ${_selectedTime != null ? _selectedTime!.format(context) : 'Selecionar'}',
                  ),
                  trailing: const Icon(Icons.access_time),
                  onTap: _pickTime,
                ),
                const SizedBox(height: 16.0),
                SwitchListTile(
                  title: const Text('Pago Adiantado?'),
                  value: _paidInAdvance,
                  onChanged: (value) => setState(() => _paidInAdvance = value),
                ),
                SwitchListTile(
                  title: const Text('Mais Músicos na Banda?'),
                  value: _hasAdditionalMusicians,
                  onChanged: (value) =>
                      setState(() => _hasAdditionalMusicians = value),
                ),
                if (_hasAdditionalMusicians)
                  TextFormField(
                    controller: _additionalMusicianFeeController,
                    decoration: const InputDecoration(
                      labelText: 'Valor por Músico Adicional',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Insira o valor'
                        : null,
                  ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Salvar Agendamento'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
