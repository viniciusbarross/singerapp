import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:singerapp/core/native_toast.dart';
import 'package:singerapp/features/domain/models/schedule.dart';
import 'package:singerapp/features/presentation/cubits/schedule_cubit.dart';

class ListSchedulesScreen extends StatelessWidget {
  const ListSchedulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final listSchedulesCubit = context.read<ScheduleCubit>();

    listSchedulesCubit.loadSchedules();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Agendamentos'),
      ),
      body: BlocBuilder<ScheduleCubit, ScheduleState>(
        bloc: context.read(),
        builder: (context, state) {
          if (state is ScheduleInitial) {
            return const Offstage();
          }
          if (state is ScheduleLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ScheduleLoaded) {
            if (state.schedules.isEmpty) {
              return const Center(
                child: Text(
                  'Nenhum agendamento encontrado.',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.schedules.length,
                    itemBuilder: (context, index) {
                      final Schedule schedule = state.schedules[index];

                      final formattedDate = DateFormat('dd/MM/yyyy HH:mm')
                          .format(schedule.showTime);

                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12.0),
                          title: Text(
                            'Local: ${schedule.location}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4.0),
                              Text(
                                  'Valor do Acerto: R\$ ${schedule.amount.toStringAsFixed(2)}'),
                              Text('Horário: $formattedDate'),
                              Text(
                                'Pago Adiantado: ${schedule.isPaid ? 'Sim' : 'Não'}',
                                style: TextStyle(
                                  color: schedule.isPaid
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (schedule.hasAdditionalMusicians)
                                Text(
                                  'Músico Adicional: R\$ ${schedule.additionalMusicianFee.toStringAsFixed(2)}',
                                ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _confirmDelete(context, schedule);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                _buildSummary(state.schedules)
              ],
            );
          }

          return const Center(
            child: Text(
              'Erro ao carregar os agendamentos.',
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create-schedule');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Schedule schedule) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Agendamento'),
          content:
              const Text('Tem certeza de que deseja excluir este agendamento?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                context.read<ScheduleCubit>().deleteSchedule(schedule.id!);
                Navigator.of(context).pop();
                NativeToast.show(
                  'Agendamento excluído com sucesso!',
                  duration: ToastDuration.long,
                );
              },
              child: const Text(
                'Excluir',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummary(List<Schedule> schedules) {
    final totalPaid =
        schedules.where((s) => s.isPaid).fold(0.0, (sum, s) => sum + s.amount);

    final totalUnpaid =
        schedules.where((s) => !s.isPaid).fold(0.0, (sum, s) => sum + s.amount);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumo Financeiro',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Total Pago: R\$ ${totalPaid.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16, color: Colors.green),
          ),
          Text(
            'Total a Receber: R\$ ${totalUnpaid.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
