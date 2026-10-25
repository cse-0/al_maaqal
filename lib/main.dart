// ============================================================================
// تطبيق جامعة المعقل الأكاديمي - قسم هندسة الأمن السيبراني
// مبرمج بالكامل بلغة Dart ومكتبة Flutter الأساسية فقط (بدون أي مكاتب خارجية)
// ============================================================================

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AlMaaqalUniversityApp());
}

/// دالة توحيد النصوص العربية لتسهيل البحث المطابق (توحيد الهمزات، التاء المربوطة، والمسافات)
String normalizeArabicText(String input) {
  return input
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[أإآ]'), 'ا')
      .replaceAll('ة', 'ه')
      .replaceAll('ى', 'ي')
      .replaceAll('عبد ', 'عبد')
      .replaceAll(RegExp(r'\s+'), ' ');
}

bool smartArabicMatch(String target, String query) {
  if (query.trim().isEmpty) return true;
  final normTarget = normalizeArabicText(target);
  final normQuery = normalizeArabicText(query);
  if (normTarget.contains(normQuery)) return true;
  final noSpaceTarget = normTarget.replaceAll(' ', '');
  final noSpaceQuery = normQuery.replaceAll(' ', '');
  return noSpaceTarget.contains(noSpaceQuery);
}

/// توحيد صيغة الرقم التسلسلي لشريحة NFC
String normalizeNfcUid(String rawUid) {
  return rawUid
      .trim()
      .toUpperCase()
      .replaceAll(':', '')
      .replaceAll('-', '')
      .replaceAll(' ', '');
}

// ============================================================================
// 1. الهوية البصرية والألوان الهادئة المتناسقة لجامعة المعقل
// ============================================================================
class AppColors {
  static const Color skyBlue = Color(0xFF00B4D8);
  static const Color lightSky = Color(0xFFE0F7FA);
  static const Color deepBlue = Color(0xFF1E3A8A);
  static const Color royalBlue = Color(0xFF2563EB);
  static const Color primaryPurple = Color(0xFF5B21B6);
  static const Color softPurple = Color(0xFF7C3AED);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color bgSurface = Color(0xFFF8FAFC);
  static const Color cardBorder = Color(0xFFE2E8F0);
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningAmber = Color(0xFFF59E0B);
  static const Color dangerRed = Color(0xFFEF4444);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);

  static const LinearGradient mainGradient = LinearGradient(
    colors: [Color(0xFF1E3A8A), Color(0xFF5B21B6), Color(0xFF0284C7)],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  static const LinearGradient studentGradient = LinearGradient(
    colors: [Color(0xFF0284C7), Color(0xFF1E3A8A), Color(0xFF6D28D9)],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF6D28D9)],
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
  );
}

class AlMaaqalUniversityApp extends StatelessWidget {
  const AlMaaqalUniversityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'جامعة المعقل',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.bgSurface,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryPurple,
          primary: AppColors.royalBlue,
          secondary: AppColors.skyBlue,
          tertiary: AppColors.primaryPurple,
          surface: AppColors.pureWhite,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.pureWhite,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.cardBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.cardBorder, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.skyBlue, width: 1.8),
          ),
        ),
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const AuthScreen(),
    );
  }
}

// ============================================================================
// 2. الشعار العلمي والترويسة الثابتة لجامعة المعقل (مع زر الثلاث خطوط ☰ أعلى اليمين)
// ============================================================================
class AlMaaqalScientificCrest extends StatelessWidget {
  final double size;
  final bool showGlow;

  const AlMaaqalScientificCrest({
    super.key,
    this.size = 64,
    this.showGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.skyBlue, AppColors.royalBlue, AppColors.primaryPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: showGlow
            ? [
          BoxShadow(
            color: AppColors.skyBlue.withOpacity(0.35),
            blurRadius: 14,
            spreadRadius: 1,
          ),
        ]
            : null,
        border: Border.all(color: AppColors.pureWhite, width: 2.2),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size * 0.80, size * 0.80),
            painter: _ScientificAtomPainter(),
          ),
          Icon(
            Icons.school_rounded,
            color: AppColors.pureWhite,
            size: size * 0.44,
          ),
        ],
      ),
    );
  }
}

class _ScientificAtomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.30)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    final center = Offset(size.width / 2, size.height / 2);
    canvas.save();
    canvas.translate(center.dx, center.dy);

    for (int i = 0; i < 3; i++) {
      canvas.save();
      canvas.rotate(i * pi / 3);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset.zero,
          width: size.width * 0.90,
          height: size.height * 0.36,
        ),
        paint,
      );
      canvas.restore();
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// ترويسة جامعة المعقل الهادئة في أعلى كل واجهة مع زر القائمة الجانبية (☰) الثابت أعلى اليمين
class UniversityHeaderBanner extends StatelessWidget {
  final String screenTitle;
  final String? subtitle;
  final VoidCallback? onMenuTap;
  final bool isStudentTheme;

  const UniversityHeaderBanner({
    super.key,
    required this.screenTitle,
    this.subtitle,
    this.onMenuTap,
    this.isStudentTheme = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        bottom: 16,
        right: 14,
        left: 14,
      ),
      decoration: BoxDecoration(
        gradient: isStudentTheme ? AppColors.studentGradient : AppColors.mainGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x261E3A8A),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // زر الثلاث خطوط الثابت في أعلى يمين الشاشة لفتح القائمة الجانبية
              if (onMenuTap != null) ...[
                InkWell(
                  onTap: onMenuTap,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.16),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Icon(
                      Icons.menu_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              const AlMaaqalScientificCrest(size: 44, showGlow: false),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'جامعة المعقل • هندسة الأمن السيبراني',
                      style: TextStyle(
                        color: AppColors.pureWhite,
                        fontSize: 16.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      screenTitle,
                      style: const TextStyle(
                        color: AppColors.lightSky,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.pureWhite,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================================
// 3. نماذج البيانات (المواد، جدول المحاضرات وأوقاتها، الحضور المستقل لكل محاضرة)
// ============================================================================
class CourseModel {
  int idx;
  String dept;
  String stage;   // 'المرحلة الثانية' | 'المرحلة الثالثة'
  String semNum;
  String semName; // 'الأول' | 'الثاني' (الكورس الأول / الكورس الثاني)
  String code;
  String nameAr;
  String nameEn;
  int ects;
  String cid;
  // بيانات موعد المحاضرة في الجدول الأسبوعي
  String dayName;
  String morningTime;
  String eveningTime;
  String roomName;
  String lectureType; // 'نظري' | 'عملي + نظري'

  CourseModel({
    required this.idx,
    required this.dept,
    required this.stage,
    required this.semNum,
    required this.semName,
    required this.code,
    required this.nameAr,
    required this.nameEn,
    required this.ects,
    required this.cid,
    this.dayName = 'الأحد',
    this.morningTime = '08:30 ص - 10:00 ص',
    this.eveningTime = '02:00 م - 03:30 م',
    this.roomName = 'قاعة الأمن السيبراني 1',
    this.lectureType = 'نظري + عملي',
  });

  String timeForShift(String shift) =>
      shift == 'صباحي' ? morningTime : eveningTime;
}

class StudentGradeRecord {
  double attendanceScore; // من 10
  double quizScore;       // من 15
  double midtermScore;    // من 25
  double finalExamScore;  // من 50

  StudentGradeRecord({
    this.attendanceScore = 8.0,
    this.quizScore = 12.0,
    this.midtermScore = 20.0,
    this.finalExamScore = 0.0,
  });

  double get annualCoursework =>
      (attendanceScore + quizScore + midtermScore).clamp(0.0, 50.0);

  double get totalScore =>
      (annualCoursework + finalExamScore).clamp(0.0, 100.0);

  String get evaluationLabel {
    final t = finalExamScore > 0 ? totalScore : (annualCoursework * 2);
    if (t >= 90) return 'امتياز';
    if (t >= 80) return 'جيد جداً';
    if (t >= 70) return 'جيد';
    if (t >= 60) return 'متوسط';
    if (t >= 50) return 'مقبول';
    return 'راسب';
  }
}

class AttendanceRecord {
  final String studentId;
  final String studentName;
  final String studentShift;
  final String studentStage;
  final String courseCode;
  final String courseName;
  final String lectureSessionLabel; // مثلاً: المحاضرة 1 (الأحد 08:30 ص - 10:00 ص)
  final String roomName;
  final String status;
  final String method;
  final DateTime timestamp;

  AttendanceRecord({
    required this.studentId,
    required this.studentName,
    required this.studentShift,
    required this.studentStage,
    required this.courseCode,
    required this.courseName,
    required this.lectureSessionLabel,
    required this.roomName,
    required this.status,
    required this.method,
    required this.timestamp,
  });
}

class StudentModel {
  int idx;
  String id;
  String name;
  String stage; // 'المرحلة الثانية' | 'المرحلة الثالثة'
  String shift; // 'صباحي' | 'مسائي'
  String dept;  // 'هندسة الأمن السيبراني'
  String username;
  String password;
  String nfcTagUid;
  Map<String, StudentGradeRecord> gradesByCourseCode;
  // سجل حضور مستقل لكل مادة ولكل محاضرة في الجدول:
  // المفتاح: 'courseCode|lectureNum' -> القيمة: 'حاضر' | 'غائب'
  Map<String, String> attendanceByCourseLecture;
  // سجل تفصيلي للمحاضرات التي سُجّل فيها الطالب لكل مادة على حدة
  Map<String, List<AttendanceRecord>> recordsByCourseCode;

  StudentModel({
    required this.idx,
    required this.id,
    required this.name,
    required this.stage,
    required this.shift,
    required this.dept,
    String? username,
    this.password = '123456',
    String? nfcTagUid,
    Map<String, StudentGradeRecord>? gradesByCourseCode,
    Map<String, String>? attendanceByCourseLecture,
    Map<String, List<AttendanceRecord>>? recordsByCourseCode,
  })  : username = username ?? id,
        nfcTagUid = nfcTagUid ?? '',
        gradesByCourseCode = gradesByCourseCode ?? {},
        attendanceByCourseLecture = attendanceByCourseLecture ?? {},
        recordsByCourseCode = recordsByCourseCode ?? {};

  /// جلب حالة حضور الطالب في مادة معينة ومحاضرة محددة (مستقلة تماماً عن بقية المواد)
  String getStatusForLecture(String courseCode, int lectureNum) {
    return attendanceByCourseLecture['$courseCode|$lectureNum'] ?? '';
  }

  /// عدد مرات حضور الطالب في مادة معينة
  int countPresentForCourse(String courseCode) {
    int c = 0;
    attendanceByCourseLecture.forEach((key, val) {
      if (key.startsWith('$courseCode|') && val == 'حاضر') c++;
    });
    return c;
  }

  /// عدد مرات غياب الطالب في مادة معينة
  int countAbsentForCourse(String courseCode) {
    int c = 0;
    attendanceByCourseLecture.forEach((key, val) {
      if (key.startsWith('$courseCode|') && val == 'غائب') c++;
    });
    return c;
  }
}

class ProfessorModel {
  String id;
  String username;
  String name;
  String title;
  String email;
  String password;
  String dept;
  String specialization;

  ProfessorModel({
    required this.id,
    required this.username,
    required this.name,
    required this.title,
    required this.email,
    required this.password,
    required this.dept,
    this.specialization = 'أمن الشبكات والتشفير السيبراني',
  });
}

class McqQuestion {
  String questionText;
  List<String> options;
  int correctOptionIndex;
  double points;

  McqQuestion({
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    this.points = 5.0,
  });
}

class ExamQuizModel {
  String id;
  String title;
  String examType;
  String dept;
  String stage;
  String courseCode;
  String courseName;
  String createdByProf;
  int durationMinutes;
  List<McqQuestion> questions;
  Map<String, double> studentScores;

  ExamQuizModel({
    required this.id,
    required this.title,
    required this.examType,
    required this.dept,
    required this.stage,
    required this.courseCode,
    required this.courseName,
    required this.createdByProf,
    this.durationMinutes = 15,
    required this.questions,
    Map<String, double>? studentScores,
  }) : studentScores = studentScores ?? {};

  double get maxScore =>
      questions.fold(0.0, (sum, item) => sum + item.points);
}

// ============================================================================
// 4. قاعدة بيانات قسم هندسة الأمن السيبراني (مع جدول المحاضرات وأوقاتها)
// ============================================================================
class UniversityDatabase extends ChangeNotifier {
  static final UniversityDatabase instance = UniversityDatabase._internal();
  UniversityDatabase._internal() {
    _initializeDatabase();
  }

  static const String singleDepartment = 'هندسة الأمن السيبراني';

  final List<String> stages = const [
    'المرحلة الثانية',
    'المرحلة الثالثة',
  ];

  final List<String> _allStagesLookup = const [
    'المرحلة الأولى',
    'المرحلة الثانية',
    'المرحلة الثالثة',
    'المرحلة الرابعة',
  ];

  final List<String> shifts = const [
    'صباحي',
    'مسائي',
  ];

  final List<String> semesters = const [
    'الأول',
    'الثاني',
  ];

  final List<String> weekDays = const [
    'الأحد',
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
  ];

  final List<String> morningSlots = const [
    '08:30 ص - 10:00 ص',
    '10:00 ص - 11:30 ص',
    '11:30 ص - 01:00 م',
  ];

  final List<String> eveningSlots = const [
    '02:00 م - 03:30 م',
    '03:30 م - 05:00 م',
    '05:00 م - 06:30 م',
  ];

  final List<String> roomsList = const [
    'قاعة الأمن السيبراني 1',
    'مختبر التشفير وأمن الشبكات',
    'قاعة الأمن السيبراني 2',
    'مختبر البرمجة الآمنة',
    'قاعة الخوارزميات والأنظمة',
  ];

  final List<CourseModel> courses = [];
  final List<StudentModel> students = [];
  final List<ProfessorModel> professors = [];
  final List<ExamQuizModel> exams = [];
  final List<AttendanceRecord> attendanceLogs = [];

  // بيانات البطاقة الجامعية الحقيقية للطالب حسن عبد الامير خضير سلمان
  static const String hassanStudentId = '5203751760';
  static const String hassanNfcSerial = '04:44:B4:6A:A1:18:90';
  static const String hassanNfcSerialReversed = '90:18:A1:6A:B4:44:04';
  static const String hassanNfcCardType = 'ISO 14443-4 (NXP - IBM JCOP | IsoDep, NfcA)';

  void _initializeDatabase() {
    // 1. تحميل مواد قسم هندسة الأمن السيبراني وتوزيعها على جدول المحاضرات الأسبوعي وأوقاتها
    int slotCounter = 0;
    for (final raw in _rawCyberCoursesData) {
      final p = raw.split('|');
      final stgName = _allStagesLookup[int.parse(p[2])];
      final semName = semesters[int.parse(p[4])];
      final day = weekDays[slotCounter % weekDays.length];
      final timeIdx = (slotCounter ~/ weekDays.length) % morningSlots.length;
      final mTime = morningSlots[timeIdx];
      final eTime = eveningSlots[timeIdx];
      final room = roomsList[slotCounter % roomsList.length];
      final ectsVal = int.parse(p[8]);
      final lType = ectsVal >= 5 ? 'نظري + عملي (مختبر)' : 'نظري';
      slotCounter++;

      courses.add(
        CourseModel(
          idx: int.parse(p[0]),
          dept: singleDepartment,
          stage: stgName,
          semNum: p[3],
          semName: semName,
          code: p[5],
          nameAr: p[6],
          nameEn: p[7],
          ects: ectsVal,
          cid: '${p[9]}|${p[10]}|${p[11]}',
          dayName: day,
          morningTime: mTime,
          eveningTime: eTime,
          roomName: room,
          lectureType: lType,
        ),
      );
    }

    // 2. تحميل جميع طلاب المرحلتين الثانية والثالثة (صباحي ومسائي)
    for (final raw in _rawStudentsData) {
      final p = raw.split('|');
      final idx = int.parse(p[0]);
      final sid = p[1];
      final sname = p[2];
      final sstage = _allStagesLookup[int.parse(p[3])];
      final sshift = shifts[int.parse(p[4])];
      final isHassan = (sid == hassanStudentId);
      students.add(
        StudentModel(
          idx: idx,
          id: sid,
          name: sname,
          stage: sstage,
          shift: sshift,
          dept: singleDepartment,
          username: isHassan ? 'hassan' : sid,
          password: '123456',
          nfcTagUid: isHassan ? hassanNfcSerial : '',
        ),
      );
    }

    // 3. حساب الأستاذ الدكتور أحمد دنقل
    professors.add(
      ProfessorModel(
        id: 'PROF-01',
        username: 'ahmed',
        name: 'د. أحمد دنقل',
        title: 'أستاذ تدريسي • قسم هندسة الأمن السيبراني',
        email: 'ahmed.dongol@almaaqal.edu.iq',
        password: '123456',
        dept: singleDepartment,
        specialization: 'أمن الأنظمة والشبكات والتشفير المتقدم',
      ),
    );

    // 4. اختبارات MCQ لقسم هندسة الأمن السيبراني
    exams.addAll([
      ExamQuizModel(
        id: 'EXAM-301',
        title: 'امتحان المد: أمن الشبكات (CYSE501)',
        examType: 'امتحان فصلي (Midterm)',
        dept: singleDepartment,
        stage: 'المرحلة الثالثة',
        courseCode: 'CYSE501',
        courseName: 'أمن الشبكات',
        createdByProf: 'د. أحمد دنقل',
        durationMinutes: 25,
        questions: [
          McqQuestion(
            questionText: 'أي بروتوكول يُستخدم لتأمين حركة البيانات عبر الويب باستخدام التشفير؟',
            options: ['HTTP', 'HTTPS (TLS/SSL)', 'FTP', 'Telnet'],
            correctOptionIndex: 1,
            points: 12.5,
          ),
          McqQuestion(
            questionText: 'ما هي الوظيفة الأساسية لجدار الحماية (Firewall) في أمن الشبكات؟',
            options: [
              'مراقبة وتصفية حركة مرور الشبكة الصادرة والواردة',
              'زيادة سرعة المعالج المركزي',
              'تصميم واجهات المستخدم الرسومية',
              'ضغط الملفات النصية'
            ],
            correctOptionIndex: 0,
            points: 12.5,
          ),
        ],
      ),
      ExamQuizModel(
        id: 'EXAM-201',
        title: 'كويز الكورس الأول: مقدمة في التشفير (CYSE301)',
        examType: 'كويز يومي (Quiz)',
        dept: singleDepartment,
        stage: 'المرحلة الثانية',
        courseCode: 'CYSE301',
        courseName: 'مقدمة في التشفير',
        createdByProf: 'د. أحمد دنقل',
        durationMinutes: 15,
        questions: [
          McqQuestion(
            questionText: 'أي من الخوارزميات التالية يُعد تشفيراً غير متناظر (Asymmetric Encryption)؟',
            options: ['DES', 'AES', 'RSA', 'Blowfish'],
            correctOptionIndex: 2,
            points: 7.5,
          ),
          McqQuestion(
            questionText: 'ما هو طول المفتاح الأعلى أماناً في خوارزمية التشفير القياسية AES؟',
            options: ['64-bit', '128-bit', '256-bit', '32-bit'],
            correctOptionIndex: 2,
            points: 7.5,
          ),
        ],
      ),
    ]);
  }

  StudentModel get studentHassan => students.firstWhere(
        (s) => s.id == hassanStudentId,
    orElse: () => students.first,
  );

  StudentGradeRecord getStudentGrade(StudentModel student, String courseCode) {
    if (!student.gradesByCourseCode.containsKey(courseCode)) {
      final seed = (student.id.hashCode ^ courseCode.hashCode).abs();
      student.gradesByCourseCode[courseCode] = StudentGradeRecord(
        attendanceScore: 8.0 + (seed % 3),
        quizScore: 11.0 + (seed % 5),
        midtermScore: 18.0 + (seed % 7),
        finalExamScore: 36.0 + (seed % 13),
      );
    }
    return student.gradesByCourseCode[courseCode]!;
  }

  /// تسجيل حضور أو غياب الطالب في مادة محددة ومحاضرة محددة حسب جدول المحاضرات وأوقاتها
  void recordLectureAttendance({
    required StudentModel student,
    required CourseModel course,
    required int lectureNumber,
    required String status,
    required String method,
  }) {
    final key = '${course.code}|$lectureNumber';
    final previousStatus = student.attendanceByCourseLecture[key];
    student.attendanceByCourseLecture[key] = status;

    final grade = getStudentGrade(student, course.code);
    if (status == 'حاضر' && previousStatus != 'حاضر') {
      grade.attendanceScore = (grade.attendanceScore + 0.5).clamp(0.0, 10.0);
    }

    final lectureTime = course.timeForShift(student.shift);
    final sessionLabel =
        'المحاضرة $lectureNumber • ${course.dayName} ($lectureTime)';

    final record = AttendanceRecord(
      studentId: student.id,
      studentName: student.name,
      studentShift: student.shift,
      studentStage: student.stage,
      courseCode: course.code,
      courseName: course.nameAr,
      lectureSessionLabel: sessionLabel,
      roomName: course.roomName,
      status: status,
      method: method,
      timestamp: DateTime.now(),
    );

    student.recordsByCourseCode.putIfAbsent(course.code, () => []);
    student.recordsByCourseCode[course.code]!.removeWhere(
          (r) => r.lectureSessionLabel == sessionLabel,
    );
    student.recordsByCourseCode[course.code]!.insert(0, record);

    attendanceLogs.insert(0, record);
    notifyListeners();
  }

  void updateCourseSchedule(
      CourseModel course, {
        required String dayName,
        required String morningTime,
        required String eveningTime,
        required String roomName,
        required String lectureType,
      }) {
    course.dayName = dayName;
    course.morningTime = morningTime;
    course.eveningTime = eveningTime;
    course.roomName = roomName;
    course.lectureType = lectureType;
    notifyListeners();
  }

  void updateStudentGrade({
    required StudentModel student,
    required String courseCode,
    required double attendance,
    required double quiz,
    required double midterm,
    required double finalExam,
  }) {
    student.gradesByCourseCode[courseCode] = StudentGradeRecord(
      attendanceScore: attendance.clamp(0.0, 10.0),
      quizScore: quiz.clamp(0.0, 15.0),
      midtermScore: midterm.clamp(0.0, 25.0),
      finalExamScore: finalExam.clamp(0.0, 50.0),
    );
    notifyListeners();
  }

  void submitExamAnswers({
    required ExamQuizModel exam,
    required StudentModel student,
    required double earnedScore,
  }) {
    exam.studentScores[student.id] = earnedScore;
    final grade = getStudentGrade(student, exam.courseCode);
    if (exam.examType.contains('كويز')) {
      grade.quizScore = earnedScore.clamp(0.0, 15.0);
    } else {
      grade.midtermScore = earnedScore.clamp(0.0, 25.0);
    }
    notifyListeners();
  }

  StudentModel addStudent({
    required String id,
    required String name,
    required String stage,
    required String shift,
    String password = '123456',
  }) {
    final s = StudentModel(
      idx: students.length + 1,
      id: id,
      name: name,
      stage: stage,
      shift: shift,
      dept: singleDepartment,
      password: password,
    );
    students.insert(0, s);
    notifyListeners();
    return s;
  }

  void updateStudent(
      StudentModel student, {
        required String name,
        required String id,
        required String stage,
        required String shift,
      }) {
    student.name = name;
    student.id = id;
    student.stage = stage;
    student.shift = shift;
    notifyListeners();
  }

  void deleteStudent(StudentModel student) {
    students.remove(student);
    notifyListeners();
  }

  CourseModel addCourse({
    required String stage,
    required String semName,
    required String code,
    required String nameAr,
    required String nameEn,
    required int ects,
    String dayName = 'الأحد',
    String morningTime = '08:30 ص - 10:00 ص',
    String eveningTime = '02:00 م - 03:30 م',
    String roomName = 'قاعة الأمن السيبراني 1',
  }) {
    final semNum = semName == 'الأول' ? '1' : '2';
    final c = CourseModel(
      idx: courses.length + 1,
      dept: singleDepartment,
      stage: stage,
      semNum: semNum,
      semName: semName,
      code: code,
      nameAr: nameAr,
      nameEn: nameEn,
      ects: ects,
      cid: 'cyber|$semNum|$code',
      dayName: dayName,
      morningTime: morningTime,
      eveningTime: eveningTime,
      roomName: roomName,
    );
    courses.insert(0, c);
    notifyListeners();
    return c;
  }

  void updateCourse(
      CourseModel course, {
        required String stage,
        required String semName,
        required String code,
        required String nameAr,
        required String nameEn,
        required int ects,
      }) {
    course.stage = stage;
    course.semName = semName;
    course.code = code;
    course.nameAr = nameAr;
    course.nameEn = nameEn;
    course.ects = ects;
    notifyListeners();
  }

  void deleteCourse(CourseModel course) {
    courses.remove(course);
    notifyListeners();
  }

  ProfessorModel addProfessor({
    required String name,
    required String username,
    required String title,
    required String email,
    required String password,
  }) {
    final p = ProfessorModel(
      id: 'PROF-${professors.length + 1}',
      username: username,
      name: name,
      title: title,
      email: email,
      password: password,
      dept: singleDepartment,
    );
    professors.add(p);
    notifyListeners();
    return p;
  }

  bool resetPassword(String identifier, String newPassword) {
    final clean = identifier.trim();
    for (final p in professors) {
      if (p.username.toLowerCase() == clean.toLowerCase() ||
          p.email.toLowerCase() == clean.toLowerCase() ||
          smartArabicMatch(p.name, clean)) {
        p.password = newPassword;
        notifyListeners();
        return true;
      }
    }
    for (final s in students) {
      if (s.id == clean ||
          s.username.toLowerCase() == clean.toLowerCase() ||
          smartArabicMatch(s.name, clean)) {
        s.password = newPassword;
        notifyListeners();
        return true;
      }
    }
    return false;
  }
}

// ============================================================================
// 5. رسام رمز QR Code المدمج
// ============================================================================
class CustomQrCodeWidget extends StatelessWidget {
  final String data;
  final double size;

  const CustomQrCodeWidget({
    super.key,
    required this.data,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.skyBlue, width: 2),
      ),
      child: CustomPaint(
        painter: _DeterministicQrPainter(data),
      ),
    );
  }
}

class _DeterministicQrPainter extends CustomPainter {
  final String data;
  _DeterministicQrPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    const int grid = 19;
    final double cell = size.width / grid;
    final paint = Paint()
      ..color = AppColors.textDark
      ..style = PaintingStyle.fill;

    void drawFinder(int r0, int c0) {
      for (int r = 0; r < 7; r++) {
        for (int c = 0; c < 7; c++) {
          final isOuter = r == 0 || r == 6 || c == 0 || c == 6;
          final isInner = r >= 2 && r <= 4 && c >= 2 && c <= 4;
          if (isOuter || isInner) {
            canvas.drawRect(
              Rect.fromLTWH((c0 + c) * cell, (r0 + r) * cell, cell, cell),
              paint,
            );
          }
        }
      }
    }

    drawFinder(0, 0);
    drawFinder(0, grid - 7);
    drawFinder(grid - 7, 0);

    int hash = data.hashCode;
    for (int r = 0; r < grid; r++) {
      for (int c = 0; c < grid; c++) {
        final inTopLeft = r < 8 && c < 8;
        final inTopRight = r < 8 && c >= grid - 8;
        final inBottomLeft = r >= grid - 8 && c < 8;
        if (inTopLeft || inTopRight || inBottomLeft) continue;

        hash = ((hash * 1103515245) + 12345) & 0x7fffffff;
        final charCode =
        data.isNotEmpty ? data.codeUnitAt((r * grid + c) % data.length) : 1;
        if (((hash ^ charCode ^ (r * 17 + c * 31)) % 2) == 0) {
          canvas.drawRect(
            Rect.fromLTWH(c * cell, r * cell, cell * 0.95, cell * 0.95),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DeterministicQrPainter oldDelegate) =>
      oldDelegate.data != data;
}

// ============================================================================
// 6. واجهة تسجيل الدخول الهادئة (بدون كشف الحسابات) + واجهة إنشاء حساب للأستاذ فقط
// ============================================================================
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isProfessorLogin = true;
  bool _obscurePass = true;

  final TextEditingController _loginUserController = TextEditingController();
  final TextEditingController _loginPassController = TextEditingController();

  final db = UniversityDatabase.instance;

  void _handleLogin() {
    final input = _loginUserController.text.trim();
    final pass = _loginPassController.text.trim();

    if (input.isEmpty || pass.isEmpty) {
      _showMsg('يرجى إدخال اسم المستخدم وكلمة المرور', isError: true);
      return;
    }

    if (_isProfessorLogin) {
      ProfessorModel? matchedProf;
      for (final p in db.professors) {
        if ((p.username.toLowerCase() == input.toLowerCase() ||
            p.email.toLowerCase() == input.toLowerCase() ||
            smartArabicMatch(p.name, input)) &&
            p.password == pass) {
          matchedProf = p;
          break;
        }
      }
      if (matchedProf != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ProfessorMainScreen(professor: matchedProf!),
          ),
        );
      } else {
        _showMsg('اسم المستخدم أو كلمة المرور لحساب الأستاذ غير صحيحة', isError: true);
      }
    } else {
      StudentModel? matchedStudent;
      for (final s in db.students) {
        if ((s.id == input ||
            s.username.toLowerCase() == input.toLowerCase() ||
            smartArabicMatch(s.name, input)) &&
            s.password == pass) {
          matchedStudent = s;
          break;
        }
      }
      if (matchedStudent != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => StudentMainScreen(student: matchedStudent!),
          ),
        );
      } else {
        _showMsg('اسم المستخدم / الرقم الجامعي أو كلمة المرور للطالب غير صحيحة', isError: true);
      }
    }
  }

  void _openProfessorRegisterScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ProfessorRegisterScreen()),
    );
  }

  void _showForgotPasswordDialog() {
    final idCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.lock_reset_rounded, color: AppColors.primaryPurple, size: 26),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'نسيت كلمة المرور',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'أدخل اسم المستخدم أو الرقم الجامعي لتعيين كلمة مرور جديدة:',
                style: TextStyle(fontSize: 13, color: AppColors.textMuted),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: idCtrl,
                decoration: const InputDecoration(
                  labelText: 'اسم المستخدم / الرقم الجامعي',
                  prefixIcon: Icon(Icons.person_outline, color: AppColors.royalBlue),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPassCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'كلمة المرور الجديدة',
                  prefixIcon: Icon(Icons.key_rounded, color: AppColors.primaryPurple),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.primaryPurple),
              onPressed: () {
                if (idCtrl.text.trim().isEmpty || newPassCtrl.text.trim().isEmpty) {
                  _showMsg('يرجى ملء جميع الحقول', isError: true);
                  return;
                }
                final ok = db.resetPassword(idCtrl.text, newPassCtrl.text.trim());
                Navigator.pop(ctx);
                if (ok) {
                  _showMsg('تم تحديث كلمة المرور بنجاح');
                } else {
                  _showMsg('لم يتم العثور على الحساب المدخل', isError: true);
                }
              },
              child: const Text('تحديث كلمة المرور'),
            ),
          ],
        ),
      ),
    );
  }

  void _showMsg(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: isError ? AppColors.dangerRed : AppColors.primaryPurple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const UniversityHeaderBanner(
            screenTitle: 'بوابة تسجيل الدخول الأكاديمية',
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AlMaaqalScientificCrest(size: 82),
                    const SizedBox(height: 12),
                    const Text(
                      'جامعة المعقل',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.deepBlue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'كلية الهندسة • قسم هندسة الأمن السيبراني',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: AppColors.primaryPurple,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                        side: const BorderSide(color: AppColors.cardBorder),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.bgSurface,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.cardBorder),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(() {
                                        _isProfessorLogin = true;
                                        _loginUserController.clear();
                                        _loginPassController.clear();
                                      }),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        decoration: BoxDecoration(
                                          gradient: _isProfessorLogin
                                              ? AppColors.buttonGradient
                                              : null,
                                          borderRadius: BorderRadius.circular(11),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.school_rounded,
                                              size: 18,
                                              color: _isProfessorLogin
                                                  ? Colors.white
                                                  : AppColors.textMuted,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              'دخول كأستاذ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: _isProfessorLogin
                                                    ? Colors.white
                                                    : AppColors.textMuted,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(() {
                                        _isProfessorLogin = false;
                                        _loginUserController.clear();
                                        _loginPassController.clear();
                                      }),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        decoration: BoxDecoration(
                                          gradient: !_isProfessorLogin
                                              ? const LinearGradient(
                                            colors: [
                                              AppColors.skyBlue,
                                              AppColors.royalBlue
                                            ],
                                          )
                                              : null,
                                          borderRadius: BorderRadius.circular(11),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.badge_rounded,
                                              size: 18,
                                              color: !_isProfessorLogin
                                                  ? Colors.white
                                                  : AppColors.textMuted,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              'دخول كطالب',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: !_isProfessorLogin
                                                    ? Colors.white
                                                    : AppColors.textMuted,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            TextField(
                              controller: _loginUserController,
                              decoration: InputDecoration(
                                labelText: _isProfessorLogin
                                    ? 'اسم المستخدم أو البريد الجامعي للأستاذ'
                                    : 'اسم المستخدم أو الرقم الجامعي للطالب',
                                prefixIcon: Icon(
                                  _isProfessorLogin
                                      ? Icons.person_outline_rounded
                                      : Icons.numbers_rounded,
                                  color: AppColors.royalBlue,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            TextField(
                              controller: _loginPassController,
                              obscureText: _obscurePass,
                              decoration: InputDecoration(
                                labelText: 'كلمة المرور',
                                prefixIcon: const Icon(
                                  Icons.lock_outline_rounded,
                                  color: AppColors.primaryPurple,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePass
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                  onPressed: () =>
                                      setState(() => _obscurePass = !_obscurePass),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: _showForgotPasswordDialog,
                                child: const Text(
                                  'نسيت كلمة المرور؟',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryPurple,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              decoration: BoxDecoration(
                                gradient: _isProfessorLogin
                                    ? AppColors.buttonGradient
                                    : const LinearGradient(
                                  colors: [AppColors.skyBlue, AppColors.royalBlue],
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                onPressed: _handleLogin,
                                icon: const Icon(Icons.login_rounded),
                                label: Text(
                                  _isProfessorLogin
                                      ? 'تسجيل الدخول كأستاذ'
                                      : 'تسجيل الدخول كطالب',
                                  style: const TextStyle(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            if (_isProfessorLogin) ...[
                              const SizedBox(height: 14),
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primaryPurple,
                                  side: const BorderSide(color: AppColors.primaryPurple),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: _openProfessorRegisterScreen,
                                icon: const Icon(Icons.person_add_alt_1_rounded),
                                label: const Text(
                                  'إنشاء حساب جديد (للأستاذ فقط)',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// واجهة مستقلة لإنشاء حساب جديد (مخصصة للأستاذ فقط)
class ProfessorRegisterScreen extends StatefulWidget {
  const ProfessorRegisterScreen({super.key});

  @override
  State<ProfessorRegisterScreen> createState() => _ProfessorRegisterScreenState();
}

class _ProfessorRegisterScreenState extends State<ProfessorRegisterScreen> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _userCtrl = TextEditingController();
  final TextEditingController _titleCtrl =
  TextEditingController(text: 'مدرس دكتور');
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();

  void _registerProf() {
    if (_nameCtrl.text.trim().isEmpty ||
        _userCtrl.text.trim().isEmpty ||
        _passCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى ملء الاسم واسم المستخدم وكلمة المرور'),
          backgroundColor: AppColors.dangerRed,
        ),
      );
      return;
    }

    final newProf = UniversityDatabase.instance.addProfessor(
      name: _nameCtrl.text.trim(),
      username: _userCtrl.text.trim(),
      title: _titleCtrl.text.trim(),
      email: _emailCtrl.text.trim().isEmpty
          ? '${_userCtrl.text.trim()}@almaaqal.edu.iq'
          : _emailCtrl.text.trim(),
      password: _passCtrl.text.trim(),
    );

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => ProfessorMainScreen(professor: newProf)),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const UniversityHeaderBanner(
            screenTitle: 'إنشاء حساب تدريسي جديد (للأستاذ فقط)',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: AppColors.cardBorder),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(child: AlMaaqalScientificCrest(size: 64)),
                      const SizedBox(height: 10),
                      const Text(
                        'تسجيل أستاذ جديد • قسم هندسة الأمن السيبراني',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: AppColors.deepBlue,
                        ),
                      ),
                      const SizedBox(height: 18),
                      TextField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'اسم الأستاذ الكامل مع اللقب (مثال: د. ...)',
                          prefixIcon: Icon(Icons.person_outline, color: AppColors.royalBlue),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _userCtrl,
                        decoration: const InputDecoration(
                          labelText: 'اسم المستخدم للدخول (Username)',
                          prefixIcon: Icon(Icons.alternate_email_rounded,
                              color: AppColors.primaryPurple),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _titleCtrl,
                        decoration: const InputDecoration(
                          labelText: 'الدرجة العلمية',
                          prefixIcon: Icon(Icons.workspace_premium_outlined,
                              color: AppColors.skyBlue),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _emailCtrl,
                        decoration: const InputDecoration(
                          labelText: 'البريد الجامعي (اختياري)',
                          prefixIcon: Icon(Icons.email_outlined, color: AppColors.royalBlue),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _passCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'كلمة المرور',
                          prefixIcon: Icon(Icons.lock_outline, color: AppColors.primaryPurple),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.buttonGradient,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: _registerProf,
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text(
                            'إنشاء حساب الأستاذ والدخول',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('العودة إلى شاشة تسجيل الدخول'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 7. واجهة حساب الأستاذ (حضور مستقل لكل مادة ومحاضرة + قائمة جدول المحاضرات وأوقاتها)
// ============================================================================
class ProfessorMainScreen extends StatefulWidget {
  final ProfessorModel professor;
  const ProfessorMainScreen({super.key, required this.professor});

  @override
  State<ProfessorMainScreen> createState() => _ProfessorMainScreenState();
}

class _ProfessorMainScreenState extends State<ProfessorMainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final db = UniversityDatabase.instance;

  // الفهرس الحالي للواجهة المعروضة:
  // 0 = تسجيل الحضور (مستقل لكل مادة ومحاضرة حسب الجدول)
  // 1 = جدول المحاضرات وأوقاتها
  // 2 = المواد الدراسية (حسب المرحلة والكورس)
  // 3 = الامتحانات الإلكترونية (MCQ)
  // 4 = قوائم الطلاب (الصباحي والمسائي)
  // 5 = السعي السنوي والدرجات
  // 6 = الملف الشخصي للأستاذ
  int _activePageIndex = 0;

  String _selectedStage = 'المرحلة الثالثة';
  String _selectedShift = 'صباحي';
  String _selectedSemester = 'الأول';
  String _selectedDayFilter = 'كل الأيام';
  int _selectedLectureNumber = 1; // رقم المحاضرة (المحاضرة 1 .. المحاضرة 15)
  CourseModel? _selectedCourse;

  int _attendanceMode = 0; // 0 = NFC، 1 = QR، 2 = الاسم/الرقم
  final TextEditingController _searchStudentCtrl = TextEditingController();

  static const MethodChannel _nfcChannel = MethodChannel('al_maaqal.edu.iq/nfc');

  @override
  void initState() {
    super.initState();
    _syncSelectedCourse();
    _setupHardwareListeners();
  }

  void _setupHardwareListeners() {
    _nfcChannel.setMethodCallHandler((call) async {
      if (call.method == 'onNfcTagDiscovered') {
        final String tagData = call.arguments?.toString() ?? '';
        _processPhysicalNfcCardTap(tagData);
      } else if (call.method == 'onQrCodeScanned') {
        final String qrData = call.arguments?.toString() ?? '';
        _processScannedQrCode(qrData);
      }
    });
  }

  void _syncSelectedCourse() {
    final matching = db.courses
        .where((c) => c.stage == _selectedStage && c.semName == _selectedSemester)
        .toList();
    if (matching.isNotEmpty) {
      if (_selectedCourse == null || !matching.contains(_selectedCourse)) {
        _selectedCourse = matching.first;
      }
    } else if (db.courses.isNotEmpty) {
      _selectedCourse = db.courses.first;
    }
  }

  List<CourseModel> get _stageCourses {
    final list = db.courses
        .where((c) => c.stage == _selectedStage && c.semName == _selectedSemester)
        .toList();
    return list.isNotEmpty
        ? list
        : db.courses.where((c) => c.stage == _selectedStage).toList();
  }

  List<StudentModel> get _filteredStudents {
    final q = _searchStudentCtrl.text.trim();
    return db.students.where((s) {
      if (s.stage != _selectedStage || s.shift != _selectedShift) return false;
      if (q.isEmpty) return true;
      return s.id.contains(q) || smartArabicMatch(s.name, q);
    }).toList();
  }

  int _countStudents(String stage, String shift) {
    return db.students
        .where((s) => s.stage == stage && s.shift == shift)
        .length;
  }

  /// معالجة قراءة البطاقة الجامعية الفيزيائية عبر NFC وتسجيل الحضور في المادة والمحاضرة الحالية تحديداً
  void _processPhysicalNfcCardTap(String rawSerial) {
    final clean = rawSerial.trim();
    final scannedNorm = normalizeNfcUid(clean);
    final hassanNorm = normalizeNfcUid(UniversityDatabase.hassanNfcSerial);
    final hassanRevNorm =
    normalizeNfcUid(UniversityDatabase.hassanNfcSerialReversed);

    StudentModel? target;
    if (scannedNorm.isNotEmpty) {
      if (scannedNorm == hassanNorm || scannedNorm == hassanRevNorm) {
        target = db.studentHassan;
      } else {
        for (final s in db.students) {
          if (s.nfcTagUid.trim().isNotEmpty &&
              normalizeNfcUid(s.nfcTagUid) == scannedNorm) {
            target = s;
            break;
          }
        }
      }
    }

    if (target == null) {
      HapticFeedback.vibrate();
      _showNfcRejectedDialog(clean.isEmpty ? 'غير معروف' : clean);
      return;
    }

    HapticFeedback.heavyImpact();
    setState(() {
      if (_selectedStage != target!.stage) {
        _selectedStage = target.stage;
        _syncSelectedCourse();
      }
      _selectedShift = target.shift;
    });

    final course = _selectedCourse ?? db.courses.first;
    db.recordLectureAttendance(
      student: target,
      course: course,
      lectureNumber: _selectedLectureNumber,
      status: 'حاضر',
      method: 'بطاقة NFC الجامعية (${target.nfcTagUid})',
    );

    _showAttendanceSuccessSheet(
      target,
      course,
      'قراءة NFC ناجحة (${target.nfcTagUid})',
    );
  }

  Future<void> _openPhoneCameraForQr() async {
    try {
      await _nfcChannel.invokeMethod('openQrCamera');
    } catch (_) {
      if (!mounted) return;
      _showInteractiveCameraSheet();
    }
  }

  void _processScannedQrCode(String qrCode) {
    final clean = qrCode.trim();
    if (clean.isEmpty) return;
    StudentModel? matched;
    for (final s in db.students) {
      if (s.id == clean || smartArabicMatch(s.name, clean)) {
        matched = s;
        break;
      }
    }
    if (matched != null) {
      HapticFeedback.mediumImpact();
      final course = _selectedCourse ?? db.courses.first;
      db.recordLectureAttendance(
        student: matched,
        course: course,
        lectureNumber: _selectedLectureNumber,
        status: 'حاضر',
        method: 'مسح كاميرا QR Code',
      );
      _showAttendanceSuccessSheet(matched, course, 'مسح كاميرا QR Code');
    } else {
      _showNfcRejectedDialog(clean);
    }
  }

  void _showInteractiveCameraSheet() {
    final qrCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: EdgeInsets.only(
            top: 20,
            right: 20,
            left: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.camera_alt_rounded,
                  color: AppColors.primaryPurple, size: 42),
              const SizedBox(height: 8),
              const Text(
                'مسح رمز QR لهوية الطالب',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: AppColors.deepBlue),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: qrCtrl,
                decoration: const InputDecoration(
                  labelText: 'الرقم الجامعي الممسوح من رمز QR',
                  prefixIcon: Icon(Icons.qr_code_rounded),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.royalBlue,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _processScannedQrCode(qrCtrl.text);
                  },
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('تأكيد مسح الرمز وتسجيل الحضور'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNfcRejectedDialog(String scannedSerial) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: AppColors.dangerRed, width: 2),
          ),
          title: const Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFFFEE2E2),
                child: Icon(Icons.credit_card_off_rounded,
                    color: AppColors.dangerRed, size: 24),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'تنبيه رفض: لم يتعرف على البطاقة',
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w900,
                    color: AppColors.dangerRed,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'هذه البطاقة غير مسجلة في قاعدة بيانات قسم هندسة الأمن السيبراني وتم رفض تسجيل الحضور.',
                style: TextStyle(fontSize: 13, color: AppColors.textDark),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'معرف البطاقة المرفوضة: $scannedSerial',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: AppColors.dangerRed,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: AppColors.dangerRed),
                onPressed: () => Navigator.pop(ctx),
                child: const Text('إغلاق'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttendanceSuccessSheet(
      StudentModel student, CourseModel course, String method) {
    final lectureTime = course.timeForShift(student.shift);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 32,
                backgroundColor: Color(0xFFE0F2FE),
                child: Icon(Icons.verified_rounded,
                    color: AppColors.successGreen, size: 40),
              ),
              const SizedBox(height: 10),
              const Text(
                'تم تسجيل حضور الطالب في المحاضرة بنجاح',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: AppColors.deepBlue,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                method,
                style: const TextStyle(
                  color: AppColors.primaryPurple,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const Divider(height: 22),
              _InfoRow(label: 'اسم الطالب:', value: student.name),
              _InfoRow(label: 'الرقم الجامعي:', value: student.id),
              _InfoRow(
                  label: 'المادة الدراسية:',
                  value: '${course.nameAr} (${course.code})'),
              _InfoRow(
                  label: 'المحاضرة والموعد:',
                  value: 'المحاضرة $_selectedLectureNumber • ${course.dayName} ($lectureTime)'),
              _InfoRow(label: 'القاعة / المختبر:', value: course.roomName),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: AppColors.royalBlue),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('تم'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// القائمة الجانبية يمين الشاشة (تفتح بالسحب من اليمين لليسار أو بالضغط على ☰ أعلى اليمين)
  Widget _buildRightSideDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              bottom: 20,
              right: 18,
              left: 18,
            ),
            decoration: const BoxDecoration(
              gradient: AppColors.mainGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AlMaaqalScientificCrest(size: 58, showGlow: false),
                const SizedBox(height: 12),
                Text(
                  widget.professor.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.professor.title,
                  style: const TextStyle(
                    color: AppColors.lightSky,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _DrawerMenuTile(
                  icon: Icons.person_pin_rounded,
                  title: 'الملف الشخصي للأستاذ',
                  selected: _activePageIndex == 6,
                  onTap: () => _selectPageFromDrawer(6),
                ),
                const Divider(height: 12),
                _DrawerMenuTile(
                  icon: Icons.nfc_rounded,
                  title: 'تسجيل حضور المحاضرات',
                  selected: _activePageIndex == 0,
                  onTap: () => _selectPageFromDrawer(0),
                ),
                _DrawerMenuTile(
                  icon: Icons.calendar_month_rounded,
                  title: 'جدول المحاضرات وأوقاتها',
                  selected: _activePageIndex == 1,
                  onTap: () => _selectPageFromDrawer(1),
                ),
                _DrawerMenuTile(
                  icon: Icons.menu_book_rounded,
                  title: 'المواد الدراسية (حسب الكورس)',
                  selected: _activePageIndex == 2,
                  onTap: () => _selectPageFromDrawer(2),
                ),
                _DrawerMenuTile(
                  icon: Icons.groups_rounded,
                  title: 'قوائم الطلاب (الصباحي والمسائي)',
                  selected: _activePageIndex == 4,
                  onTap: () => _selectPageFromDrawer(4),
                ),
                _DrawerMenuTile(
                  icon: Icons.workspace_premium_rounded,
                  title: 'السعي السنوي والدرجات',
                  selected: _activePageIndex == 5,
                  onTap: () => _selectPageFromDrawer(5),
                ),
                _DrawerMenuTile(
                  icon: Icons.quiz_rounded,
                  title: 'إدارة الامتحانات (MCQ)',
                  selected: _activePageIndex == 3,
                  onTap: () => _selectPageFromDrawer(3),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: AppColors.dangerRed),
            title: const Text(
              'تسجيل الخروج',
              style: TextStyle(
                color: AppColors.dangerRed,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const AuthScreen()),
              );
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  void _selectPageFromDrawer(int index) {
    Navigator.pop(context);
    setState(() => _activePageIndex = index);
  }

  /// شريط اختيار المرحلة والدراسة والمادة ورقم المحاضرة
  Widget _buildCalmStageShiftSelector({
    bool showCourseDropdown = false,
    bool showLectureSessionPicker = false,
  }) {
    final morningCount = _countStudents(_selectedStage, 'صباحي');
    final eveningCount = _countStudents(_selectedStage, 'مسائي');
    final coursesList = _stageCourses;
    if (_selectedCourse == null || !coursesList.contains(_selectedCourse)) {
      _selectedCourse = coursesList.first;
    }
    final activeCourse = _selectedCourse!;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.cardBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // اختيار المرحلة (المرحلة الثانية / المرحلة الثالثة)
            Row(
              children: db.stages.map((stg) {
                final isSel = _selectedStage == stg;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      onTap: () => setState(() {
                        _selectedStage = stg;
                        _syncSelectedCourse();
                      }),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSel ? AppColors.royalBlue : AppColors.bgSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSel ? AppColors.royalBlue : AppColors.cardBorder,
                          ),
                        ),
                        child: Text(
                          stg,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: isSel ? Colors.white : AppColors.textDark,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            // فصل الصباحي عن المسائي
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _selectedShift = 'صباحي'),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _selectedShift == 'صباحي'
                            ? AppColors.skyBlue
                            : AppColors.bgSurface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.wb_sunny_rounded,
                            size: 18,
                            color: _selectedShift == 'صباحي'
                                ? Colors.white
                                : AppColors.warningAmber,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'الصباحي ($morningCount)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.5,
                              color: _selectedShift == 'صباحي'
                                  ? Colors.white
                                  : AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _selectedShift = 'مسائي'),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _selectedShift == 'مسائي'
                            ? AppColors.primaryPurple
                            : AppColors.bgSurface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.nights_stay_rounded,
                            size: 18,
                            color: _selectedShift == 'مسائي'
                                ? Colors.white
                                : AppColors.primaryPurple,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'المسائي ($eveningCount)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.5,
                              color: _selectedShift == 'مسائي'
                                  ? Colors.white
                                  : AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (showCourseDropdown) ...[
              const SizedBox(height: 10),
              // اختيار الكورس الدراسي لتصفية المواد
              Row(
                children: db.semesters.map((sem) {
                  final isSel = _selectedSemester == sem;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: SizedBox(
                          width: double.infinity,
                          child: Text(
                            'الكورس $sem',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        selected: isSel,
                        selectedColor: AppColors.primaryPurple.withOpacity(0.16),
                        onSelected: (_) => setState(() {
                          _selectedSemester = sem;
                          _syncSelectedCourse();
                        }),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<CourseModel>(
                value: _selectedCourse,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'اختر المادة الدراسية (لكل مادة سجل حضور مستقل)',
                  prefixIcon: Icon(Icons.menu_book_rounded, color: AppColors.skyBlue),
                ),
                items: coursesList
                    .map(
                      (c) => DropdownMenuItem(
                    value: c,
                    child: Text(
                      '${c.nameAr} (${c.code}) • ${c.dayName}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _selectedCourse = v);
                },
              ),
            ],
            if (showLectureSessionPicker) ...[
              const SizedBox(height: 10),
              // شريط معلومات المحاضرة حسب الجدول + اختيار رقم المحاضرة الأسبوعية
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.lightSky.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.skyBlue.withOpacity(0.35)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.schedule_rounded,
                            color: AppColors.deepBlue, size: 18),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'موعد الجدول: ${activeCourse.dayName} • ${activeCourse.timeForShift(_selectedShift)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 12.5,
                              color: AppColors.deepBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'المكان: ${activeCourse.roomName} • النوع: ${activeCourse.lectureType}',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.primaryPurple,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(10, (idx) {
                          final lecNum = idx + 1;
                          final isSel = _selectedLectureNumber == lecNum;
                          return Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: ChoiceChip(
                              label: Text('محاضرة $lecNum'),
                              selected: isSel,
                              selectedColor: AppColors.royalBlue,
                              labelStyle: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: isSel ? Colors.white : AppColors.textDark,
                              ),
                              onSelected: (_) => setState(
                                      () => _selectedLectureNumber = lecNum),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: db,
      builder: (context, _) {
        final pageTitles = [
          'تسجيل الحضور المستقل لكل مادة ومحاضرة',
          'جدول المحاضرات الأسبوعي وأوقاتها',
          'المواد الدراسية • قسم هندسة الأمن السيبراني',
          'إدارة الامتحانات الإلكترونية (MCQ)',
          'قوائم طلاب الأمن السيبراني (صباحي ومسائي)',
          'سجل السعي السنوي والدرجات',
          'الملف الشخصي للأستاذ',
        ];

        final bottomNavIndex = _activePageIndex < 4 ? _activePageIndex : 0;

        return Scaffold(
          key: _scaffoldKey,
          drawer: _buildRightSideDrawer(),
          drawerEdgeDragWidth: 60,
          body: Column(
            children: [
              UniversityHeaderBanner(
                screenTitle: pageTitles[_activePageIndex],
                subtitle: '${widget.professor.name} • قسم هندسة الأمن السيبراني',
                onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
              ),
              Expanded(
                child: IndexedStack(
                  index: _activePageIndex,
                  children: [
                    _buildAttendancePage(),
                    _buildLectureSchedulePage(),
                    _buildCyberCoursesPage(),
                    _buildExamsPage(),
                    _buildStudentsListsPage(),
                    _buildGradesPage(),
                    _buildProfessorProfilePage(),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: bottomNavIndex,
            onDestinationSelected: (i) => setState(() => _activePageIndex = i),
            backgroundColor: Colors.white,
            indicatorColor: AppColors.skyBlue.withOpacity(0.22),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.nfc_rounded),
                selectedIcon: Icon(Icons.nfc_rounded, color: AppColors.royalBlue),
                label: 'تسجيل الحضور',
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_month_outlined),
                selectedIcon: Icon(Icons.calendar_month_rounded,
                    color: AppColors.primaryPurple),
                label: 'جدول المحاضرات',
              ),
              NavigationDestination(
                icon: Icon(Icons.menu_book_outlined),
                selectedIcon: Icon(Icons.menu_book_rounded,
                    color: AppColors.royalBlue),
                label: 'المواد',
              ),
              NavigationDestination(
                icon: Icon(Icons.quiz_outlined),
                selectedIcon:
                Icon(Icons.quiz_rounded, color: AppColors.primaryPurple),
                label: 'الامتحانات',
              ),
            ],
          ),
        );
      },
    );
  }

  // --------------------------------------------------------------------------
  // صفحة 0: تسجيل الحضور المستقل لكل مادة ومحاضرة
  // --------------------------------------------------------------------------
  Widget _buildAttendancePage() {
    final studentsList = _filteredStudents;
    final activeCourse = _selectedCourse ?? db.courses.first;

    int presentCount = 0;
    int absentCount = 0;
    for (final s in studentsList) {
      final st =
      s.getStatusForLecture(activeCourse.code, _selectedLectureNumber);
      if (st == 'حاضر') presentCount++;
      if (st == 'غائب') absentCount++;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCalmStageShiftSelector(
            showCourseDropdown: true,
            showLectureSessionPicker: true,
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              _MethodTabButton(
                title: 'بطاقة NFC',
                icon: Icons.contactless_rounded,
                selected: _attendanceMode == 0,
                onTap: () => setState(() => _attendanceMode = 0),
              ),
              const SizedBox(width: 8),
              _MethodTabButton(
                title: 'كاميرا QR',
                icon: Icons.qr_code_scanner_rounded,
                selected: _attendanceMode == 1,
                onTap: () => setState(() => _attendanceMode = 1),
              ),
              const SizedBox(width: 8),
              _MethodTabButton(
                title: 'الاسم / الرقم',
                icon: Icons.person_search_rounded,
                selected: _attendanceMode == 2,
                onTap: () => setState(() => _attendanceMode = 2),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (_attendanceMode == 0)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
              decoration: BoxDecoration(
                gradient: AppColors.mainGradient,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  Container(
                    width: 104,
                    height: 104,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.14),
                      border: Border.all(color: AppColors.skyBlue, width: 2.5),
                    ),
                    child: const Icon(
                      Icons.contactless_rounded,
                      color: Colors.white,
                      size: 52,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'تسجيل حضور مادة: ${activeCourse.nameAr}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'المحاضرة $_selectedLectureNumber • ${activeCourse.dayName} (${activeCourse.timeForShift(_selectedShift)})',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.lightSky,
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'قرّب البطاقة الجامعية من ظهر الهاتف لتسجيل الحضور في هذه المحاضرة فقط',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),

          if (_attendanceMode == 1)
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: AppColors.cardBorder),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 34,
                      backgroundColor: AppColors.lightSky,
                      child: Icon(
                        Icons.qr_code_scanner_rounded,
                        color: AppColors.deepBlue,
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'مسح رمز QR لمحاضرة: ${activeCourse.nameAr}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15.5,
                        color: AppColors.deepBlue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.royalBlue,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                        ),
                        onPressed: _openPhoneCameraForQr,
                        icon: const Icon(Icons.camera_alt_rounded),
                        label: const Text(
                          'فتح الكاميرا لمسح رمز QR',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          if (_attendanceMode == 2)
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: const BorderSide(color: AppColors.cardBorder),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: TextField(
                  controller: _searchStudentCtrl,
                  decoration: InputDecoration(
                    hintText: 'ابحث باسم الطالب أو رقمه الجامعي لتسجيل حضوره...',
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: AppColors.royalBlue),
                    suffixIcon: _searchStudentCtrl.text.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () =>
                          setState(() => _searchStudentCtrl.clear()),
                    )
                        : null,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ),

          const SizedBox(height: 12),

          Row(
            children: [
              _StatBadge(
                  label: 'العدد الكلي',
                  count: studentsList.length,
                  color: AppColors.royalBlue),
              const SizedBox(width: 8),
              _StatBadge(
                  label: 'حاضر بالمحاضرة',
                  count: presentCount,
                  color: AppColors.successGreen),
              const SizedBox(width: 8),
              _StatBadge(
                  label: 'غائب بالمحاضرة',
                  count: absentCount,
                  color: AppColors.dangerRed),
            ],
          ),
          const SizedBox(height: 12),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(color: AppColors.cardBorder),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'كشف حضور مادة (${activeCourse.nameAr}) • المحاضرة $_selectedLectureNumber',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 13.5,
                      color: AppColors.deepBlue,
                    ),
                  ),
                  const Divider(height: 18),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: min(studentsList.length, 60),
                    separatorBuilder: (_, __) => const Divider(height: 8),
                    itemBuilder: (ctx, i) {
                      final st = studentsList[i];
                      final currentStatus = st.getStatusForLecture(
                          activeCourse.code, _selectedLectureNumber);
                      return Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: AppColors.bgSurface,
                            child: Text(
                              '${i + 1}',
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: AppColors.deepBlue,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  st.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  'الرقم: ${st.id} • إجمالي حضوره بالمادة: ${st.countPresentForCourse(activeCourse.code)}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _AttendanceActionChip(
                            label: 'حاضر',
                            active: currentStatus == 'حاضر',
                            color: AppColors.successGreen,
                            onTap: () => db.recordLectureAttendance(
                              student: st,
                              course: activeCourse,
                              lectureNumber: _selectedLectureNumber,
                              status: 'حاضر',
                              method: 'تحضير الأستاذ',
                            ),
                          ),
                          const SizedBox(width: 6),
                          _AttendanceActionChip(
                            label: 'غائب',
                            active: currentStatus == 'غائب',
                            color: AppColors.dangerRed,
                            onTap: () => db.recordLectureAttendance(
                              student: st,
                              course: activeCourse,
                              lectureNumber: _selectedLectureNumber,
                              status: 'غائب',
                              method: 'تحضير الأستاذ',
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // صفحة 1: قائمة جدول المحاضرات الأسبوعي وأوقاتها (للأستاذ)
  // --------------------------------------------------------------------------
  Widget _buildLectureSchedulePage() {
    final allStageCourses = db.courses
        .where((c) => c.stage == _selectedStage && c.semName == _selectedSemester)
        .toList();
    final filteredSchedule = _selectedDayFilter == 'كل الأيام'
        ? allStageCourses
        : allStageCourses.where((c) => c.dayName == _selectedDayFilter).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(color: AppColors.cardBorder),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'جدول المحاضرات الأسبوعي وأوقاتها • هندسة الأمن السيبراني',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      color: AppColors.deepBlue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // اختيار المرحلة: الثانية / الثالثة
                  Row(
                    children: db.stages.map((stg) {
                      final isSel = _selectedStage == stg;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: SizedBox(
                              width: double.infinity,
                              child: Text(stg, textAlign: TextAlign.center),
                            ),
                            selected: isSel,
                            selectedColor: AppColors.royalBlue.withOpacity(0.18),
                            onSelected: (_) => setState(() {
                              _selectedStage = stg;
                              _syncSelectedCourse();
                            }),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  // اختيار نوع الدراسة (لتبديل أوقات المحاضرات بين الصباحي والمسائي) + الكورس
                  Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const SizedBox(
                            width: double.infinity,
                            child: Text('توقيت الصباحي', textAlign: TextAlign.center),
                          ),
                          selected: _selectedShift == 'صباحي',
                          selectedColor: AppColors.skyBlue.withOpacity(0.22),
                          onSelected: (_) =>
                              setState(() => _selectedShift = 'صباحي'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ChoiceChip(
                          label: const SizedBox(
                            width: double.infinity,
                            child: Text('توقيت المسائي', textAlign: TextAlign.center),
                          ),
                          selected: _selectedShift == 'مسائي',
                          selectedColor:
                          AppColors.primaryPurple.withOpacity(0.18),
                          onSelected: (_) =>
                              setState(() => _selectedShift = 'مسائي'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: db.semesters.map((sem) {
                      final isSel = _selectedSemester == sem;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: SizedBox(
                              width: double.infinity,
                              child: Text('الكورس $sem',
                                  textAlign: TextAlign.center),
                            ),
                            selected: isSel,
                            selectedColor:
                            AppColors.primaryPurple.withOpacity(0.16),
                            onSelected: (_) => setState(() {
                              _selectedSemester = sem;
                              _syncSelectedCourse();
                            }),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  // شريط أيام الأسبوع
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['كل الأيام', ...db.weekDays].map((d) {
                        final isSel = _selectedDayFilter == d;
                        return Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: ChoiceChip(
                            label: Text(d),
                            selected: isSel,
                            selectedColor: AppColors.royalBlue,
                            labelStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isSel ? Colors.white : AppColors.textDark,
                            ),
                            onSelected: (_) =>
                                setState(() => _selectedDayFilter = d),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...filteredSchedule.map(
                (c) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: const BorderSide(color: AppColors.cardBorder),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.royalBlue.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            c.dayName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              color: AppColors.royalBlue,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryPurple.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time_filled_rounded,
                                  size: 14, color: AppColors.primaryPurple),
                              const SizedBox(width: 4),
                              Text(
                                c.timeForShift(_selectedShift),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryPurple,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          tooltip: 'تعديل وقت أو قاعة المحاضرة',
                          icon: const Icon(Icons.edit_calendar_rounded,
                              color: AppColors.royalBlue, size: 20),
                          onPressed: () => _showEditScheduleSlotDialog(c),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${c.nameAr} (${c.code})',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15.5,
                        color: AppColors.deepBlue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'المكان: ${c.roomName} • النوع: ${c.lectureType} • الوحدات: ${c.ects} ECTS',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.royalBlue,
                          side: const BorderSide(color: AppColors.royalBlue),
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedCourse = c;
                            _activePageIndex = 0;
                          });
                        },
                        icon: const Icon(Icons.nfc_rounded, size: 18),
                        label: const Text(
                          'فتح تسجيل الحضور لهذه المحاضرة',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditScheduleSlotDialog(CourseModel course) {
    String day = course.dayName;
    final mTimeCtrl = TextEditingController(text: course.morningTime);
    final eTimeCtrl = TextEditingController(text: course.eveningTime);
    final roomCtrl = TextEditingController(text: course.roomName);
    final typeCtrl = TextEditingController(text: course.lectureType);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(
              'تعديل موعد محاضرة:\n${course.nameAr}',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: day,
                    decoration: const InputDecoration(labelText: 'يوم المحاضرة'),
                    items: db.weekDays
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setDialogState(() => day = v);
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: mTimeCtrl,
                    decoration: const InputDecoration(
                        labelText: 'وقت المحاضرة (الدراسة الصباحية)'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: eTimeCtrl,
                    decoration: const InputDecoration(
                        labelText: 'وقت المحاضرة (الدراسة المسائية)'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: roomCtrl,
                    decoration:
                    const InputDecoration(labelText: 'القاعة / المختبر'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: typeCtrl,
                    decoration: const InputDecoration(
                        labelText: 'نوع المحاضرة (نظري / عملي)'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
              FilledButton(
                onPressed: () {
                  db.updateCourseSchedule(
                    course,
                    dayName: day,
                    morningTime: mTimeCtrl.text.trim(),
                    eveningTime: eTimeCtrl.text.trim(),
                    roomName: roomCtrl.text.trim(),
                    lectureType: typeCtrl.text.trim(),
                  );
                  Navigator.pop(ctx);
                },
                child: const Text('حفظ الموعد'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // صفحة 2: المواد الدراسية لقسم هندسة الأمن السيبراني (مرتبة حسب المرحلة والكورس)
  // --------------------------------------------------------------------------
  Widget _buildCyberCoursesPage() {
    final list = db.courses
        .where((c) => c.stage == _selectedStage && c.semName == _selectedSemester)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(color: AppColors.cardBorder),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'مقررات قسم هندسة الأمن السيبراني (حسب المرحلة والكورس):',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      color: AppColors.deepBlue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: db.stages.map((stg) {
                      final isSel = _selectedStage == stg;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: SizedBox(
                              width: double.infinity,
                              child: Text(stg, textAlign: TextAlign.center),
                            ),
                            selected: isSel,
                            selectedColor: AppColors.royalBlue.withOpacity(0.18),
                            onSelected: (_) => setState(() {
                              _selectedStage = stg;
                              _syncSelectedCourse();
                            }),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: db.semesters.map((sem) {
                      final isSel = _selectedSemester == sem;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: SizedBox(
                              width: double.infinity,
                              child: Text(
                                'الكورس $sem',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            selected: isSel,
                            selectedColor:
                            AppColors.primaryPurple.withOpacity(0.18),
                            onSelected: (_) => setState(() {
                              _selectedSemester = sem;
                              _syncSelectedCourse();
                            }),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'مواد $_selectedStage • الكورس $_selectedSemester (${list.length} مواد)',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: AppColors.deepBlue,
                ),
              ),
              TextButton.icon(
                onPressed: () => _showAddOrEditCourseDialog(),
                icon: const Icon(Icons.add_circle_outline, size: 18),
                label: const Text('إضافة مادة'),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ...list.map(
                (c) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.cardBorder),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.skyBlue.withOpacity(0.16),
                  child: Text(
                    '${c.ects}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepBlue,
                    ),
                  ),
                ),
                title: Text(
                  c.nameAr,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                    '${c.nameEn} • ${c.code}\nالموعد: ${c.dayName} (${c.timeForShift(_selectedShift)})'),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.edit_outlined, color: AppColors.royalBlue),
                  onPressed: () => _showAddOrEditCourseDialog(existing: c),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // صفحة 3: إدارة الامتحانات الإلكترونية (MCQ)
  // --------------------------------------------------------------------------
  Widget _buildExamsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryPurple,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: _showCreateMcqExamDialog,
            icon: const Icon(Icons.add_task_rounded),
            label: const Text(
              'إنشاء كويز أو امتحان ميد ترم (MCQ) جديد',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          const SizedBox(height: 14),
          ...db.exams.map(
                (ex) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.cardBorder),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ex.examType,
                          style: const TextStyle(
                            color: AppColors.primaryPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'الدرجة: ${ex.maxScore.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: AppColors.successGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      ex.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w900, fontSize: 15.5),
                    ),
                    Text(
                      '${ex.courseName} (${ex.courseCode}) • ${ex.stage}',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'عدد الأسئلة: ${ex.questions.length} | عدد الطلاب المجيبين: ${ex.studentScores.length}',
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.royalBlue,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // صفحة 4: قوائم الطلاب المفصولة (الصباحي والمسائي)
  // --------------------------------------------------------------------------
  Widget _buildStudentsListsPage() {
    final studentsList = _filteredStudents;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCalmStageShiftSelector(showCourseDropdown: false),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchStudentCtrl,
                  decoration: InputDecoration(
                    hintText:
                    'ابحث في $_selectedStage ($_selectedShift) بالاسم أو الرقم...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchStudentCtrl.text.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () =>
                          setState(() => _searchStudentCtrl.clear()),
                    )
                        : null,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  padding:
                  const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
                ),
                onPressed: () => _showAddOrEditStudentDialog(),
                icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
                label: const Text('إضافة'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'قائمة $_selectedStage • الدراسة ال${_selectedShift}ة (${studentsList.length} طالب)',
            style: const TextStyle(
                fontWeight: FontWeight.w900, color: AppColors.deepBlue),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: min(studentsList.length, 100),
            itemBuilder: (ctx, i) {
              final st = studentsList[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: AppColors.cardBorder),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.skyBlue.withOpacity(0.18),
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.deepBlue),
                    ),
                  ),
                  title: Text(st.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13.5)),
                  subtitle: Text(
                      'الرقم الجامعي: ${st.id} • ${st.stage} (${st.shift})'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined,
                            color: AppColors.royalBlue, size: 20),
                        onPressed: () =>
                            _showAddOrEditStudentDialog(existing: st),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: AppColors.dangerRed, size: 20),
                        onPressed: () => db.deleteStudent(st),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // صفحة 5: السعي السنوي والدرجات
  // --------------------------------------------------------------------------
  Widget _buildGradesPage() {
    final studentsList = _filteredStudents;
    final course = _selectedCourse ?? db.courses.first;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCalmStageShiftSelector(showCourseDropdown: true),
          const SizedBox(height: 10),
          TextField(
            controller: _searchStudentCtrl,
            decoration: const InputDecoration(
              hintText: 'ابحث عن طالب لتعديل أو عرض درجة السعي...',
              prefixIcon: Icon(Icons.search_rounded),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 10),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(color: AppColors.cardBorder),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'سجل السعي والدرجات • ${course.nameAr} (${course.code})',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14.5,
                      color: AppColors.deepBlue,
                    ),
                  ),
                  const Divider(height: 18),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: min(studentsList.length, 60),
                    separatorBuilder: (_, __) => const Divider(height: 8),
                    itemBuilder: (ctx, i) {
                      final st = studentsList[i];
                      final g = db.getStudentGrade(st, course.code);
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          '${i + 1}. ${st.name}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13.5),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              _ScorePill(
                                  text:
                                  'حضور: ${g.attendanceScore.toStringAsFixed(1)}/10',
                                  color: AppColors.skyBlue),
                              _ScorePill(
                                  text: 'كويز: ${g.quizScore.toStringAsFixed(1)}/15',
                                  color: AppColors.primaryPurple),
                              _ScorePill(
                                  text:
                                  'مد: ${g.midtermScore.toStringAsFixed(1)}/25',
                                  color: AppColors.royalBlue),
                              _ScorePill(
                                  text:
                                  'السعي: ${g.annualCoursework.toStringAsFixed(1)}/50',
                                  color: AppColors.successGreen),
                            ],
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit_note_rounded,
                              color: AppColors.primaryPurple),
                          onPressed: () =>
                              _showEditGradeDialog(st, course, g),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // صفحة 6: الملف الشخصي الخاص بالأستاذ
  // --------------------------------------------------------------------------
  Widget _buildProfessorProfilePage() {
    final p = widget.professor;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
              side: const BorderSide(color: AppColors.cardBorder),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const AlMaaqalScientificCrest(size: 76),
                  const SizedBox(height: 12),
                  Text(
                    p.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.deepBlue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    p.title,
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: AppColors.primaryPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 28),
                  _InfoRow(label: 'الكلية والقسم:', value: 'كلية الهندسة • ${p.dept}'),
                  _InfoRow(label: 'اسم المستخدم:', value: p.username),
                  _InfoRow(label: 'البريد الجامعي:', value: p.email),
                  _InfoRow(label: 'الاختصاص الدقيق:', value: p.specialization),
                  _InfoRow(
                    label: 'المراحل التدريسية:',
                    value: 'المرحلة الثانية والمرحلة الثالثة (صباحي ومسائي)',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditGradeDialog(
      StudentModel st, CourseModel course, StudentGradeRecord g) {
    final attCtrl =
    TextEditingController(text: g.attendanceScore.toStringAsFixed(1));
    final quizCtrl =
    TextEditingController(text: g.quizScore.toStringAsFixed(1));
    final midCtrl =
    TextEditingController(text: g.midtermScore.toStringAsFixed(1));
    final finCtrl =
    TextEditingController(text: g.finalExamScore.toStringAsFixed(1));

    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(
            'تعديل درجات الطالب:\n${st.name}',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: attCtrl,
                  keyboardType: TextInputType.number,
                  decoration:
                  const InputDecoration(labelText: 'درجة الحضور (من 10)'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: quizCtrl,
                  keyboardType: TextInputType.number,
                  decoration:
                  const InputDecoration(labelText: 'درجة الكويزات (من 15)'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: midCtrl,
                  keyboardType: TextInputType.number,
                  decoration:
                  const InputDecoration(labelText: 'درجة امتحان المد (من 25)'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: finCtrl,
                  keyboardType: TextInputType.number,
                  decoration:
                  const InputDecoration(labelText: 'الامتحان النهائي (من 50)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () {
                db.updateStudentGrade(
                  student: st,
                  courseCode: course.code,
                  attendance: double.tryParse(attCtrl.text) ?? g.attendanceScore,
                  quiz: double.tryParse(quizCtrl.text) ?? g.quizScore,
                  midterm: double.tryParse(midCtrl.text) ?? g.midtermScore,
                  finalExam: double.tryParse(finCtrl.text) ?? g.finalExamScore,
                );
                Navigator.pop(ctx);
              },
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddOrEditStudentDialog({StudentModel? existing}) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final idCtrl = TextEditingController(
        text: existing?.id ??
            '${Random().nextInt(899999999) + 1000000000}');
    String stage = existing?.stage ?? _selectedStage;
    String shift = existing?.shift ?? _selectedShift;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(existing == null ? 'إضافة طالب جديد' : 'تعديل بيانات الطالب'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'اسم الطالب الرباعي'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: idCtrl,
                    decoration: const InputDecoration(labelText: 'الرقم الجامعي'),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: stage,
                    decoration: const InputDecoration(labelText: 'المرحلة الدراسية'),
                    items: db.stages
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setDialogState(() => stage = v);
                    },
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: shift,
                    decoration: const InputDecoration(labelText: 'نوع الدراسة'),
                    items: db.shifts
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setDialogState(() => shift = v);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('إلغاء'),
              ),
              FilledButton(
                onPressed: () {
                  if (nameCtrl.text.trim().isEmpty || idCtrl.text.trim().isEmpty) {
                    return;
                  }
                  if (existing == null) {
                    db.addStudent(
                      id: idCtrl.text.trim(),
                      name: nameCtrl.text.trim(),
                      stage: stage,
                      shift: shift,
                    );
                  } else {
                    db.updateStudent(
                      existing,
                      name: nameCtrl.text.trim(),
                      id: idCtrl.text.trim(),
                      stage: stage,
                      shift: shift,
                    );
                  }
                  Navigator.pop(ctx);
                },
                child: const Text('حفظ'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddOrEditCourseDialog({CourseModel? existing}) {
    final nameArCtrl = TextEditingController(text: existing?.nameAr ?? '');
    final nameEnCtrl = TextEditingController(text: existing?.nameEn ?? '');
    final codeCtrl = TextEditingController(text: existing?.code ?? '');
    final ectsCtrl =
    TextEditingController(text: (existing?.ects ?? 5).toString());
    String stage = existing?.stage ?? _selectedStage;
    String semName = existing?.semName ?? _selectedSemester;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(existing == null ? 'إضافة مادة دراسية' : 'تعديل المادة'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameArCtrl,
                    decoration:
                    const InputDecoration(labelText: 'اسم المادة بالعربية'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameEnCtrl,
                    decoration:
                    const InputDecoration(labelText: 'اسم المادة بالإنجليزية'),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: codeCtrl,
                          decoration:
                          const InputDecoration(labelText: 'رمز المقرر'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: ectsCtrl,
                          keyboardType: TextInputType.number,
                          decoration:
                          const InputDecoration(labelText: 'وحدات ECTS'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: stage,
                    decoration: const InputDecoration(labelText: 'المرحلة'),
                    items: db.stages
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setDialogState(() => stage = v);
                    },
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: semName,
                    decoration: const InputDecoration(labelText: 'الكورس الدراسي'),
                    items: db.semesters
                        .map((s) =>
                        DropdownMenuItem(value: s, child: Text('الكورس $s')))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setDialogState(() => semName = v);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
              FilledButton(
                onPressed: () {
                  if (nameArCtrl.text.trim().isEmpty ||
                      codeCtrl.text.trim().isEmpty) {
                    return;
                  }
                  if (existing == null) {
                    db.addCourse(
                      stage: stage,
                      semName: semName,
                      code: codeCtrl.text.trim(),
                      nameAr: nameArCtrl.text.trim(),
                      nameEn: nameEnCtrl.text.trim(),
                      ects: int.tryParse(ectsCtrl.text) ?? 5,
                    );
                  } else {
                    db.updateCourse(
                      existing,
                      stage: stage,
                      semName: semName,
                      code: codeCtrl.text.trim(),
                      nameAr: nameArCtrl.text.trim(),
                      nameEn: nameEnCtrl.text.trim(),
                      ects: int.tryParse(ectsCtrl.text) ?? 5,
                    );
                  }
                  Navigator.pop(ctx);
                },
                child: const Text('حفظ'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreateMcqExamDialog() {
    final titleCtrl = TextEditingController();
    String examType = 'كويز يومي (Quiz)';
    CourseModel selectedCourse = _selectedCourse ?? db.courses.first;
    final qTextCtrl = TextEditingController();
    final opt1Ctrl = TextEditingController();
    final opt2Ctrl = TextEditingController();
    final opt3Ctrl = TextEditingController();
    final opt4Ctrl = TextEditingController();
    int correctIdx = 0;
    final List<McqQuestion> tempQuestions = [];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: const Text(
                'إنشاء اختبار MCQ جديد',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<String>(
                      value: examType,
                      decoration: const InputDecoration(labelText: 'نوع الاختبار'),
                      items: const [
                        DropdownMenuItem(
                            value: 'كويز يومي (Quiz)',
                            child: Text('كويز يومي (Quiz)')),
                        DropdownMenuItem(
                            value: 'امتحان فصلي (Midterm)',
                            child: Text('امتحان فصلي (Midterm)')),
                      ],
                      onChanged: (v) {
                        if (v != null) setDialogState(() => examType = v);
                      },
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<CourseModel>(
                      value: selectedCourse,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'المادة الدراسية'),
                      items: db.courses
                          .map((c) => DropdownMenuItem(
                        value: c,
                        child: Text('${c.nameAr} (${c.stage})'),
                      ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setDialogState(() => selectedCourse = v);
                      },
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: titleCtrl,
                      decoration: const InputDecoration(labelText: 'عنوان الاختبار'),
                    ),
                    const Divider(height: 20),
                    Text(
                      'إضافة سؤال (${tempQuestions.length} مضاف):',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryPurple),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: qTextCtrl,
                      decoration: const InputDecoration(labelText: 'نص السؤال'),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                        controller: opt1Ctrl,
                        decoration: const InputDecoration(labelText: 'الخيار 1')),
                    const SizedBox(height: 6),
                    TextField(
                        controller: opt2Ctrl,
                        decoration: const InputDecoration(labelText: 'الخيار 2')),
                    const SizedBox(height: 6),
                    TextField(
                        controller: opt3Ctrl,
                        decoration: const InputDecoration(labelText: 'الخيار 3')),
                    const SizedBox(height: 6),
                    TextField(
                        controller: opt4Ctrl,
                        decoration: const InputDecoration(labelText: 'الخيار 4')),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<int>(
                      value: correctIdx,
                      decoration: const InputDecoration(labelText: 'الخيار الصحيح'),
                      items: const [
                        DropdownMenuItem(value: 0, child: Text('الخيار 1')),
                        DropdownMenuItem(value: 1, child: Text('الخيار 2')),
                        DropdownMenuItem(value: 2, child: Text('الخيار 3')),
                        DropdownMenuItem(value: 3, child: Text('الخيار 4')),
                      ],
                      onChanged: (v) {
                        if (v != null) setDialogState(() => correctIdx = v);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
                FilledButton(
                  onPressed: () {
                    if (qTextCtrl.text.trim().isNotEmpty) {
                      tempQuestions.add(
                        McqQuestion(
                          questionText: qTextCtrl.text.trim(),
                          options: [
                            opt1Ctrl.text.trim().isEmpty
                                ? 'خيار 1'
                                : opt1Ctrl.text.trim(),
                            opt2Ctrl.text.trim().isEmpty
                                ? 'خيار 2'
                                : opt2Ctrl.text.trim(),
                            opt3Ctrl.text.trim().isEmpty
                                ? 'خيار 3'
                                : opt3Ctrl.text.trim(),
                            opt4Ctrl.text.trim().isEmpty
                                ? 'خيار 4'
                                : opt4Ctrl.text.trim(),
                          ],
                          correctOptionIndex: correctIdx,
                          points: examType.contains('كويز') ? 15.0 : 25.0,
                        ),
                      );
                    }
                    if (tempQuestions.isEmpty) return;
                    db.exams.insert(
                      0,
                      ExamQuizModel(
                        id: 'EXAM-${DateTime.now().millisecondsSinceEpoch}',
                        title: titleCtrl.text.trim().isEmpty
                            ? '$examType - ${selectedCourse.nameAr}'
                            : titleCtrl.text.trim(),
                        examType: examType,
                        dept: UniversityDatabase.singleDepartment,
                        stage: selectedCourse.stage,
                        courseCode: selectedCourse.code,
                        courseName: selectedCourse.nameAr,
                        createdByProf: widget.professor.name,
                        questions: tempQuestions,
                      ),
                    );
                    db.notifyListeners();
                    Navigator.pop(ctx);
                  },
                  child: const Text('نشر الاختبار'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ============================================================================
// 8. واجهة حساب الطالب المستقلة (مع جدول المحاضرات وأوقاتها وسجل الحضور لكل مادة)
// ============================================================================
class StudentMainScreen extends StatefulWidget {
  final StudentModel student;
  const StudentMainScreen({super.key, required this.student});

  @override
  State<StudentMainScreen> createState() => _StudentMainScreenState();
}

class _StudentMainScreenState extends State<StudentMainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final db = UniversityDatabase.instance;

  // الفهرس الحالي للواجهة:
  // 0 = الهوية الجامعية الرقمية
  // 1 = جدول المحاضرات وأوقاتها
  // 2 = المواد الدراسية (حسب الكورس)
  // 3 = الاختبارات الإلكترونية (MCQ)
  // 4 = السعي السنوي والدرجات
  // 5 = سجل الحضور والغياب لكل مادة ومحاضرة
  // 6 = الملف الشخصي للطالب
  int _activePageIndex = 0;

  late String _selectedStage;
  String _selectedSemester = 'الأول';
  String _selectedDayFilter = 'كل الأيام';

  @override
  void initState() {
    super.initState();
    _selectedStage = widget.student.stage;
  }

  List<CourseModel> get _studentCourses {
    return db.courses
        .where(
            (c) => c.stage == _selectedStage && c.semName == _selectedSemester)
        .toList();
  }

  Widget _buildStudentRightSideDrawer() {
    final st = widget.student;
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              bottom: 20,
              right: 18,
              left: 18,
            ),
            decoration: const BoxDecoration(
              gradient: AppColors.studentGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AlMaaqalScientificCrest(size: 58, showGlow: false),
                const SizedBox(height: 12),
                Text(
                  st.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'الرقم الجامعي: ${st.id} • ${st.stage} (${st.shift})',
                  style: const TextStyle(
                    color: AppColors.lightSky,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _DrawerMenuTile(
                  icon: Icons.account_circle_rounded,
                  title: 'الملف الشخصي للطالب',
                  selected: _activePageIndex == 6,
                  onTap: () => _selectPage(6),
                ),
                const Divider(height: 12),
                _DrawerMenuTile(
                  icon: Icons.badge_rounded,
                  title: 'هويتي الجامعية الرقمية',
                  selected: _activePageIndex == 0,
                  onTap: () => _selectPage(0),
                ),
                _DrawerMenuTile(
                  icon: Icons.calendar_month_rounded,
                  title: 'جدول المحاضرات وأوقاتها',
                  selected: _activePageIndex == 1,
                  onTap: () => _selectPage(1),
                ),
                _DrawerMenuTile(
                  icon: Icons.event_available_rounded,
                  title: 'سجل الحضور لكل مادة ومحاضرة',
                  selected: _activePageIndex == 5,
                  onTap: () => _selectPage(5),
                ),
                _DrawerMenuTile(
                  icon: Icons.auto_stories_rounded,
                  title: 'المواد الدراسية (حسب الكورس)',
                  selected: _activePageIndex == 2,
                  onTap: () => _selectPage(2),
                ),
                _DrawerMenuTile(
                  icon: Icons.analytics_rounded,
                  title: 'السعي السنوي والدرجات',
                  selected: _activePageIndex == 4,
                  onTap: () => _selectPage(4),
                ),
                _DrawerMenuTile(
                  icon: Icons.fact_check_rounded,
                  title: 'الامتحانات الإلكترونية (MCQ)',
                  selected: _activePageIndex == 3,
                  onTap: () => _selectPage(3),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: AppColors.dangerRed),
            title: const Text(
              'تسجيل الخروج',
              style: TextStyle(
                color: AppColors.dangerRed,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const AuthScreen()),
              );
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  void _selectPage(int index) {
    Navigator.pop(context);
    setState(() => _activePageIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: db,
      builder: (context, _) {
        final titles = [
          'بوابة الطالب • الهوية الجامعية الرقمية',
          'بوابة الطالب • جدول المحاضرات وأوقاتها',
          'بوابة الطالب • المواد الدراسية حسب الكورس',
          'بوابة الطالب • الامتحانات الإلكترونية (MCQ)',
          'بوابة الطالب • السعي السنوي والدرجات',
          'بوابة الطالب • سجل الحضور لكل مادة ومحاضرة',
          'بوابة الطالب • الملف الشخصي الأكاديمي',
        ];

        final bottomIdx = _activePageIndex < 4 ? _activePageIndex : 0;

        return Scaffold(
          key: _scaffoldKey,
          drawer: _buildStudentRightSideDrawer(),
          drawerEdgeDragWidth: 60,
          body: Column(
            children: [
              UniversityHeaderBanner(
                screenTitle: titles[_activePageIndex],
                subtitle: '${widget.student.name} • ${widget.student.stage} (${widget.student.shift})',
                isStudentTheme: true,
                onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
              ),
              Expanded(
                child: IndexedStack(
                  index: _activePageIndex,
                  children: [
                    _buildStudentIdCardPage(),
                    _buildStudentSchedulePage(),
                    _buildStudentCoursesPage(),
                    _buildStudentExamsPage(),
                    _buildStudentGradesPage(),
                    _buildStudentAttendanceLogPage(),
                    _buildStudentProfilePage(),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: bottomIdx,
            onDestinationSelected: (i) => setState(() => _activePageIndex = i),
            backgroundColor: Colors.white,
            indicatorColor: AppColors.skyBlue.withOpacity(0.22),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.badge_outlined),
                selectedIcon:
                Icon(Icons.badge_rounded, color: AppColors.royalBlue),
                label: 'هويتي',
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_month_outlined),
                selectedIcon: Icon(Icons.calendar_month_rounded,
                    color: AppColors.primaryPurple),
                label: 'جدول المحاضرات',
              ),
              NavigationDestination(
                icon: Icon(Icons.auto_stories_outlined),
                selectedIcon: Icon(Icons.auto_stories_rounded,
                    color: AppColors.royalBlue),
                label: 'المواد',
              ),
              NavigationDestination(
                icon: Icon(Icons.fact_check_outlined),
                selectedIcon: Icon(Icons.fact_check_rounded,
                    color: AppColors.primaryPurple),
                label: 'الامتحانات',
              ),
            ],
          ),
        );
      },
    );
  }

  // صفحة 0: الهوية الجامعية الرقمية للطالب
  Widget _buildStudentIdCardPage() {
    final st = widget.student;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.studentGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.royalBlue.withOpacity(0.28),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const AlMaaqalScientificCrest(size: 50, showGlow: false),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'جامعة المعقل • كلية الهندسة',
                            style: TextStyle(
                              color: AppColors.lightSky,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'بطاقة الهوية الجامعية الذكية',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (st.nfcTagUid.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.nfc_rounded, color: Colors.white, size: 15),
                            SizedBox(width: 4),
                            Text(
                              'NFC مرتبط',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const Divider(color: Colors.white24, height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('اسم الطالب:',
                              style: TextStyle(
                                  color: AppColors.lightSky, fontSize: 11)),
                          Text(
                            st.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text('الرقم الجامعي المعرفي:',
                              style: TextStyle(
                                  color: AppColors.lightSky, fontSize: 11)),
                          Text(
                            st.id,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'القسم: ${st.dept}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${st.stage} • الدراسة ال${st.shift}ة',
                            style: const TextStyle(
                              color: AppColors.lightSky,
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    CustomQrCodeWidget(data: st.id, size: 110),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(color: AppColors.cardBorder),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.lightSky,
                child: Icon(Icons.calendar_month_rounded, color: AppColors.deepBlue),
              ),
              title: const Text(
                'جدول المحاضرات وحضور المواد',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
              ),
              subtitle: const Text(
                'اضغط هنا لعرض جدول محاضراتك الأسبوعي وأوقاتها وحالة حضورك في كل مادة على حدة.',
                style: TextStyle(fontSize: 12),
              ),
              onTap: () => setState(() => _activePageIndex = 1),
            ),
          ),
        ],
      ),
    );
  }

  // صفحة 1: جدول المحاضرات وأوقاتها للطالب (مع حالة الحضور الخاصة بكل مادة)
  Widget _buildStudentSchedulePage() {
    final st = widget.student;
    final list = _studentCourses;
    final filtered = _selectedDayFilter == 'كل الأيام'
        ? list
        : list.where((c) => c.dayName == _selectedDayFilter).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(color: AppColors.cardBorder),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'جدول محاضرات ${st.stage} • الدراسة ال${st.shift}ة',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      color: AppColors.deepBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: db.semesters.map((sem) {
                      final isSel = _selectedSemester == sem;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: SizedBox(
                              width: double.infinity,
                              child: Text('الكورس $sem',
                                  textAlign: TextAlign.center),
                            ),
                            selected: isSel,
                            selectedColor:
                            AppColors.primaryPurple.withOpacity(0.18),
                            onSelected: (_) =>
                                setState(() => _selectedSemester = sem),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['كل الأيام', ...db.weekDays].map((d) {
                        final isSel = _selectedDayFilter == d;
                        return Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: ChoiceChip(
                            label: Text(d),
                            selected: isSel,
                            selectedColor: AppColors.royalBlue,
                            labelStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isSel ? Colors.white : AppColors.textDark,
                            ),
                            onSelected: (_) =>
                                setState(() => _selectedDayFilter = d),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...filtered.map((c) {
            final presentCnt = st.countPresentForCourse(c.code);
            final absentCnt = st.countAbsentForCourse(c.code);
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: const BorderSide(color: AppColors.cardBorder),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.royalBlue.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            c.dayName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              color: AppColors.royalBlue,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryPurple.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time_filled_rounded,
                                  size: 14, color: AppColors.primaryPurple),
                              const SizedBox(width: 4),
                              Text(
                                c.timeForShift(st.shift),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryPurple,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${c.nameAr} (${c.code})',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: AppColors.deepBlue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'المكان: ${c.roomName} • النوع: ${c.lectureType}',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _ScorePill(
                          text: 'حضورك في هذه المادة: $presentCnt محاضرة',
                          color: presentCnt > 0
                              ? AppColors.successGreen
                              : AppColors.royalBlue,
                        ),
                        const SizedBox(width: 6),
                        if (absentCnt > 0)
                          _ScorePill(
                            text: 'الغياب: $absentCnt',
                            color: AppColors.dangerRed,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // صفحة 2: المواد الدراسية للطالب حسب الكورس
  Widget _buildStudentCoursesPage() {
    final list = _studentCourses;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(color: AppColors.cardBorder),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: db.stages.map((stg) {
                      final isSel = _selectedStage == stg;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: SizedBox(
                              width: double.infinity,
                              child: Text(stg, textAlign: TextAlign.center),
                            ),
                            selected: isSel,
                            selectedColor: AppColors.royalBlue.withOpacity(0.18),
                            onSelected: (_) =>
                                setState(() => _selectedStage = stg),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: db.semesters.map((sem) {
                      final isSel = _selectedSemester == sem;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: SizedBox(
                              width: double.infinity,
                              child: Text('الكورس $sem',
                                  textAlign: TextAlign.center),
                            ),
                            selected: isSel,
                            selectedColor:
                            AppColors.primaryPurple.withOpacity(0.18),
                            onSelected: (_) =>
                                setState(() => _selectedSemester = sem),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...list.map(
                (c) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.cardBorder),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.skyBlue.withOpacity(0.18),
                  child: Text(
                    '${c.ects}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepBlue,
                    ),
                  ),
                ),
                title: Text(
                  c.nameAr,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${c.nameEn} • ${c.code}'),
                trailing: Text(
                  '${c.ects} ECTS',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryPurple,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // صفحة 3: الامتحانات الإلكترونية للطالب (MCQ)
  Widget _buildStudentExamsPage() {
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: db.exams.length,
      itemBuilder: (ctx, i) {
        final ex = db.exams[i];
        final prevScore = ex.studentScores[widget.student.id];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: AppColors.cardBorder),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ex.examType,
                      style: const TextStyle(
                        color: AppColors.primaryPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'المدة: ${ex.durationMinutes} دقيقة',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  ex.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w900, fontSize: 15.5),
                ),
                Text(
                  '${ex.courseName} • أستاذ المادة: ${ex.createdByProf}',
                  style:
                  const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (prevScore != null)
                      Text(
                        'درجتك: ${prevScore.toStringAsFixed(1)} / ${ex.maxScore.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: AppColors.successGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    else
                      Text(
                        'عدد الأسئلة: ${ex.questions.length}',
                        style: const TextStyle(
                          color: AppColors.royalBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                          backgroundColor: AppColors.royalBlue),
                      onPressed: () => _openTakeExamSheet(ex),
                      child: Text(prevScore == null ? 'بدء الاختبار' : 'إعادة الحل'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // صفحة 4: السعي السنوي والدرجات للطالب
  Widget _buildStudentGradesPage() {
    final coursesList =
    db.courses.where((c) => c.stage == widget.student.stage).toList();
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: coursesList.length,
      itemBuilder: (ctx, i) {
        final c = coursesList[i];
        final g = db.getStudentGrade(widget.student, c.code);
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.cardBorder),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${c.nameAr} (الكورس ${c.semName})',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: AppColors.deepBlue,
                        ),
                      ),
                    ),
                    Text(
                      'السعي: ${g.annualCoursework.toStringAsFixed(1)} / 50',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.successGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _ScorePill(
                        text: 'الحضور: ${g.attendanceScore.toStringAsFixed(1)}/10',
                        color: AppColors.skyBlue),
                    _ScorePill(
                        text: 'الكويزات: ${g.quizScore.toStringAsFixed(1)}/15',
                        color: AppColors.primaryPurple),
                    _ScorePill(
                        text: 'المد: ${g.midtermScore.toStringAsFixed(1)}/25',
                        color: AppColors.royalBlue),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // صفحة 5: سجل الحضور والغياب المفصل لكل مادة ومحاضرة على حدة
  Widget _buildStudentAttendanceLogPage() {
    final st = widget.student;
    final myStageCourses =
    db.courses.where((c) => c.stage == st.stage).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: myStageCourses.length,
      itemBuilder: (ctx, i) {
        final c = myStageCourses[i];
        final recs = st.recordsByCourseCode[c.code] ?? [];
        final presentCount = st.countPresentForCourse(c.code);
        final absentCount = st.countAbsentForCourse(c.code);

        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.cardBorder),
          ),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: presentCount > 0
                  ? AppColors.successGreen.withOpacity(0.16)
                  : AppColors.skyBlue.withOpacity(0.16),
              child: Icon(
                presentCount > 0
                    ? Icons.check_circle_rounded
                    : Icons.schedule_rounded,
                color: presentCount > 0
                    ? AppColors.successGreen
                    : AppColors.royalBlue,
              ),
            ),
            title: Text(
              '${c.nameAr} (${c.code})',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14),
            ),
            subtitle: Text(
              'الموعد: ${c.dayName} (${c.timeForShift(st.shift)}) • حضور: $presentCount | غياب: $absentCount',
              style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted),
            ),
            children: [
              if (recs.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'لم يتم تسجيل حضور أو غياب في محاضرات هذه المادة حتى الآن.',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                )
              else
                ...recs.map(
                      (r) => ListTile(
                    dense: true,
                    leading: Icon(
                      r.status == 'حاضر'
                          ? Icons.verified_rounded
                          : Icons.cancel_rounded,
                      color: r.status == 'حاضر'
                          ? AppColors.successGreen
                          : AppColors.dangerRed,
                    ),
                    title: Text(
                      r.lectureSessionLabel,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${r.roomName} • ${r.method}'),
                    trailing: Text(
                      r.status,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: r.status == 'حاضر'
                            ? AppColors.successGreen
                            : AppColors.dangerRed,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // صفحة 6: الملف الشخصي الخاص بالطالب
  Widget _buildStudentProfilePage() {
    final st = widget.student;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const AlMaaqalScientificCrest(size: 74),
              const SizedBox(height: 12),
              Text(
                st.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  color: AppColors.deepBlue,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'طالب جامعي • كلية الهندسة',
                style: TextStyle(
                  color: AppColors.primaryPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(height: 28),
              _InfoRow(label: 'القسم العلمي:', value: st.dept),
              _InfoRow(label: 'المرحلة الدراسية:', value: st.stage),
              _InfoRow(label: 'نوع الدراسة:', value: 'الدراسة ال${st.shift}ة'),
              _InfoRow(label: 'الرقم الجامعي المعرفي:', value: st.id),
              _InfoRow(label: 'اسم المستخدم:', value: st.username),
              _InfoRow(
                label: 'شريحة البطاقة الجامعية (NFC):',
                value: st.nfcTagUid.isEmpty ? 'غير مسجلة' : st.nfcTagUid,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openTakeExamSheet(ExamQuizModel exam) {
    final Map<int, int> selectedAnswers = {};
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.84,
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  exam.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: AppColors.deepBlue,
                  ),
                ),
                const Divider(height: 18),
                Expanded(
                  child: ListView.builder(
                    itemCount: exam.questions.length,
                    itemBuilder: (_, qIdx) {
                      final q = exam.questions[qIdx];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'س${qIdx + 1}: ${q.questionText}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              ...List.generate(q.options.length, (optIdx) {
                                return RadioListTile<int>(
                                  value: optIdx,
                                  groupValue: selectedAnswers[qIdx],
                                  title: Text(q.options[optIdx]),
                                  dense: true,
                                  onChanged: (v) {
                                    if (v != null) {
                                      setSheetState(
                                              () => selectedAnswers[qIdx] = v);
                                    }
                                  },
                                );
                              }),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    double earned = 0.0;
                    for (int i = 0; i < exam.questions.length; i++) {
                      if (selectedAnswers[i] ==
                          exam.questions[i].correctOptionIndex) {
                        earned += exam.questions[i].points;
                      }
                    }
                    db.submitExamAnswers(
                      exam: exam,
                      student: widget.student,
                      earnedScore: earned,
                    );
                    Navigator.pop(ctx);
                  },
                  child: const Text('تسليم الإجابات'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 9. عناصر واجهة مساعدة هادئة ومتناسقة
// ============================================================================
class _DrawerMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _DrawerMenuTile({
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: selected ? AppColors.primaryPurple : AppColors.royalBlue,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
          color: selected ? AppColors.primaryPurple : AppColors.textDark,
          fontSize: 14,
        ),
      ),
      selected: selected,
      selectedTileColor: AppColors.skyBlue.withOpacity(0.14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: onTap,
    );
  }
}

class _MethodTabButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _MethodTabButton({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            gradient: selected ? AppColors.buttonGradient : null,
            color: selected ? null : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? Colors.transparent : AppColors.cardBorder,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: selected ? Colors.white : AppColors.royalBlue,
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: selected ? Colors.white : AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatBadge({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.35)),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttendanceActionChip extends StatelessWidget {
  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  const _AttendanceActionChip({
    required this.label,
    required this.active,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: active ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: active ? Colors.white : color,
          ),
        ),
      ),
    );
  }
}

class _ScorePill extends StatelessWidget {
  final String text;
  final Color color;

  const _ScorePill({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
                color: AppColors.textMuted, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 10. بيانات مواد قسم هندسة الأمن السيبراني والطلاب (المرحلة الثانية والثالثة)
// ============================================================================
const List<String> _rawCyberCoursesData = [
  '109|2|1|3|0|CREQ300|اللغة الإنجليزية 2|English Language II|2|cyber|3|CREQ300', '110|2|1|3|0|CYSE300|البرمجة الكيانية|Object Oriented Programming|6|cyber|3|CYSE300',
  '111|2|1|3|0|CYSE301|مقدمة في التشفير|Introduction to Cryptography|6|cyber|3|CYSE301', '112|2|1|3|0|CYSE302|نظم قواعد البيانات|Database Systems|5|cyber|3|CYSE302',
  '113|2|1|3|0|CYSE303|برمجة تطبيقات المواقع|Web Application Programming|5|cyber|3|CYSE303', '114|2|1|3|0|CYSE304|الاحتمالية والإحصاء|Probability and Statistics|4|cyber|3|CYSE304',
  '115|2|1|3|0|UREQ201|جرائم نظام البعث|Crimes of Baath Regime|2|cyber|3|UREQ201', '116|2|1|4|1|CREQ405|هياكل البيانات والخوارزميات|Data Structures and Algorithms|5|cyber|4|CREQ405',
  '117|2|1|4|1|CYSE400|نظم التشغيل|Operating Systems|5|cyber|4|CYSE400', '118|2|1|4|1|CYSE401|أمن قواعد البيانات|Database Security|5|cyber|4|CYSE401',
  '119|2|1|4|1|CYSE402|التشفير المتقدم|Advanced Cryptography|5|cyber|4|CYSE402', '120|2|1|4|1|CYSE403|أمن برمجة المواقع|Web Programming Security|4|cyber|4|CYSE403',
  '121|2|1|4|1|CYSE404|بروتوكولات الإنترنت|Internet Protocols|4|cyber|4|CYSE404', '122|2|1|4|1|UREQ202|اللغة العربية|Arabic Language|2|cyber|4|UREQ202',
  '123|2|2|5|0|CYSE500|أمن نظم التشغيل|Operating Systems Security|5|cyber|5|CYSE500', '124|2|2|5|0|CYSE501|أمن الشبكات|Network Security|5|cyber|5|CYSE501',
  '125|2|2|5|0|CYSE502|الذكاء الاصطناعي في الأمن السيبراني|Artificial Intelligence in Cybersecurity|5|cyber|5|CYSE502', '126|2|2|5|0|CYSE503|البرمجة الآمنة|Secure Programming|5|cyber|5|CYSE503',
  '127|2|2|5|0|CYSE504|التقنية اللاسلكية|Wireless Technology|4|cyber|5|CYSE504', '128|2|2|5|0|CYSE505|الحوسبة المتنقلة|Mobile Computing|4|cyber|5|CYSE505',
  '129|2|2|5|0|UREQ500|اللغة الإنجليزية 3|English Language III|2|cyber|5|UREQ500', '130|2|2|6|1|CYSE600|أمن الشبكات اللاسلكية|Wireless Networks Security|5|cyber|6|CYSE600',
  '131|2|2|6|1|CYSE601|الحوسبة السحابية وافتراضية الشبكات|Cloud Computing and Networks Virtualization|5|cyber|6|CYSE601', '132|2|2|6|1|CYSE602|كشف ومنع التسلل|Intrusion Detection and Prevention|5|cyber|6|CYSE602',
  '133|2|2|6|1|CYSE603|أمن إنترنت الأشياء|Internet of Things Security|5|cyber|6|CYSE603', '134|2|2|6|1|CYSE604|برمجة جافاسكريبت|JavaScript Programming|3|cyber|6|CYSE604',
  '135|2|2|6|1|CYSE605|المعالجات الدقيقة|Microprocessors|4|cyber|6|CYSE605', '136|2|2|6|1|CYSE606|أمن الشبكات الاجتماعية|Social Networks Security|3|cyber|6|CYSE606',
];

const List<String> _rawStudentsData = [
  '1|1989616052|ابرار منخي لفته كزار|1|0', '2|8153029478|ابراهيم محمد علي جاسم|1|0', '3|7995964454|احمد اياد كاظم نعيمه|1|0',
  '4|5756286074|احمد رحيم لعيبي موسى|1|0', '5|3793707673|احمد زكي يحيى علي|1|0', '6|4598875077|احمد مجيد ثاجب محسن|1|0',
  '7|4999170370|احمد وسام عباس حيدر|1|0', '8|9729339768|افراق حسين صبيح علوان|1|0', '9|7922674553|الاميرمحمد ايوب حسب علي|1|0',
  '10|4145888063|الحسن محمد هاشم جابر|1|0', '11|4786255318|ايمن عماد محسن محمد|1|0', '12|9533642157|ايناس احمد مجيدي حشيش|1|0',
  '13|4293381578|باقر فاخر عبود جلهوم|1|0', '14|4204697196|بدر خالد بدر خالد|1|0', '15|3851498902|بنين جاسم كاظم جبر|1|0',
  '16|4623242519|تبارك عقيل حسن حمود|1|0', '17|6642782503|تكتم هشام لفته عبدالزهره|1|0', '18|5125940213|جعفر شفيق ساجت مجيدي|1|0',
  '19|9509706892|جلال سعد صالح شنيار|1|0', '20|4792191551|حازم جابر جويد جابر|1|0', '21|1611395919|حسن ايفان خليل ابراهيم|1|0',
  '22|9708375494|حسن جمعه نجم عبيد|1|0', '23|4278512310|حسن عباس جبار حسن|1|0', '24|3406878118|حسن فالح حسن عودة|1|0',
  '25|9991861032|حسنين علي خلف شجاي|1|0', '26|1117025207|حسين احمد عبد الزهره حسين|1|0', '27|5762515292|حسين جابر ظاهر جاسم|1|0',
  '28|1301885802|حسين جاسم محمد حسين|1|0', '29|7452968747|حسين جميل دبيش فهد|1|0', '30|8883256155|حسين حيدر ناصح اسماعيل|1|0',
  '31|5781890709|حسين علاء محمد حسن عبد الحسن|1|0', '32|3617588218|حسين علي حسين يسر|1|0', '33|4268203901|حسين علي رحيم عوده|1|0',
  '34|8446206336|حسين علي فاضل عبود|1|0', '35|2536098989|حسين لؤي احمد شهاب|1|0', '36|2037477561|حسين ناصر جباره حنون|1|0',
  '37|8141991852|حسين نشأت كاظم ياسين|1|0', '38|4186346546|حنين رعد عبدالحسن مهجر|1|0', '39|8916554481|حوراء محمد عودة محمد|1|0',
  '40|4223260842|حيدر خضير عباس منداس|1|0', '41|5031766935|حيدر عباس فوزي صنكور|1|0', '42|7834955538|حيدر عدنان كاظم رزيج|1|0',
  '43|8079763962|حيدر علاء محمد فياض|1|0', '44|4755129623|حيدر مصطفى جبار عبود|1|0', '45|4674170138|ذوالفقار ادمون داخل مايع|1|0',
  '46|5809334919|رسل مهند عبد الحميد عبد المجيد|1|0', '47|7110748594|رضا سلام محمد اصف|1|0', '48|5907097227|رضا عاطف احمد حسن|1|0',
  '49|8360132799|رضا عقيل مريون غانم|1|0', '50|8879936247|رضا علي عبد الحسين ابراهيم|1|0', '51|2615265677|رضا محمد عيسى عباس|1|0',
  '52|6924122419|رضا وسام عبدالسلام نعمة|1|0', '53|9136455762|ريتاج احمد بدر مناتي|1|0', '54|6424795306|زكريا يوسف احمد|1|0',
  '55|2054695896|زيد خالد عبد علي حسين|1|0', '56|1777684915|زيد سجاد عبدالحسن عبيده|1|0', '57|3214502132|زين العابدين واثق محمد لازم|1|0',
  '58|2139383544|ساره احمد فوزي عبد النبي|1|0', '59|4759546523|ساره نبراس وافي عبدالوهاب|1|0', '60|8464291621|سجاد رحمن جباري مشكور|1|0',
  '61|7193094979|سجاد عبدالرحمن جاسم حمادي|1|0', '62|8345501097|سجاد علي طالب عبد السادة|1|0', '63|9950367521|شاهين خاجاك فروير وارتان|1|0',
  '64|3402028603|شمس عدي شاكر عبد الكريم|1|0', '65|6048484067|شمس علي نوري عبد الحسين|1|0', '66|2771337787|صفا احمد عبد الحليم صالح|1|0',
  '67|9437469112|ضحى نجم عبد عجيل|1|0', '68|1912545857|ضرغام اكرم لطيف محمد|1|0', '69|1552219316|طه محسن عوده خضير|1|0',
  '70|2225999290|عباس كاظم صالح حمزه|1|0', '71|9080139598|عبد الرحمن شوقي عبد الساده عزيز|1|0', '72|4862210291|عبد الرحمن فاضل عباس عبد السادة|1|0',
  '73|1993174550|عبد الرضا عادل احمد ابراهيم|1|0', '74|8838860144|عبد فراس عبدالله فارس|1|0', '75|7978458513|عبدالكريم ابراهيم يعرب عبدالكريم|1|0',
  '76|7103030035|عبدالله جابر عيد سعود|1|0', '77|1491569454|علي احمد حمد كاظم|1|0', '78|6745101340|علي حسين علي دعبول|1|0',
  '79|2432087426|علي حسين ياسين قصاب|1|0', '80|3968843219|علي عدنان عبد الحافظ احمد|1|0', '81|7769237334|علي علاء محمد عبود|1|0',
  '82|7488501926|علي عمار حسين علي|1|0', '83|6140918563|علي مازن هادي عبود|1|0', '84|4397583542|علي محمد خيون شرهان|1|0',
  '85|3065077612|علي محمود عبد الكريم فارس|1|0', '86|9038530759|علي موسى عبد الواحد فجر|1|0', '87|3578591763|علي موفق حمزه عبدالجبار|1|0',
  '88|6907678466|علي وليد محسن دشر|1|0', '89|6443852378|علي يعقوب يوسف خضير|1|0', '90|1916092237|غدير احسان موزان كطامي|1|0',
  '91|7664481221|فاطمة كريم جاسم مونس|1|0', '92|5819130213|فاطمه براق قاسم عبود|1|0', '93|1380850778|فاطمه حسنين صالح مهدي|1|0',
  '94|1638131405|فاطمه رياض خضر نصيف|1|0', '95|3629284511|فاطمه صالح جميل علوان|1|0', '96|9200892095|فاطمه علي والي راضي|1|0',
  '97|1633135733|فرح حميد نجم سالم|1|0', '98|9798122133|فضل الله علي كاظم مناتي|1|0', '99|1085146330|كرار اسعد مطشر ثامر|1|0',
  '100|9218942082|كمال محمد كمال عبداللطيف|1|0', '101|4799704009|مؤمل علي ازغير محيسن|1|0', '102|1157298813|ماجد حميد عوده غانم|1|0',
  '103|4936536879|مجتبى احمد عبدالقادر داخل|1|0', '104|7111840913|محمد اسعد عجيل عبدالقادر|1|0', '105|5473758659|محمد ثامر عبدالرحمن ناصر|1|0',
  '106|3848175083|محمد حسين سلمان عبدالحسين|1|0', '107|4040235635|محمد حسين مولي حسين|1|0', '108|7251333846|محمد خالد مزهر كريم|1|0',
  '109|4126730850|محمد ذنون ياسين عبد الخضر|1|0', '110|2357760568|محمد راضي غضبان جاسم|1|0', '111|6453440016|محمد صادق فاخر قادر خضير|1|0',
  '112|3361332018|محمد صبيح بدر كاطع|1|0', '113|4988521087|محمد عبد الكريم شاكر عبد الكريم|1|0', '114|9404751489|محمد عدي عبد الجليل كاسب|1|0',
  '115|5325511787|محمد علي حسين حميد|1|0', '116|3970258422|محمد علي حقي طاهر مشهد|1|0', '117|6274125331|محمد كريم طاهر جبار|1|0',
  '118|1105523811|محمد مهدي ريسان اسماعيل ابراهيم|1|0', '119|4621221036|محمد ميثم نجم عبدالله|1|0', '120|2220155958|محمد نجيب انور محمد نجيب جابر|1|0',
  '121|2696217319|محمدباقر سؤدد محمد حسن|1|0', '122|7989094373|محمدصادق حامد سهيل حبيني|1|0', '123|6443187078|مرتضى رحيم كريم فنجان|1|0',
  '124|2451494001|مروه مرتضى منذر عبد الوهاب|1|0', '125|2915576909|مريم حيدر عبد محمد طالب|1|0', '126|2749924106|مصطفى علاء ابراهيم كريم|1|0',
  '127|3786740991|مصطفى فرحان سدخان كاظم|1|0', '128|5133794160|مقتدى محمد كريم ناصر|1|0', '129|6897696253|مقتدى مصطفى عريبي نصير|1|0',
  '130|6969068210|منتظر ماجد جاسم بدر|1|0', '131|5520635250|منتظر ماجد مكي خضير|1|0', '132|1416458543|مهيمن صادق كاطع وشاح|1|0',
  '133|3910668865|مهيمن قصي كريم خلف|1|0', '134|9292738690|ندى حكمت شامل عبد الحسين|1|0', '135|9535019566|نرجس زياره نعيم مطوي|1|0',
  '136|2346529945|نور الزهراء ربيع داخل غانم|1|0', '137|2444810025|نور حسين عبدالزهره مال الله|1|0', '138|6884906936|هدى صالح ابراهيم صالح|1|0',
  '139|5304738190|هنادي عبدالغني بدر جاسم|1|0', '140|2279200444|يوسف اسماعيل خضير عباس|1|0', '141|3161885187|يوسف مناف سالم حمدي|1|0',
  '142|1825312889|آية عمار محمد عليوي|1|1', '143|9637531940|أبا تراب فرج منصور علي|1|1', '144|1039113008|ابراهيم احمد فؤاد عبد القادر|1|1',
  '145|3996545950|احمد ظافر عبدعلي جميل|1|1', '146|1430163975|احمد علاء حسين علي|1|1', '147|2417602555|احمد هادي كاظم عبدالكريم|1|1',
  '148|5660604746|امير حيدر عبدالامير هادي|1|1', '149|8921210186|ايلاف احمد عطار جاسم|1|1', '150|6097615145|بهاء الامير هاشم حمزه جدوع|1|1',
  '151|9798918184|جعفر محمد عبدالرضا مهاوي|1|1', '152|3370981800|حسن صباح حاتم عباس|1|1', '153|3942262226|حسن عامر خلف ثامر|1|1',
  '154|6733739715|حسن فرحان نجم عبدالله|1|1', '155|9846699052|حسن قاهر قيس عبد السادة|1|1', '156|4868247555|حسين ستار محسن غياض|1|1',
  '157|2765934843|حسين صلاح الدين عبد الحسين عساف|1|1', '158|1618845282|حسين عباس عوده عبد الله|1|1', '159|6041483064|حسين علاء جاسم محمد|1|1',
  '160|1374575132|حسين مارد فؤاد يونس|1|1', '161|5148381127|حسين محمد رياض سعد|1|1', '162|9957967378|حمود مزيد حمود بارج|1|1',
  '163|1547246795|حيدر خزعل مذكور سيد|1|1', '164|2041385893|حيدر ضياء كاظم نكال|1|1', '165|5178561931|حيدر ماجد عبد علي حسين|1|1',
  '166|8755699495|خالد وليد هاني بندر|1|1', '167|6345881390|ديوان عبد الحق هاني نعمه|1|1', '168|2571488494|رسل عامر عبد الكريم حسن|1|1',
  '169|5484006136|رضا خالد خورشيد احمد|1|1', '170|1953899845|رضا سليم رسن علاوي|1|1', '171|1985956740|زهراء عبدالزهره ثجيل غضبان|1|1',
  '172|1150093904|زين العابدين فرقد عباس قاسم|1|1', '173|7375293527|زين العابدين محمد عبد الرضا لعيبي|1|1', '174|6411337110|زينب احمد مجيد عكلة|1|1',
  '175|6476510165|زينب جلال جبار عبد الحسين|1|1', '176|5181672841|زينب رافد عبد الصاحب عبد|1|1', '177|3392640112|زينب عزيز باشخ مشيجل|1|1',
  '178|5648380487|زينب مجيد عبود مكي|1|1', '179|1144110546|ساره رائد عباس حميد|1|1', '180|6300907129|سجاد رامي خليل شاكر|1|1',
  '181|8178131635|سجاد عبد الخالق جميل عبد القادر|1|1', '182|6164583019|سجاد عبد الكريم حمد حمود|1|1', '183|4587460591|سجاد علوان مري والي|1|1',
  '184|6646412567|سجاد محمد عبد الهادي مصطفى|1|1', '185|4692990006|سجاد محمود حامد محمد|1|1', '186|3292129862|سيف الدين حسن ميذاب سعيد|1|1',
  '187|3251937791|سيف الدين مهند عباس عبدالزهره|1|1', '188|6864264760|سيف رمضان صحن جبار|1|1', '189|4591103531|صادق احمد امين نعيم|1|1',
  '190|6458203797|صفاء صباح ثجيل مالح|1|1', '191|2631173540|ضياء الدين قيس دحام مصاول|1|1', '192|7075413090|طيبه عبدالرزاق يوسف عبدالرزاق|1|1',
  '193|5031238072|عباس أسعد حسين علي|1|1', '194|9759260666|عباس حازم شلال ضيدان|1|1', '195|3781458953|عباس حسين عطيه خيرالله|1|1',
  '196|8955865272|عباس عبد الامير مزيد علوان|1|1', '197|6843816850|عباس عبد الحميد عبد الرضا مهاوي|1|1', '198|4592923550|عبد الرحمن رزاق حميد ياسين|1|1',
  '199|8068206558|عبدالعزيز عادل عبدالقادر عايد|1|1', '200|7867798828|عصام علي صادق كاظم|1|1', '201|9005480924|علي حسين سامي ثامر|1|1',
  '202|7197168718|علي حسين عادل علي|1|1', '203|5775563007|علي سعد سوادي كاطع|1|1', '204|3336245764|علي شاكر منخي غضبان|1|1',
  '205|4737608372|علي طاهر زغير يري|1|1', '206|9252511839|علي طه حسين صعيبر|1|1', '207|2649319986|علي كريم غميس شناوه|1|1',
  '208|9331875694|علي محمد حسن مسلم|1|1', '209|5251839393|علي ميثم حسن جبر|1|1', '210|5288710233|علي وضاح محمد صيهود|1|1',
  '211|8588002199|علياء صافي غضبان سلطان|1|1', '212|6507493571|عيسى احمد حسين جاسم|1|1', '213|9288969673|غفران صبيح مجيد لازم|1|1',
  '214|7252305907|فاضل عباس مرحب حسين|1|1', '215|5566453488|كاظم مجلس صبيح غميس|1|1', '216|7705931620|كرار حيدر حسين حنون|1|1',
  '217|9903829153|كرار علي طعمه علوان|1|1', '218|3153395808|ليث وسام جبار نجم|1|1', '219|5104738107|ليلى محمد عنان|1|1',
  '220|5902858400|مجتبى خالد شياع مهوس|1|1', '221|5613034305|مجتبى محمد حوني كعيد|1|1', '222|7925676751|محمد باقر حسين عبدالرزاق هاشم|1|1',
  '223|3309836123|محمد باقر عقيل خضير سلمان|1|1', '224|9220731980|محمد تركي عبود حنتوش|1|1', '225|5049762220|محمد جواد علاء محمد عودة|1|1',
  '226|7829537559|محمد حسين نعيم مونس|1|1', '227|3795869829|محمد حكمت كويعد عبد الحسن|1|1', '228|7441416096|محمد رائد شايل كنش|1|1',
  '229|5422743514|محمد رجب حسين علي|1|1', '230|9907995628|محمد ستار شبوط شريده|1|1', '231|6158652766|محمد سلمان داود العميري|1|1',
  '232|7004883539|محمد عبد الرضا عبد الجبار مسلم|1|1', '233|6882745434|محمد علي قاسم خفيف|1|1', '234|3913418863|مرتضى عبد الكريم ناهي نعمة|1|1',
  '235|1611502718|مرتضى عبد الوهاب عبد الرزاق مناحي|1|1', '236|2519688292|مسره احمد شالي مطر|1|1', '237|8992947942|مسلم عقيل جاسم محمد|1|1',
  '238|8893836556|مسلم مشتاق جبار موزان|1|1', '239|8401404912|مصطفى اياد عوده عبد الجبار|1|1', '240|5065612798|مصطفى عبدالصمد جاسم عيسى|1|1',
  '241|7163427450|مصطفى محمد مجيد مزعل|1|1', '242|8569399255|مقتدى ميثاق اسليم ظاهر|1|1', '243|9970253413|ملاك نوفل عبد الامير مكنس|1|1',
  '244|3394892088|منتظر مهدي ريكان كريم|1|1', '245|3189064373|مهدي علي جعفر خميس|1|1', '246|9817660806|نرجس مهند يوسف يعقوب|1|1',
  '247|3604843412|هبة الله ساجد مهلهل لفته|1|1', '248|1969373352|ياسر علي راشد علي|1|1', '249|3060467303|ياسر معتز طه راضي|1|1',
  '250|4377271949|يوسف ريهم صباح عبدالله|1|1', '251|7475267419|آلاء مهند محمد عبد الكريم|2|0', '252|5527363625|أحمد علي زكي محمد|2|0',
  '253|2113107615|أنس عبد الحسين مولى عبد الرضا|2|0', '254|1237359029|ابا الحسن علي خضير سلمان|2|0', '255|3022531124|ابا الفضل مدحت باهض خضير|2|0',
  '256|1439062890|ابرار خالد جليل رسن|2|0', '257|4269655768|ابراهيم جاسب جرمل غانم|2|0', '258|5823826062|ابراهيم محمد عبد الوهاب حسن|2|0',
  '259|1971009816|احمد اسامه جواد كاظم|2|0', '260|3941324211|احمد حيدر مهدي يونس|2|0', '261|9001081976|احمد علي سالم عبد الله|2|0',
  '262|2215794448|احمد فائز طه عبد الله|2|0', '263|7248528420|احمد فائز كاظم فارس|2|0', '264|1339797747|احمد كمال جبار جوده|2|0',
  '265|3054870530|احمد مؤيد إبراهيم حبيب|2|0', '266|7612847267|احمد مسلم محمد مسلم|2|0', '267|6285950177|احمد وائل حسن فرحان|2|0',
  '268|8832590467|ازهر منير عبد الله جابر|2|0', '269|7230845224|اسكندر سعد فزاع عبد علي|2|0', '270|2935121040|اسماعيل اكرم ميه رودين|2|0',
  '271|6914999608|اكرم لطيف حميد لطيف|2|0', '272|5110986954|الأمير علي علي عبد الكاظم علي|2|0', '273|3734519809|البتول محمود حسين راضي|2|0',
  '274|1763340088|الحسين عادل عبد الحسن كاظم|2|0', '275|6318989337|الرباب رائد قاسم محمد|2|0', '276|9523698230|القاسم مهند عبد الواحد قاسم|2|0',
  '277|4064620799|ام البنين علي جمعه بنو|2|0', '278|2167761532|ايات قيس ايوب حسين|2|0', '279|5852651586|ايه جواد عبد الكاظم مطر|2|0',
  '280|3803039515|بتول علاء خلف عبد الواحد|2|0', '281|1633845872|بدر عبد الرحمن عبد الله|2|0', '282|7387738850|بدر عبد الله بدر عبد الله|2|0',
  '283|8859024375|بهاء بهجت عبد العالي جويد|2|0', '284|1874059159|جعفر معتصم عبد الرزاق عبد الصاحب|2|0', '285|6970472459|جعفر ميثم جواد علي|2|0',
  '286|6392795433|حسن شهيد عناد حسين|2|0', '287|5203751760|حسن عبد الامير خضير سلمان|2|0', '288|8451961038|حسن عبد العباس ابراهيم عبد الكريم|2|0',
  '289|5433237493|حسن علاء عبد الحسين ثامر|2|0', '290|8183786355|حسن علاء كاظم عبد علي|2|0', '291|3889017546|حسن محمد عبد الحسين دخيل|2|0',
  '292|4507126469|حسن محمد هاني محمد|2|0', '293|1123577464|حسن هادي مالك ضيدان|2|0', '294|1372459785|حسين تيسير علي حسين|2|0',
  '295|1089324296|حسين جعفر صادق جاسم|2|0', '296|6777664655|حسين حافظ عبدالرضا جابر|2|0', '297|8195968875|حسين خالد حميد حسن|2|0',
  '298|7555290024|حسين خالد منصور جازع|2|0', '299|3788233477|حسين زياد كاظم صابر|2|0', '300|1945481522|حسين سلمان عبد الرزاق عمر|2|0',
  '301|3654380609|حسين عبد الرزاق دهراب عدوان|2|0', '302|7977768494|حسين عبد الستار جباري سلمان|2|0', '303|6552857460|حسين علاء كاظم عبود|2|0',
  '304|6475652440|حسين علي حمزه عبد|2|0', '305|2518264367|حسين علي غليم عويد|2|0', '306|3790476580|حسين عماد خلف جبار|2|0',
  '307|5597370075|حسين عماد مجيد خزعل|2|0', '308|9523316593|حسين عيدان رزاق ساجت|2|0', '309|1715702259|حسين قصي جبار عبيد|2|0',
  '310|5593836490|حسين كاظم عبد الامير حسن|2|0', '311|3815529967|حسين مازن مظلوم محمد|2|0', '312|6990919457|حسين محمد فيصل كشكول|2|0',
  '313|2188906697|حسين وعد حامد صالح|2|0', '314|8339925283|حيدر اسعد هاشم خنياب|2|0', '315|5779763068|حيدر ستار جبار كريم|2|0',
  '316|7410473490|حيدر سعيد فالح حسن|2|0', '317|8609886538|حيدر مسلم حنظل عبد الكريم|2|0', '318|5177951713|دانه خالد قنديل عبيد|2|0',
  '319|6871562944|درر مظفر نعيمه طه|2|0', '320|1142488156|رزان مصعب طه محمود|2|0', '321|1139021674|رضا احمد عبد الزهرة جعفر|2|0',
  '322|5159769719|رضا محسن علي عبد النبي|2|0', '323|3430765153|روان رياض عبد الرسول راضي|2|0', '324|2342118380|ريام احمد رياض رحيم|2|0',
  '325|3973165485|زهراء احمد جخيور محيل|2|0', '326|9414456300|زهراء احمد قاسم كريم|2|0', '327|7974629894|زهراء حسن كاظم حسن|2|0',
  '328|1280809583|زهراء ماجد علي حسين|2|0', '329|5617724283|زين العابدين انور مهجر صبري|2|0', '330|9442277800|زين العابدين فرات اسماعيل جاسم|2|0',
  '331|2657095758|زينب باسل عبد الهادي علي|2|0', '332|5073784150|زينب خليل ابراهيم سلمان|2|0', '333|4135497468|زينب سجاد خير الله عبد|2|0',
  '334|2941884851|زينة عبد الرحمن يوسف علي|2|0', '335|8214782500|زينه هاني مكطوف ناصر|2|0', '336|1506831940|سجاد رفعت عبد الحسين شوكت|2|0',
  '337|6193572479|سجاد عبد الرحيم شاكر عدنان|2|0', '338|1040182306|سجاد فارس عبد اللطيف احمد|2|0', '339|5265245522|شهد حيدر عبد الجبار حميد|2|0',
  '340|3715853673|شهد عقيل مجيد زبيق|2|0', '341|8954562129|شهد محمد حسين علي|2|0', '342|6115400493|صفا خالد علي عباس|2|0',
  '343|4486506446|صفا ماهر اكريم حاجم|2|0', '344|6803190088|ضحى فراس عادل رشيد|2|0', '345|9590783184|ضرغام طالب هاشم لفته|2|0',
  '346|5480312544|ضياء كاطع ناصر حسين|2|0', '347|6295379368|عباس صفاء عبد الكاظم عفلوك|2|0', '348|6120911597|عباس ضياء خير الله منصور|2|0',
  '349|1159019371|عبد الحميد ماجد عبد الحميد ناصر|2|0', '350|2371205503|عبد الرحمن حيدر أحمد حسن|2|0', '351|5470082309|عبد العزيز بهاء ثامر عبد الامير|2|0',
  '352|9989109479|عبد الله جواد محمد حبيب|2|0', '353|4740080351|عبد الله سامر عبد الهادي احمد|2|0', '354|5130465498|عبد الله علي وليد محسن|2|0',
  '355|3025904796|عبد النبي ابراهيم عبد المجيد عبد النبي|2|0', '356|2488552897|عبدالله باسم محمد حسن ايوب|2|0', '357|6253518600|عبدالله عادل جاسب فنجان|2|0',
  '358|8676628168|عبدالله محمد عبدالقادر عبداللطيف|2|0', '359|5179558231|عدوان جابر عدوان دهراب|2|0', '360|5474381259|علا صدام علي عبد الزهره|2|0',
  '361|5929933117|علاء عصام خريبط فرج|2|0', '362|4087578669|علي احمد اشياع|2|0', '363|5650047576|علي احمد صالح احمد|2|0',
  '364|7162643943|علي السجاد ميثم عبد الرضا يوسف|2|0', '365|7163803946|علي بهاء مهدي عبد الحسن|2|0', '366|1079037277|علي حازم عزيز ناصر|2|0',
  '367|5413762069|علي حسام عبد الامير تعبان|2|0', '368|7911293128|علي حسنين عبد الزهرة حسين|2|0', '369|8025904825|علي حسين عبد المنعم مرزوق|2|0',
  '370|5215654178|علي حسين علي حنش|2|0', '371|6501045190|علي حيدر حمزة عباس|2|0', '372|3427885082|علي خالد جميل ماضي|2|0',
  '373|2615706930|علي رضا اياد كاظم حسن|2|0', '374|9730664723|علي رضا مروان منصور|2|0', '375|8385205517|علي ستار جاسم عوده|2|0',
  '376|3672955566|علي صباح حسن جارح|2|0', '377|8836014833|علي ضياء جاسم محمد|2|0', '378|1891026479|علي طلال كاظم صالح|2|0',
  '379|1137331292|علي عبد الامير عباس عاشور|2|0', '380|4513664502|علي فؤاد خالد عبد الله|2|0', '381|4036462675|علي مالك نجم لازم|2|0',
  '382|4136929375|علي محمد حمري كطافه|2|0', '383|4718424533|علي محمد حياوي لازم|2|0', '384|2765258349|علي مروان عدنان نعمان|2|0',
  '385|3923454535|علي مقداد محمد علي غانم|2|0', '386|8458302670|علي ناصر نايف خلف|2|0', '387|4425264290|فاطم حسن كاظم حسن|2|0',
  '388|4707804154|فاطمة لفتة جبار جاسم|2|0', '389|2742070323|فاطمة ميعاد اياد عبد اللطيف|2|0', '390|2229210012|فاطمه الزهراء احمد سهيل نجم|2|0',
  '391|2526338693|فاطمه صفاء جاسم محمد|2|0', '392|8513774047|فاطمه غسان بسام لوتي|2|0', '393|1499874248|فواطم حازم محمد زكي مهدي|2|0',
  '394|6936332980|قاسم عقيل مسلم كاظم|2|0', '395|8820485118|كامل صارم كامل سعيد|2|0', '396|8743296882|كرار حيدر مهدي صالح|2|0',
  '397|1386214723|كرار كريم محسن مطلك|2|0', '398|6229070931|كرار مزهر ريسان كريم|2|0', '399|6582755260|لبانه عدنان حجي شبر|2|0',
  '400|5768643147|ليلى رافد ياسين خضير|2|0', '401|1031739598|مؤمل جميل صبيح غزي|2|0', '402|7333323215|مؤمل حسين علي حسين|2|0',
  '403|9244643047|مؤمل صبري راضي عاتي|2|0', '404|2537971620|مالك محمد صبيح علوان|2|0', '405|5148273781|مبين عبد الكريم سلمان داود|2|0',
  '406|5566817668|مجتبى دريد عبد الله يوسف|2|0', '407|7692741427|محمد ابراهيم نجم عبود|2|0', '408|7831159664|محمد باقر عادل شاكر خير الله|2|0',
  '409|8045843381|محمد باقر عبد الوهاب طاهر|2|0', '410|3846456019|محمد باقر مؤيد يوسف يعقوب|2|0', '411|9563044320|محمد جلال محمد صالح ابراهيم|2|0',
  '412|2404572528|محمد حسن علاء سبتي سلمان|2|0', '413|7253797711|محمد حسن مرتضى طوينه عودة|2|0', '414|3783577751|محمد خالد غنى خليف|2|0',
  '415|7460162214|محمد رضا اياد هاشم سريبت|2|0', '416|8480980390|محمد رضا حيدر محمد ضياء|2|0', '417|9046918217|محمد رياض غصاب ساهي|2|0',
  '418|5161387124|محمد صفاء مهدي صالح|2|0', '419|6938038283|محمد عبد الباري جاسم عبد الرضا|2|0', '420|8336303756|محمد عداي حطاب عداي|2|0',
  '421|3460401309|محمد عدي حمدان سالم|2|0', '422|2814414718|محمد عقيل شنان حسن|2|0', '423|4670532015|محمد علاء زويد خلف|2|0',
  '424|1392346242|محمد علاء عبد السلام جاسم|2|0', '425|1965905471|محمد علي عاشور حمود|2|0', '426|6649221651|محمد فاضل عبد المحسن عبد السيد|2|0',
  '427|7059740880|محمد قيس سعدون احمد|2|0', '428|3479552323|محمد ماجد حميد ابراهيم|2|0', '429|5269892617|محمد مسلم ناصر عبود|2|0',
  '430|6282933968|محمد نبراس توفيق عبد الرزاق|2|0', '431|3906035490|محمد نصرت قاسم ابراهيم|2|0', '432|1861453100|محمد هيثم عبد الصمد عبد الكريم|2|0',
  '433|1830604476|محمد وليد داود سلمان|2|0', '434|7079444397|مرتجى نائل عدنان حسن|2|0', '435|3385346019|مرتضى حمود عبود خضير|2|0',
  '436|8939014383|مرتضى حميد عطيه نابت|2|0', '437|4783220247|مرتضى سمير جليل خدادة|2|0', '438|6254243231|مريم باسل فاضل عباس|2|0',
  '439|2882991243|مريم رضا عبد الله رضا|2|0', '440|5867432881|مريم زاهد مزهر شناوه|2|0', '441|2759106876|مصطفى حسن لفتة اسويري|2|0',
  '442|1641910177|مصطفى حيدر عبد الصاحب كريم|2|0', '443|5763621065|مصطفى رياض هليل عوده|2|0', '444|3978130328|مصطفى لؤي رمضان معتوق|2|0',
  '445|8004190968|مفتن رائد مفتن حمود|2|0', '446|9059813857|مقتدى مازن شاطي بريس|2|0', '447|8189474695|ملاك ايفاد فرات حسين|2|0',
  '448|6958306072|مناف عبد الامير فاخر عبد الله|2|0', '449|7787220009|منتظر طاهر إبراهيم مطنش|2|0', '450|6772814001|منتظر مهدي جاسم علي|2|0',
  '451|1559271583|مهدي عباس حكمت ناجي|2|0', '452|9598042991|مهدي وسام شاكر محمود|2|0', '453|8945819088|موسى علي هادي عيسى|2|0',
  '454|4593318950|نبأ عدي كامل حنون|2|0', '455|6251828421|نور الهدى حازم مكي عبد الحسن|2|0', '456|5056131109|نوران فلاح حسن شري|2|0',
  '457|7409538733|همس فراس احمد عبد الرزاق|2|0', '458|2384596991|ياسر احمد عامر فاخر|2|0', '459|8151665074|ياسر امين جعفر جياد|2|0',
  '460|6306225236|ياسر عمار كريم مسلم|2|0', '461|4946593264|ياسين صلاح حسن علي|2|0', '462|5086950176|ياسين وجدي عزيز عبد الحسن|2|0',
  '463|8264323530|يقين عبد الخالق هاشم عبد الله|2|0', '464|9397990554|يوسف خليل حامد شنيت|2|0', '465|7341447434|امين ماجد خلف محمد علي|2|1',
  '466|7484680023|ايمن عبد الكريم عبد الصاحب حسين|2|1', '467|9486154447|بسام علي عبد الزهرة مكلف|2|1', '468|2372273805|حسن غانم داغر جبر|2|1',
  '469|9833924584|حسن نوري فاخر سعد|2|1', '470|1986457703|حسين عبد الكريم عوده زايد|2|1', '471|1683873480|حسين علي دحام عبد الرضا|2|1',
  '472|6061723038|حسين ناظم جاسم مجيد|2|1', '473|4770224582|حيدر رشيد ماجد داود|2|1', '474|4093707508|حيدر محمد جاسم شناوه|2|1',
  '475|7243225963|حيدر محمد حسن عبد الوهاب علي|2|1', '476|4914818528|حيدر هاشم محمد خضير|2|1', '477|3391441414|خلدون كاظم عبد حسين|2|1',
  '478|5397002435|رافد جميل سلمان عبد الحسن|2|1', '479|5996440298|رضا عبد الرسول حسن سلمان|2|1', '480|6869676093|روح الله نجم بادي منشد|2|1',
  '481|2529745412|ريهام عبدالكاظم كريدي عنيتك|2|1', '482|4703799761|زهراء عبد الرزاق عبد الحكيم موسى|2|1', '483|6858032994|زهراء مازن عبد الحسن يعقوب|2|1',
  '484|5678419469|زهراء ماهر شبيب حسين|2|1', '485|3188755860|زهراء واثق كريم موسى|2|1', '486|6756344317|زين العابدين جواد كاظم عبد الحسن|2|1',
  '487|9121728307|زينب عبدالكريم عبود عباس|2|1', '488|1523867181|سامر وفي جري جار الله|2|1', '489|8626612894|سجاد وسام نجم عبد الله|2|1',
  '490|2683742500|طيف علي مهدي علي|2|1', '491|8864184959|عباس حسن عبد الكريم عبد الزهرة|2|1', '492|3979847740|عباس كاظم قاسم داود|2|1',
  '493|9176733573|عباس مازن عباس ناصر|2|1', '494|6439506480|عبدالله خليل نده جابر|2|1', '495|5006299960|علي بهجت رحيم حبيب|2|1',
  '496|8948583806|علي جسر خضير عبدمحمد|2|1', '497|5657616446|علي جواد العيبي نعمة|2|1', '498|9258163402|علي حيدر حميد خلف|2|1',
  '499|7353285472|علي دحام صدام عبد النبي|2|1', '500|4325538018|علي ستار عبد علي جاسم|2|1', '501|9948327926|علي عبد الواحد محمد جاسم|2|1',
  '502|6838864693|علي فؤاد خلف فالح|2|1', '503|4685395355|علي لؤي محمد جواد عبد الكريم|2|1', '504|9942369270|علي محمد عبد الحسين عبيد|2|1',
  '505|2174941039|علي مرتضى عبد العظيم عبد النبي|2|1', '506|2351314339|علي نائل شهف حصين|2|1', '507|9185232593|علي ناظم محيسن عبد الهادي|2|1',
  '508|6471097583|علي نجاح سبع خميس|2|1', '509|3698330203|علي نوفل إسماعيل عبد الواحد|2|1', '510|7136155782|غانم قيس غانم محمد|2|1',
  '511|7545308202|غيث امجد مكي صادق|2|1', '512|6119232849|غيث سامي جمعة صجم|2|1', '513|1458641499|فاطمه فاضل عبد الساده حسن|2|1',
  '514|6416115028|كرار ماجد عبد الصاحب مفتن|2|1', '515|1759877161|ماس فراس محسن غضبان|2|1', '516|8881278757|مجتبى جهاد ريسان حسين|2|1',
  '517|5117170244|مجيد نوري مجيد يعقوب|2|1', '518|5069205957|محمد الدر صفاء خضير شغاتي|2|1', '519|3917128400|محمد حسن يعقوب حسن حسين|2|1',
  '520|6798723859|محمد عبدالدايم حسن جاسم|2|1', '521|7150343616|محمد عبيد نجي مسعد|2|1', '522|6886129308|محمد مصطفى جابر حنون|2|1',
  '523|4337259602|محمد مصطفى حسب عبد علي|2|1', '524|6518465408|محمد هيثم محمد جاسم|2|1', '525|1315631093|مصطفى حارث عبد العزيز احمد|2|1',
  '526|8209434050|مصطفى رعد ناصر صالح|2|1', '527|5464753962|مصطفى عبد الكريم ناظم عبد الله|2|1', '528|6623065829|مصطفى كاظم سعدون غليص|2|1',
  '529|8689407771|مصطفى مهدي صالح مهدي|2|1', '530|4518229960|مقتدى علي خضير ناصر|2|1', '531|4205293100|مقتدى ميثم محمد طالب|2|1',
  '532|3374301816|منتظر غزوان خلف سجاي|2|1', '533|9104445247|مهدي جبار ناهي جابر|2|1', '534|5278666543|مهيمن امجد محمود ظاهر|2|1',
  '535|8750203932|هدى جبار ستار حمزه|2|1', '536|5719799238|هدى صادق دينار عامر|2|1', '537|1945545408|هشام امجد عبد العزيز حميد|2|1',
  '538|2108978378|وليد نبيل ابراهيم رشيد|2|1',
];