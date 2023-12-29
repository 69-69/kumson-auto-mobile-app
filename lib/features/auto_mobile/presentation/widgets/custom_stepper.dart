import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/elevated_btn.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/outline_btn.dart';

// Ref: https://medium.flutterdevs.com/stepper-widget-in-flutter-37ce5b45575b

class CustomStepper extends StatefulWidget {
  final List<Widget> contents;
  final Function(int) onSubmit;
  final List<String> titles;
  final List<String> labels;
  final List<String> subTitle;
  final String? doneLabel;
  final Widget? doneBtn;
  final double elevation;
  final GlobalKey<FormState>? formFieldKey;
  final StepperType? stepperType;

  const CustomStepper({
    super.key,
    this.stepperType,
    required this.contents,
    required this.onSubmit,
    this.labels = const [],
    this.titles = const [],
    this.subTitle = const [],
    this.elevation = 1.0,
    this.doneLabel,
    this.formFieldKey,
    this.doneBtn,
  });

  @override
  State<CustomStepper> createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  int _currentStep = 0;
  static const textStyle = TextStyle(
    fontSize: 10,
    overflow: TextOverflow.ellipsis,
  );

  @override
  Widget build(BuildContext context) {
    final appBarHeight = AppBar().preferredSize.height * 2;

    return IntrinsicHeight(
      child: SizedBox(
        height: SizeConfig.screenHeight! - appBarHeight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: buildStepper(),
            ),
          ],
        ),
      ),
    );
  }

  Stepper buildStepper() {
    return Stepper(
      type: widget.stepperType ?? StepperType.horizontal,
      elevation: widget.elevation,
      physics: const ScrollPhysics(),
      currentStep: _currentStep,
      onStepTapped: (step) => tapped(step),
      onStepContinue: continued,
      onStepCancel: cancel,
      steps: widget.contents
          .mapIndexed((index, e) => buildStep(e, index))
          .toList(),
      controlsBuilder: (BuildContext context, ControlsDetails details) {
        final isLastStep = _currentStep == widget.contents.length - 1;
        return buildControls(context, details, isLastStep);
      },
    );
  }

  buildControls(
      BuildContext context, ControlsDetails details, bool isLastStep) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          if (_currentStep != 0) ...{
            FittedBox(
              child: buildOutlinedBtn(context,
                  onPress: details.onStepCancel, label: 'Back'),
            ),
          },
          if (_currentStep > 0) ...{
            const SizedBox(width: 12),
          },
          isLastStep
              ? Expanded(
                  child: widget.doneBtn ??
                      _onStepContinueBtn(
                        context,
                        details,
                        widget.doneLabel ?? 'Submit',
                      ),
                )
              : Expanded(
                  child: _onStepContinueBtn(context, details, 'Next'),
                ),
        ],
      ),
    );
  }

  ElevatedButton _onStepContinueBtn(
      BuildContext context, ControlsDetails details, String label) {
    return buildElevatedBtn(
      context,
      onPress: details.onStepContinue,
      label: label,
    );
  }

  Step buildStep(Widget content, int index) {
    final labels = widget.labels;
    final titles = widget.titles;
    final subTitles = widget.subTitle;
    return Step(
      label: labels.isNotEmpty ? Text(labels[index]) : null,
      title: titles.isNotEmpty ? Text(titles[index]) : const SizedBox.shrink(),
      subtitle: subTitles.isNotEmpty
          ? Text(subTitles[index], style: textStyle)
          : null,
      content: content,
      isActive: _currentStep >= 0,
      state: _currentStep >= index ? StepState.complete : StepState.disabled,
    );
  }

  /* Step buildStepTwo() {
    return Step(
      title: const Text('Personal info'),
      subtitle: const Text('Helps to contact you', style: textStyle),
      content: widget.formTwo,
      isActive: _currentStep >= 0,
      state: _currentStep >= 1 ? StepState.complete : StepState.disabled,
    );
  }*/

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    if (widget.formFieldKey == null) {
      debugPrint("stepper $_currentStep");
      _onPressContinued();
    } else {
      if (widget.formFieldKey!.currentState!.validate()) _onPressContinued();
    }
  }

  _onPressContinued() {
    widget.onSubmit(_currentStep);
    int totalStepper = widget.contents.length - 1;
    _currentStep < totalStepper ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

/*
  Step buildStepOne() {
    return Step(
      title: const Text('Vehicle info'),
      subtitle: const Text('Helps with review', style: textStyle),
      content: widget.formTwo,
      isActive: _currentStep >= 0,
      state: _currentStep >= 0 ? StepState.complete : StepState.disabled,
    );
  }

  Step buildStepTwo() {
    return Step(
      title: const Text('Personal info'),
      subtitle: const Text('Helps to contact you', style: textStyle),
      content: widget.formTwo,
      isActive: _currentStep >= 0,
      state: _currentStep >= 1 ? StepState.complete : StepState.disabled,
    );
  }

  Step buildStepTwo() {
     return Step(
        title: const Text('M'),
        content: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Mobile Number'),
            ),
          ],
        ),
        isActive: _currentStep >= 0,
        state: _currentStep >= 2 ? StepState.complete : StepState.disabled,
      );
    }

   switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }*/
}
