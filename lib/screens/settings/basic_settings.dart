import 'package:ccxgui/bloc/settings_bloc/settings_bloc.dart';
import 'package:ccxgui/models/settings_model.dart';
import 'package:ccxgui/screens/dashboard/dashboard.dart';
import 'package:ccxgui/utils/constants.dart';
import 'package:ccxgui/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BasicSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        print(state);
        if (state is SettingsErrorState) {
          // If pasrsing local json gives error, go back to default values
          context.read<SettingsBloc>().add(SaveSettingsEvent(SettingsModel()));
          return Center(
            child: Container(
              child: Text(state.message),
            ),
          );
        }
        if (state is CurrentSettingsState) {
          TextEditingController outputFileNameController =
              TextEditingController(text: state.settingsModel.outputFilename);

          return Scaffold(
            appBar: AppBar(
              title: Text("Basic Settings"),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, right: 20),
                  child: MaterialButton(
                      child: Text("Apply"),
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        print(state.settingsModel.toJson().toString());
                        context
                            .read<SettingsBloc>()
                            .add(SaveSettingsEvent(state.settingsModel.copyWith(
                              outputFormat: state.settingsModel.outputFormat,
                              outputFilename: outputFileNameController.text,
                              append: state.settingsModel.append,
                              autoprogram: state.settingsModel.autoprogram,
                            )));
                        CustomSnackBarMessage.show(
                          context,
                          "Settings applied",
                        );
                      }),
                ),
              ],
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  ListTile(
                    title: Text("Output file name"),
                    subtitle: Text(
                      "This will define the output filename if you don't like the default ones, each file will be appeded with a _1, _2 when needed",
                    ),
                    trailing: Container(
                      color: kBgLightColor,
                      child: TextFormField(
                        controller: outputFileNameController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 6,
                          ),
                          isDense: true,
                        ),
                        cursorColor: Colors.transparent,
                      ),
                      width: Responsive.isDesktop(context) ? 300 : 100,
                    ),
                  ),
                  ListTile(
                    title: Text("Output file format"),
                    subtitle: Text(
                        "This will generate the output in the selected format."),
                    trailing: Container(
                      width: Responsive.isDesktop(context) ? 300 : 100,
                      child: DropdownButton<String>(
                        underline: Container(),
                        isExpanded: true,
                        value: state.settingsModel.outputFormat,
                        items: outputFormats.map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 8),
                              child: Text(value),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          context.read<SettingsBloc>().add(SettingsUpdatedEvent(
                                  state.settingsModel.copyWith(
                                outputFormat: newValue,
                              )));
                        },
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text("Append"),
                    subtitle: Text(
                      "This will prevent overwriting of existing files. The output will be appended instead.",
                    ),
                    trailing: Container(
                      child: Checkbox(
                        activeColor: Theme.of(context).accentColor,
                        value: state.settingsModel.append,
                        onChanged: (value) {
                          context.read<SettingsBloc>().add(SettingsUpdatedEvent(
                                  state.settingsModel.copyWith(
                                append: value,
                              )));
                        },
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text("Autoprogram"),
                    subtitle: Text(
                      "If there's more than one program in the stream, this will the first one we find that contains a suitable stream.",
                    ),
                    trailing: Container(
                      child: Switch(
                        activeColor: Theme.of(context).accentColor,
                        value: state.settingsModel.autoprogram,
                        onChanged: (value) {
                          context.read<SettingsBloc>().add(SettingsUpdatedEvent(
                                  state.settingsModel.copyWith(
                                autoprogram: value,
                              )));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
