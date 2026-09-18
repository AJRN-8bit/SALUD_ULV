import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salud_ulv_app/src/features/presentation/screens/records/anthropometrics/anthro_records_page.dart';
import 'package:salud_ulv_app/src/features/presentation/screens/records/exercise/walk/walk_records_page.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/themes.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/buttons.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/containers.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/widgets/snackbar.dart';

class MainProgressPage extends StatelessWidget {
  const MainProgressPage({super.key});


  @override
  Widget build(BuildContext context) {

    return GradientBackground(
      // colors: [context.colors.background, context.colors.background],
      // stops: [0, 0.3],

      child: Scaffold(
        // appBar: AppBar(
        //   centerTitle: true,
        //   title: Text("Progreso"),
        //   backgroundColor: Colors.white,
        // ),
      
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.all(10),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: context.spacing.md,
            mainAxisSpacing: context.spacing.md,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            children: [
              GridActionTile(
                icon: FontAwesomeIcons.personWalking,
                label: 'Caminatas',
                onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => WalkRecordsPage()));},
              ),
              // GridActionTile(
              //   icon: FontAwesomeIcons.personRunning,
              //   label: 'Running',
              //   onTap: () => CustomSnackBar.show(context, message: "Proximamente"),
              // ),
              // GridActionTile(
              //   icon: FontAwesomeIcons.personBiking,
              //   label: 'Bicicleta',
              //   onTap: () => CustomSnackBar.show(context, message: "Proximamente"),
              // ),
              GridActionTile(
                icon: FontAwesomeIcons.person,
                label: 'Antropométricos',
                onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => AnthroRecordsPage()));},
              ),
              // GridActionTile(
              //   icon: Icons.restaurant,
              //   label: 'Nutrición',
              //   onTap: () {},
              // ),
              // GridActionTile(
              //   icon: Icons.person,
              //   label: 'Perfil',
              //   onTap: () {},
              // ),
            ],
          )
        ),
      ),
    );
  }
}

