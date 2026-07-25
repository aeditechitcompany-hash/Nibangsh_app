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
          question: '이 표지는 무슨 뜻입니까? ',
          options: [
            '가져가면 안 됩니다.',
            '가까이 가면 안 됩니다.',
            '만지면 안 됩니다.',
            '사용하면 안 됩니다.',
          ],
          correctIndex: 0,
        ),
        QuizQuestion(
          question: '다음을 읽고 맞지 않는 것을 고르십시오.',
          options: [
            '전시회는 5 일 동안 합니다.',
            '전시회는 국제전시장에서 열립니다.',
            '주말 관람 시간은 편일과 같습니다.',
            '어린이는 어른보다 싸게 입장할 수 있습니다.',
          ],
          correctIndex: 1,
        ),
        QuizQuestion(
          question: '다음을 읽고 맞는 것을 고르십시오.',
          options: [
            '관심 있는 사람은 누구나 참가할 수 있다.',
            '이 대회에서 1등을 하면 여행 상품권을 받는다.',
            '3 월 15일  오후 7 시까지 신청해야 한다.',
            '이 대회는 전국 대회이다.',
          ],
          correctIndex: 1,
        ),
        QuizQuestion(
          question: '다음은 한류 열풍과 수출에 대한 그래프 입니다 .잘 읽고 맞지 않은 것을 고르십시오.',
          options: [
            '한국의 화장품은 현재 미국에서도 인기가 많아지고 있다.',
            'K-pop 과 드라마의 검색량은 따로 알 수 있다.',
            '2004 년보다 2013년에 검색량은 높다.',
            '2007 년에 미국으로 수출한 화장품의 수는 2004년보다 적다.',
          ],
          correctIndex: 2,
        ),
        QuizQuestion(
          question: '우리 공장에서는 3 번 이상 무단결근을 하면 월급이_________ .',
          options: ['강봉됩니다', '징계됩니다', '경고됩니다', '해고 됩니다'],
          correctIndex: 3,
        ),
        QuizQuestion(
          question:
              '절은 한국의 전통적인 ________ 입니다.요즘은 과거에 비해 절을 하는 경우가 줄어들었지만 결혼식 때나 명절 때에는  꼭 절을 합니다.',
          options: ['풍습', '예절', '호칭', '인사법'],
          correctIndex: 3,
        ),
        QuizQuestion(
          question:
              '우리는 여행을 가면 그곳에서 유명한 유적지를 찾아갑니다. 유적지는 옛날  사람들이 남긴 건축물이나 역사적 사건이 일어났던 장소입니다. 유적지에 가면 어떻게 발전해 왔는지 돌아볼 수 있습니다.',
          options: [
            '유적지를 방문하는 이유',
            '유적지를 관리하는 기관',
            '유적지를 보호하는 목적',
            '유적지를 조사하는 방법',
          ],
          correctIndex: 2,
        ),
        QuizQuestion(
          question:
              '저는 한 달에 두 번 한국외국인력지원센터에서 네팔어 통역을 하고 있습니다. 돈을 받지는 않지만 다른 사람을 도와줄 수 있어서 참 기쁩니다. 고향 사람들을 만날 수 있는 것도 좋습니다. ‘ 받는 즐거움보다 주는 즐거움이 더 크다 ’는 말의 뜻을 알 것 같습니다.',
          options: ['문화 체험', '자원 봉사', '안전 교육', '법률 상담'],
          correctIndex: 2,
        ),
        QuizQuestion(
          question:
              '농축산업, 어업, 건설업은 근로계약 등에 차이가 있습니다. 눙축산업과 어업은 근로시간과 휴식 시간이 일정하지 않습니다. 그레서 연장, 야간 및 휴일 근로에 따른 가산금이 없고 근로계약서에 전체  근무 시간만 기재합니다. 직물 재배업은 농학기에 다른 사업장에서 일하도록 허용하고 있습니다. 건설업은 같은 공사 형장 내에서 사업주가 다른 업체로 이동하거나 사업주가 같은 상태에서 다른 공사 현장으로 이동해서 일할 수 있습니다 .',
          options: [
            '건설업은 사업주가 같은 다른 공사 현장에서 일할 수 있다.',
            '직물 재배업은 언제든지 다른 사업장에서 일할 수 있다.',
            '농축산업과 어업은 근로 시간에 자주 쉰다.',
            '농축산업과 어업은 휴일에 일을 하면 수당을 받는다.',
          ],
          correctIndex: 2,
        ),
        QuizQuestion(
          question:
              '1990 년대부터 중국과 동남아를 중심으로 인기를 얻기 시작한 한국의 대중문화를 한류라고 합니다. 취근에는 아이돌을 중심으로 한 K-pop이 아시아는 물론 유럽과 미국에서까지 큰 인기를 얻고 있고 배우들과 가수들이 외국에 나가서 활동하는 경우도 늘고 있습니다 . 한류로 인해 한국의 음식이나 한국어에 대한 관심도 같이 높아져서 관광 수입도 크게 늘어나고 있습니다.',
          options: [
            '한국 음식에 대한 관심이 많아졌다.',
            '한국 여행 오는 사람은 많지 않다.',
            '한국어를 배우는 사람이 없다.',
            '음악보다 드라마가 인기가 있다.',
          ],
          correctIndex: 2,
        ),
        QuizQuestion(
          question: '위험이 생기거나 사고가 나지 않도록 행동이나 절차에 지켜야 할 사항을 정한 규칙 입니다.',
          options: ['안전 과장', '안전 수칙', '안전 복장', '안전 교육'],
          correctIndex: 3,
        ),
        QuizQuestion(
          question:
              '출산 저의 건강이나 출산 후의 발육을 안전하게 보장하기 위해 산모나 입산부에게 제공되는 휴직기간을 말한다.',
          options: ['출산 휴가', '약정 휴가', '연차 휴가', '법정 휴가'],
          correctIndex: 3,
        ),
        QuizQuestion(
          question: 'Pencil image',
          options: [
            '연필이 한 개 있습니다.',
            '연필이 한 개 자루 있습니다.',
            '연필이 한 개 그루 있습니다.',
            '연필이 한 개 장 있습니다.',
          ],
          correctIndex: 2,
        ),
        QuizQuestion(
          question: 'Door image',
          options: ['옷장입니다', '서랍입니다.', '냉장고입니다.', '문짝입니다.'],
          correctIndex: 2,
        ),
        QuizQuestion(
          question: '다음 단어와 과계 있은 것은 무엇입니까? \n 인사, 조각, 피, 문단, 정',
          options: ['느르다', '나오다', '놀다', '나누다'],
          correctIndex: 2,
        ),
        QuizQuestion(
          question: '다음 단어의 비슷한 말은 무엇입니까? \n 정지하다',
          options: ['사다', '멈추다', '사용하다', '새우다'],
          correctIndex: 2,
        ),
        QuizQuestion(
          question: '가: 승진을 축하합니다 ! 입사하신지 3년도 안됬는데_____ 과장이 되신 거지요?\n나: 네,갑사합니다. 다 여러분들이 도와준 덕분이에요. 오늘은 제가 한턱낼게요.',
          options: ['처음', '먼저', '미리', '벌써'],
          correctIndex: 2,
        ),
        QuizQuestion(
          question: '간만에  집 안  대청소를  했더니______.',
          options: ['더럽습니다', '편안합니다', '안전합니다', '상쾌합니다'],
          correctIndex: 2,
        ),
        QuizQuestion(
          question: '한국은 사 계절이 있습니다. 그 중에서 날씨가 추워서 겨울을 _________ 싫어합니다. 그런데 날씨가 따뜻해서 봄은 좋아해요.',
          options: ['점점', '조금', '거의', '제일'],
          correctIndex: 2,
        ),
        QuizQuestion(
          question: '약을 계속 먹었는데도________다리 건강 검진을 받아야 할 것 같아요.',
          options: ['적지를 않아서', '낮지를 않아서', '낫지를 않아서', '맞지를 않아서'],
          correctIndex: 2,
        ),
        // Yeta bata start 21-40 (and remove this comment)
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
          options: [
            'JSON.stringify()',
            'JSON.parse()',
            'JSON.object()',
            'JSON.convert()',
          ],
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
          options: [
            'Styling pages',
            'Building user interfaces',
            'Database management',
            'Server hosting',
          ],
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
          question:
              'Which hook is used to manage state in a function component?',
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
          options: [
            'Dennis Ritchie',
            'Bjarne Stroustrup',
            'James Gosling',
            'Guido van Rossum',
          ],
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
          options: [
            'Standard Template Library',
            'System Type Library',
            'Static Type List',
            'Standard Type Language',
          ],
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
          options: [
            'Guido van Rossum',
            'James Gosling',
            'Linus Torvalds',
            'Dennis Ritchie',
          ],
          correctIndex: 0,
        ),
        QuizQuestion(
          question: 'Which of these is used to define a function in Python?',
          options: ['func', 'def', 'function', 'lambda only'],
          correctIndex: 1,
        ),
        QuizQuestion(
          question:
              'What is the output type of the input() function by default?',
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
