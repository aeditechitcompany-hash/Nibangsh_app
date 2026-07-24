import 'package:flutter/material.dart';

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

class QuizSet {
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final List<QuizQuestion> questions;

  const QuizSet({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.questions,
  });

  int get totalQuestions => questions.length;
}

class QuizCatalog {
  QuizCatalog._();

  static const List<QuizSet> sets = [
    QuizSet(
      id: 'set1',
      title: 'Set 1',
      icon: Icons.quiz_outlined,
      color: Color(0xFFDC2626),
      questions: [
        QuizQuestion(
          question: 'Who is making the Web standards?',
          options: ['The World Wide Web Consortium', 'Microsoft', 'Mozilla', 'Google'],
          correctIndex: 0,
        ),
        QuizQuestion(
          question: 'What does HTML stand for?',
          options: [
            'Hyper Trainer Marking Language',
            'Hyper Text Markup Language',
            'Hyper Text Marketing Language',
            'Hyper Text Mark Language',
          ],
          correctIndex: 1,
        ),
        QuizQuestion(
          question: 'Which tag is used to define a paragraph in HTML?',
          options: ['<para>', '<p>', '<paragraph>', '<pr>'],
          correctIndex: 1,
        ),
        QuizQuestion(
          question: 'What is the correct HTML element for the largest heading?',
          options: ['<h6>', '<heading>', '<h1>', '<head>'],
          correctIndex: 2,
        ),
        QuizQuestion(
          question: 'Which attribute is used to provide an alternate text for an image?',
          options: ['title', 'alt', 'src', 'longdesc'],
          correctIndex: 1,
        ),
      ],
    ),
    QuizSet(
      id: 'set2',
      title: 'Set 2',
      icon: Icons.quiz_outlined,
      color: Color(0xFF2563EB),
      questions: [
        QuizQuestion(
          question: 'Which company developed JavaScript?',
          options: ['Microsoft', 'Netscape', 'Sun Microsystems', 'Apple'],
          correctIndex: 1,
        ),
        QuizQuestion(
          question: 'Which keyword declares a block-scoped variable in JS?',
          options: ['var', 'let', 'function', 'const only'],
          correctIndex: 1,
        ),
        QuizQuestion(
          question: 'What does DOM stand for?',
          options: [
            'Document Object Model',
            'Data Object Model',
            'Document Oriented Model',
            'Digital Object Model',
          ],
          correctIndex: 0,
        ),
        QuizQuestion(
          question: 'Which method converts JSON text into an object?',
          options: ['JSON.stringify()', 'JSON.parse()', 'JSON.object()', 'JSON.convert()'],
          correctIndex: 1,
        ),
        QuizQuestion(
          question: 'Which operator checks both value and type equality?',
          options: ['==', '=', '===', '!=='],
          correctIndex: 2,
        ),
      ],
    ),
    QuizSet(
      id: 'set3',
      title: 'Set 3',
      icon: Icons.quiz_outlined,
      color: Color(0xFF16A34A),
      questions: [
        QuizQuestion(
          question: 'What is React primarily used for?',
          options: ['Styling pages', 'Building user interfaces', 'Database management', 'Server hosting'],
          correctIndex: 1,
        ),
        QuizQuestion(
          question: 'What is JSX?',
          options: [
            'A CSS preprocessor',
            'A JavaScript syntax extension',
            'A database query language',
            'A testing framework',
          ],
          correctIndex: 1,
        ),
        QuizQuestion(
          question: 'Which hook is used to manage state in a function component?',
          options: ['useEffect', 'useState', 'useRef', 'useMemo'],
          correctIndex: 1,
        ),
        QuizQuestion(
          question: 'What is used to pass data to a component from outside?',
          options: ['setState', 'props', 'render', 'this.state'],
          correctIndex: 1,
        ),
        QuizQuestion(
          question: 'Which company maintains React?',
          options: ['Google', 'Meta', 'Amazon', 'Microsoft'],
          correctIndex: 1,
        ),
      ],
    ),
    QuizSet(
      id: 'set4',
      title: 'Set 4',
      icon: Icons.quiz_outlined,
      color: Color(0xFFF59E0B),
      questions: [
        QuizQuestion(
          question: 'Who created the C++ language?',
          options: ['Dennis Ritchie', 'Bjarne Stroustrup', 'James Gosling', 'Guido van Rossum'],
          correctIndex: 1,
        ),
        QuizQuestion(
          question: 'Which keyword is used to define a class in C++?',
          options: ['struct', 'object', 'class', 'define'],
          correctIndex: 2,
        ),
        QuizQuestion(
          question: 'What is the default access specifier in a C++ class?',
          options: ['public', 'protected', 'private', 'internal'],
          correctIndex: 2,
        ),
        QuizQuestion(
          question: 'Which operator is used for dynamic memory allocation?',
          options: ['malloc', 'new', 'alloc', 'create'],
          correctIndex: 1,
        ),
        QuizQuestion(
          question: 'What does STL stand for?',
          options: ['Standard Template Library', 'System Type Library', 'Static Type List', 'Standard Type Language'],
          correctIndex: 0,
        ),
      ],
    ),
    QuizSet(
      id: 'set5',
      title: 'Set 5',
      icon: Icons.quiz_outlined,
      color: Color(0xFF9333EA),
      questions: [
        QuizQuestion(
          question: 'Who created Python?',
          options: ['Guido van Rossum', 'James Gosling', 'Linus Torvalds', 'Dennis Ritchie'],
          correctIndex: 0,
        ),
        QuizQuestion(
          question: 'Which of these is used to define a function in Python?',
          options: ['func', 'def', 'function', 'lambda only'],
          correctIndex: 1,
        ),
        QuizQuestion(
          question: 'What is the output type of the input() function by default?',
          options: ['int', 'str', 'float', 'bool'],
          correctIndex: 1,
        ),
        QuizQuestion(
          question: 'Which data type is immutable in Python?',
          options: ['list', 'dict', 'tuple', 'set'],
          correctIndex: 2,
        ),
        QuizQuestion(
          question: 'Which symbol is used for comments in Python?',
          options: ['//', '#', '<!--', '/*'],
          correctIndex: 1,
        ),
      ],
    ),
  ];
}