import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ccxgui/bloc/settings_bloc/settings_bloc.dart';
import 'package:ccxgui/models/settings_model.dart';
import 'package:ccxgui/repositories/settings_repository.dart';
import 'package:ccxgui/utils/constants.dart';
import 'package:ccxgui/utils/responsive.dart';

class CurrentCommandContainer extends StatelessWidget {
  final SettingsRepository settingsRepository = SettingsRepository();

  CurrentCommandContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is CurrentSettingsState) {
          SettingsModel settings = state.settingsModel;
          List<String> paramsList = settingsRepository.getParamsList(settings);
          return Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Current Command: ',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      context.read<SettingsBloc>().add(
                            ResetSettingsEvent(),
                          );
                    },
                    child: Row(
                      children: [
                        Icon(Icons.restore, color: Colors.redAccent, size: 20),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Reset settings',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 12),
              Container(
                width: Responsive.isDesktop(context)
                    ? MediaQuery.of(context).size.width - 270
                    : MediaQuery.of(context).size.width -
                        56, // remove drawer width
                decoration: BoxDecoration(
                  color: kBgLightColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SelectableText(
                    'ccextractor --gui_mode_reports ${paramsList.reduce((value, element) => value + ' ' + element)} +[input files]',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
