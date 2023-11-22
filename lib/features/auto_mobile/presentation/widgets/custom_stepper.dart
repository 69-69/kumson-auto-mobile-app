import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/elevated_btn.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

// Ref: https://medium.flutterdevs.com/stepper-widget-in-flutter-37ce5b45575b

class CustomStepper extends StatefulWidget {
  final List<Widget> stepperContents;
  final Function(int) onSubmit;
  final List<String> titles;
  final List<String> subTitle;

  const CustomStepper({
    super.key,
    required this.stepperContents,
    required this.onSubmit,
    required this.titles,
    required this.subTitle,
  });

  @override
  State<CustomStepper> createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  static const textStyle = TextStyle(
    fontSize: 10,
    overflow: TextOverflow.ellipsis,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.screenHeight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: buildStepper(),
          ),
        ],
      ),
    );
  }

  Stepper buildStepper() {
    return Stepper(
      type: stepperType,
      physics: const ScrollPhysics(),
      currentStep: _currentStep,
      onStepTapped: (step) => tapped(step),
      onStepContinue: continued,
      onStepCancel: cancel,
      steps: widget.stepperContents
          .mapIndexed((index, e) => buildStepOne(e, index))
          .toList(),
      controlsBuilder: (BuildContext context, ControlsDetails details) {
        final isLastStep = _currentStep == widget.stepperContents.length - 1;
        return buildControls(context, details, isLastStep);
      },
    );
  }

  Container buildControls(
      BuildContext context, ControlsDetails details, bool isLastStep) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          Expanded(
            child: buildElevatedBtn(context,
                onPress: details.onStepContinue,
                label: isLastStep ? 'Send' : 'Next'),
          ),
          const SizedBox(width: 12),
          if (_currentStep != 0)
            Expanded(
              child: buildElevatedBtn(context,
                  onPress: details.onStepCancel, label: 'Back'),
            )
        ],
      ),
    );
  }

  Step buildStepOne(Widget content, int index) {
    return Step(
      title: Text('${widget.titles[index]} Info'),
      subtitle: Text(widget.subTitle[index], style: textStyle),
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
    debugPrint("stepper $_currentStep");
    widget.onSubmit(_currentStep);
    int totalStepper = widget.stepperContents.length - 1;
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
