import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../splashScreen/splashScreen.dart';

class PolicyScreen extends StatefulWidget {
  @override
  _PolicyScreenState createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  bool _isPolicyChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('سياسة الاستخدام'),
        centerTitle: true, // محاذاة العنوان في الوسط
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Directionality(
          textDirection: TextDirection.rtl, // تعيين اتجاه النص والعناصر من اليمين إلى اليسار
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: RichText(
                    textAlign: TextAlign.justify, // ضبط النص ليكون بمحاذاة كاملة
                    text: TextSpan(
                      style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
                      children: [
                        TextSpan(
                          text: 'مرحبًا بكم في تطبيقنا التعليمي. نحن نسعى جاهدين لتقديم محتوى ذو جودة عالية يساعد في تطوير مهاراتكم ومعرفتكم. لاستخدام هذا التطبيق بالشكل الأمثل، يُرجى قراءة سياسة الاستخدام التالية بعناية والالتزام بها:\n\n',
                        ),
                        TextSpan(
                          text: '1. الخصوصية وحفظ المحتوى:\n',
                          style: TextStyle(fontWeight: FontWeight.bold), // جعل العنوان عريضًا
                        ),
                        TextSpan(
                          text: '- يُمنع تمامًا على جميع المستخدمين تسجيل أو تسريب أو مشاركة أي من المحاضرات أو المحتويات المتاحة داخل التطبيق بأي وسيلة كانت، سواء إلكترونية أو غير ذلك، دون الحصول على إذن كتابي مسبق من إدارة التطبيق أو مالكي المحتوى.\n',
                        ),
                        TextSpan(
                          text: '- جميع المحاضرات والمحتويات المتاحة في هذا التطبيق هي ملكية فكرية محفوظة الحقوق. أي محاولة لنشر أو إعادة توزيع المحتوى بشكل غير قانوني تُعتبر انتهاكًا صريحًا لهذه الحقوق.\n\n',
                        ),
                        TextSpan(
                          text: '2. المسؤولية القانونية:\n',
                          style: TextStyle(fontWeight: FontWeight.bold), // جعل العنوان عريضًا
                        ),
                        TextSpan(
                          text: '- في حال تم تسريب أو تسجيل أي محاضرة أو محتوى من التطبيق، ستقوم إدارة التطبيق باتخاذ الإجراءات القانونية اللازمة ضد المسؤولين عن هذا الانتهاك. جميع التبعات القانونية الناتجة عن هذا الانتهاك يتحملها المستخدم المخالف بشكل كامل.\n',
                        ),
                        TextSpan(
                          text: '- تشمل التبعات القانونية مطالبات بالتعويض المالي عن الأضرار التي تلحق بحقوق الملكية الفكرية، وقد تؤدي إلى فرض عقوبات قانونية إضافية وفق القوانين المعمول بها محليًا ودوليًا.\n\n',
                        ),
                        TextSpan(
                          text: '3. التزامات المستخدم:\n',
                          style: TextStyle(fontWeight: FontWeight.bold), // جعل العنوان عريضًا
                        ),
                        TextSpan(
                          text: '- يتعهد المستخدم باستخدام المحتوى المتاح داخل التطبيق لأغراض شخصية وتعليمية فقط.\n',
                        ),
                        TextSpan(
                          text: '- يُمنع منعًا باتًا إعادة توزيع أو نشر أي محتوى أو محاضرات بأي وسيلة كانت دون الحصول على إذن مسبق من إدارة التطبيق.\n\n',
                        ),
                        TextSpan(
                          text: 'باستخدامك لهذا التطبيق، فإنك توافق وتتعهد بالالتزام بجميع الشروط المذكورة أعلاه. وفي حال انتهاك أي من هذه البنود، فإن المستخدم يتحمل كافة العواقب القانونية والمالية دون أي استثناءات.\n\n',
                        ),
                        TextSpan(
                          text: 'نشكركم على التزامكم بهذه السياسة ونتمنى لكم تجربة تعليمية مثمرة ومفيدة.',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: _isPolicyChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        _isPolicyChecked = value ?? false;
                      });
                    },
                  ),
                  Text('لقد قرأت سياسة الاستخدام'),
                ],
              ),
              ElevatedButton(
                onPressed: _isPolicyChecked
                    ? () async {
                  // حفظ حالة قراءة السياسة
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isPolicyAccepted', true);

                  // الانتقال إلى الشاشة الرئيسية
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SplashScreen()),
                  );
                }
                    : null, // تعطيل الزر في حالة لم يتم تحديد Checkbox
                child: Text('أوافق على السياسة'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
