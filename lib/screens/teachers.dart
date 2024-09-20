import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graduate/course_page/coures_page.dart';
import 'package:provider/provider.dart';
import '../course_page/shortcut/customBoxDocoration.dart';
import '../course_page/shortcut/customCard.dart';
import '../login_singup/auth/token_manager.dart';
import '../main.dart';
import '../splashScreen/customLoadingIndicator.dart';
import '../themee/theme_notifier.dart';

class Teachers extends StatefulWidget {
  final String departmentId;
  final bool showPrice;
  Teachers({super.key, required this.departmentId, required this.showPrice});

  @override
  State<Teachers> createState() => _TeachersState();
}

class _TeachersState extends State<Teachers> {
  late String depWhatsApp;
  String depTelegram = "----";
  late List<dynamic> instructors = [];
  late List<dynamic> filteredInstructors = [];
  late bool isLoaded = false;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_filterInstructors);
    _loadTeacherInfo();
  }

  Future<void> _loadTeacherInfo() async {
    final departmentData = await getTeacher();
    if (departmentData != null) {
      setState(() {
        depWhatsApp = departmentData['departmentContact'];
        instructors = departmentData['instructors'];
        filteredInstructors = instructors; // Initialize with all instructors
        isLoaded = true;
      });
    }
  }

  void _filterInstructors() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredInstructors = instructors.where((instructor) {
        final name = instructor['name'].toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Adjust the number of columns dynamically based on the screen width
    int crossAxisCount = screenWidth < 600
        ? 2
        : screenWidth < 900
        ? 3
        : 4;

    // Adjust the child aspect ratio based on screen height and width
    double childAspectRatio = screenWidth / (screenHeight * 0.9);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          "الأساتذة",
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            margin: EdgeInsets.all(10),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                PreferredSize(
                  preferredSize: Size.fromHeight(50),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'البحث ...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Color(0xff32DDE6), width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Color(0xff28A8AF), width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Color(0xff247D95), width: 2),
                          ),
                          suffixIcon: Icon(Icons.search, color: mainColors),
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodySmall?.color, // Correct way to access primary color
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: isLoaded
                      ? GridView.builder(
                    itemCount: filteredInstructors.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: childAspectRatio,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CoursePage(
                              TeacherId: filteredInstructors[index]['id'],
                              depWhatsApp: depWhatsApp,
                              depTelegram: depTelegram,
                              showPrice: widget.showPrice,
                            ),
                          ));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                          decoration: CustomBoxDecoration(
                              context,
                              themeNotifier.customThemeIndex == 3
                                  ? Color(0xffFF4D6D)
                                  : teacherThemeBegin),
                          child: Column(
                            children: [
                              CustomCard(
                                imageUrl: filteredInstructors[index]['image']!,
                                title: filteredInstructors[index]['title']!,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                filteredInstructors[index]['name'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                      : CustomLoadingIndicator(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>?> getTeacher() async {
    try {
      var response = await ApiClient().getAuthenticatedRequest(context, "/api/Departments/instructors/${widget.departmentId}");
      if (response?.statusCode == 200) {
        return json.decode(response!.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
