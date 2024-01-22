import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spaza/widgets/homeUserWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomeScreenState();
}

class _HomeScreenState  extends State<HomePage> {

  double _blur = 0;
  bool isFabExpanded = true;
  final ScrollController _scrollController = ScrollController();
  List<String> messages = [
    'Welcome to Lucky\'s Spaza 😁',
    'Get the best deals on your favourite snacks',
    'Enjoy the best snacks in town',
    'I don\'t know what else to add😴',
  ];

  late Color color = Theme.of(context).scaffoldBackgroundColor;

  void handleScroll(double position) {
    if (position > 90) {
      setState(() {
        _blur = 10;
        color = Colors.white;
        isFabExpanded = false;

      });
    } else {
      setState(() {
        _blur = 0;
        color = Theme.of(context).scaffoldBackgroundColor;
        isFabExpanded = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //userProvider = Provider.of<UserProvider>(context, listen: false);
    _scrollController.addListener(() {
      //print('position: ${_scrollController.position.extentBefore}');
      handleScroll(_scrollController.position.extentBefore);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      extendBodyBehindAppBar: true,
      extendBody: true,
      floatingActionButton: FloatingActionButton.extended(
        extendedPadding: const EdgeInsets.all(18),
        enableFeedback: true,
        isExtended: isFabExpanded,
        heroTag: 'fab',
        icon:const  Icon(Icons.question_answer_rounded, color: Colors.white,),
        backgroundColor: Colors.lightBlueAccent,
        elevation: 5,
        onPressed: () {

          //_postQuestion(context);

        },
        label: Text('Get support' , style: GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),

      ),
      //drawer: DrawerWidget(),
      body:CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.2),
              pinned: true,
              title:AnimatedTextKit(
                repeatForever: true,
                pause: const Duration(seconds: 5),
                animatedTexts: messages.map((e) => TypewriterAnimatedText(
                  e,
                  textStyle: GoogleFonts.roboto(
                      fontSize: 14, color: Colors.blueGrey),
                  speed: const Duration(milliseconds: 100),
                )).toList(
                ),
              ),
              leading: Builder(
                builder: (context) => IconButton(
                  icon:
                  const FaIcon(
                    FontAwesomeIcons.bars,
                    color: Colors.lightBlue,
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),),
              actions: [
                IconButton(
                  onPressed: () {
                    //showSearch(context: context, delegate: QuestionSearchDelegate());
                  },
                  icon: const Icon(
                    //FontAwesomeIcons.magnifyingGlass,
                    Icons.shopping_cart,
                    color: Colors.blueGrey,
                  ),
                ),
              ],
              centerTitle: true,
              expandedHeight: 80 + 60,
              flexibleSpace: SizedBox(
                height: 200,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: _blur, sigmaY: _blur),
                    child: FlexibleSpaceBar(
                  background: HomeUserWidget(),

                    ),
                  ),
                ),
              ),
            ),
            // FutureBuilder(builder: (context, snapshot) {
            //   if (snapshot.hasData) {
            //     return SliverList(
            //       delegate: SliverChildBuilderDelegate(
            //         addAutomaticKeepAlives: true,
            //             (context, index) {
            //           return QuestionWidget(
            //             question: snapshot.data![index],
            //           );
            //         },
            //         childCount: snapshot.data!.length,
            //       ),
            //     );
            //   } else {
            //     return SliverFillRemaining(
            //       child: Center(
            //         child: CircularProgressIndicator.adaptive(),
            //       ),
            //     );
            //   }
            // },
              //future: Provider.of<QuestionsProvider>(context).allQuestions,
           SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                    height: 200,
                    decoration: BoxDecoration(
                      //color: Colors.lightBlueAccent.withOpacity(0.8),
                      color:Colors.lightBlueAccent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child:Center(
                      child: Text('$index'),
                    ),
                  );
                }, childCount: 300),

            ),

          ],
        ),


    );
  }

}