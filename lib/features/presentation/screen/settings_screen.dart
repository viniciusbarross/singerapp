import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:singerapp/features/presentation/cubits/background_cubit.dart';
import 'dart:io';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<BackgroundCubit, File?>(
              builder: (context, backgroundImage) {
                if (backgroundImage != null) {
                  return Image.file(
                    backgroundImage,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
                } else {
                  return Center(
                    child: Text(
                      'Nenhuma imagem selecionada',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                context.read<BackgroundCubit>().selectBackgroundImage();
              },
              child: const Text('Selecionar Imagem de Fundo'),
            ),
          ),
        ],
      ),
    );
  }
}
