import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeUserWidget extends StatefulWidget {
  HomeUserWidget({Key? key}) : super(key: key);

  @override
  State<HomeUserWidget> createState() => _HomeUserWidgetState();
}

class _HomeUserWidgetState extends State<HomeUserWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return

      Container(
        alignment: Alignment.bottomLeft,
        padding:
        const EdgeInsets.only(top: 50, left: 2, right: 2, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: gotoProfile,
              child:  CircleAvatar(
                radius: 36,
                backgroundColor: Colors.white,
                child: Hero(
                  tag: 'profileImage',
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius:35,
                    child: Text(
                        //Provider.of<UserProvider>(context).user!.name[0],
                      "AM",
                      style: GoogleFonts.abel(
                        color: Colors.white,
                        fontSize: 30
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, Arinaho',
                  style: GoogleFonts.abel(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
                Row(children:[
                  Text(
                   // Provider.of<UserProvider>(context).user!.email,
                    'arinaho.muleba@bbd.co.za',
                    style: GoogleFonts.abel(color: Colors.blueGrey),
                  ),
                  // if(Provider.of<UserProvider>(context).user!.isModerator)
                    const Icon(Icons.verified_user_rounded, color: Colors.green, size: 15,),

                  // if(Provider.of<UserProvider>(context).user!.isVerified)
                    const Icon(Icons.verified_rounded, color: Colors.lightBlueAccent,size: 15,),

                ]),
              ],
            ),
            const Spacer(),
            IconButton(
                onPressed: () {
                //   Navigator.of(context).push(MaterialPageRoute(
                //       //builder: (context) => SettingsPage()));
                },
                icon: const FaIcon(
                  FontAwesomeIcons.gear,
                  color: Colors.blue,
                  size: 20,
                )),
          ],
        ),
      );
  }

  void gotoProfile() {
    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (context) => ProfilePage()));
  }
}