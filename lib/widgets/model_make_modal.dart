import 'package:automasters/models/model.dart';
import 'package:flutter/material.dart';
import 'package:automasters/models/make.dart';
import 'package:string_capitalize/string_capitalize.dart';
import '../service/apiService.dart';
import '../utils/size_config.dart';

class ModelMakeModal extends StatefulWidget {
  const ModelMakeModal({super.key});

  @override
  State<ModelMakeModal> createState() => _ModelMakeModalState();
}

class _ModelMakeModalState extends State<ModelMakeModal> {
  late String getMakeRef;
  bool isCarMakeClicked = false;
  late Future<List<MakeModel>> getVehicleMake;

  @override
  void initState() {
    getVehicleMake = APIService().getMake();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);

    return SingleChildScrollView(
      primary: true,
      physics: const BouncingScrollPhysics(),
      child: Container(
        height: SizeConfig.screenHeight! * 0.9,
        padding: const EdgeInsets.only(
          top: 7.0,
          bottom: 20.0,
        ),
        child: Column(
          children: [
            IconButton.outlined(
              tooltip: isCarMakeClicked ? "Go Back" : "Close",
              onPressed: () {
                isCarMakeClicked
                    ? setState(() => isCarMakeClicked = false)
                    : Navigator.pop(context);
              },
              icon: Icon(
                isCarMakeClicked ? Icons.arrow_back : Icons.clear,
                color: Colors.black26,
              ),
            ),
            Text(
              isCarMakeClicked ? "Car Model" : "Car Make",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: getProportionateScreenWidth(20),
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const Divider(),
            Expanded(
              child: isCarMakeClicked && getMakeRef.isNotEmpty
                  ? buildFutureBuilderCarModel()
                  : buildFutureBuilderCarMake(),
            ),
          ],
        ),
      ),
    );
  }

  FutureBuilder<List<MakeModel>> buildFutureBuilderCarMake() {
    return FutureBuilder<List<MakeModel>>(
      future: getVehicleMake,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            // By default, show a loading spinner.
            return buildProgressBar();
          default:
            if (snapshot.hasData) {
              List<MakeModel> result = snapshot.data!;
              return snapshot.data!.isNotEmpty
                  ? buildGridViewCarMake(result)
                  : buildRefreshApp(context);
            } else {
              return const Text('Refresh App');
            }
        }
      },
    );
  }

  FutureBuilder<List<Model>> buildFutureBuilderCarModel() {
    return FutureBuilder<List<Model>>(
      future: APIService().getModel(getMakeRef),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            // By default, show a loading spinner.
            return buildProgressBar();
          default:
            if (snapshot.hasData) {
              List<Model> result = snapshot.data!;
              return snapshot.data!.isNotEmpty
                  ? buildGridViewCarModel(result)
                  : buildRefreshApp(context);
            } else {
              return const Text('Refresh App');
            }
        }
      },
    );
  }

  Center buildRefreshApp(BuildContext context) => Center(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              width: 1.0,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          onPressed: () {},
          child: const Text("Refresh App"),
        ),
      );

  Center buildProgressBar() => const Center(
        heightFactor: 1,
        widthFactor: 1,
        child: SizedBox(
          height: 40,
          width: 40,
          child: CircularProgressIndicator(
            strokeWidth: 5,
          ),
        ),
      );

  /// List view display[buildGridView]
  buildGridViewCarMake(List<MakeModel> result) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: result.length,
      padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 30.0),
      // physics: NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 6,
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) {
        MakeModel carMake = result[index];

        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(width: 1.0, color: Colors.red.shade100),
          ),
          onPressed: () {
            setState(() {
              isCarMakeClicked = true;
              getMakeRef = carMake.makeRef;
            });
          },
          child: Text(carMake.make.capitalizeEach(),
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        );
      },
    );
  }

  /// List view display[buildGridView]
  buildGridViewCarModel(List<Model> result) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: result.length,
      padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 30.0),
      // physics: NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 6,
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) {
        Model carMake = result[index];

        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(width: 1.0, color: Colors.red.shade100),
          ),
          onPressed: () {},
          child: Text(carMake.model.capitalizeEach(),
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        );
      },
    );
  }
}
