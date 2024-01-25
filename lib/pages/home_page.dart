import 'dart:ui';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:spaza/firebase/database/items_database.dart';
import 'package:spaza/models/item.dart';
import 'package:spaza/pages/cart_page.dart';
import 'package:spaza/providers/cart_provider.dart';
import 'package:spaza/providers/userProvider.dart';
import 'package:spaza/sheets/add_item_sheet.dart';
import 'package:spaza/widgets/drawer.dart';
import 'package:spaza/widgets/homeUserWidget.dart';
import 'package:spaza/widgets/item_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  double _blur = 0;
  bool isFabExpanded = true;
  final ScrollController _scrollController = ScrollController();
  List<String> messages = [
    'Welcome to Lucky\'s Spaza 😁',
    'Get the best deals on best food',
    'Enjoy the best food in town',
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

  Future<List<Item>> itemsFuture = ItemDatabase.getItems();

  bool isLoading = false;

  void refresh() {
    print("refreshing");
    setState(() {
      itemsFuture = ItemDatabase.getItems();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
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
      drawer: const DrawerWidget(),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      extendBodyBehindAppBar: true,
      extendBody: true,
      floatingActionButton: Provider.of<UserProvider>(context).user!.isAdmin
          ? FloatingActionButton.extended(
              extendedPadding: const EdgeInsets.all(18),
              enableFeedback: true,
              isExtended: isFabExpanded,
              heroTag: 'fab',
              icon: const Icon(
                Icons.add_rounded,
                color: Colors.white,
              ),
              backgroundColor: Colors.lightBlueAccent,
              elevation: 5,
              onPressed: () {
                postItem(context);
              },
              label: Text(
                'Add Items',
                style: GoogleFonts.abel(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            )
          : null,
      //drawer: DrawerWidget(),
      body: LiquidPullToRefresh(
        height: MediaQuery.of(context).size.height * 0.3,
        animSpeedFactor: 5,
        springAnimationDurationInMilliseconds: 1000,
        onRefresh: () async {
          setState(() {
            itemsFuture = ItemDatabase.getItems();
          });
          await Future.delayed(const Duration(seconds: 1));
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              backgroundColor:
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.2),
              pinned: true,
              title: AnimatedTextKit(
                repeatForever: true,
                pause: const Duration(seconds: 5),
                animatedTexts: messages
                    .map((e) => TypewriterAnimatedText(
                          e,
                          textStyle: GoogleFonts.roboto(
                              fontSize: 14, color: Colors.blueGrey),
                          speed: const Duration(milliseconds: 100),
                        ))
                    .toList(),
              ),
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.bars,
                    color: Colors.lightBlue,
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              actions: [
                if (!Provider.of<UserProvider>(context).user!.isAdmin)
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => CartPage()));
                    },
                    icon: Badge(
                      isLabelVisible:
                          Provider.of<CartProvider>(context).totalItems > 0,
                      label: Text(
                        '${Provider.of<CartProvider>(context).totalItems}',
                        style: GoogleFonts.abel(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      child: const Icon(
                        FontAwesomeIcons.cartShopping,
                        color: Colors.blueGrey,
                      ),
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
            FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      addAutomaticKeepAlives: true,
                      (context, index) {
                        return ItemWidget(
                          item: snapshot.data![index],
                          onRemove: refresh,
                        );
                      },
                      childCount: snapshot.data!.length,
                    ),
                  );
                } else {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  );
                }
              },
              future: itemsFuture,
            ),
          ],
        ),
      ),
    );
  }

  void postItem(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) => DraggableScrollableSheet(
              snap: true,
              snapSizes: const [
                0.8,
              ],
              initialChildSize: 0.90,
              builder: (context, scrollController) {
                return SafeArea(
                    bottom: false,
                    child: PostItemSheet(
                      myController: scrollController,
                      callback: refresh,
                    ));
              },
            ));
  }
}
