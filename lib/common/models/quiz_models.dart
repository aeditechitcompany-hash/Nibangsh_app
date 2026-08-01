import 'package:flutter/material.dart';

class QuizQuestion {
  final String? question;
  final List<String> options;
  final int correctIndex;

  final String? imageAsset;
  final List<String>? optionImages;
  final String? audioAsset;
  final List<String>? optionAudios;

  QuizQuestion({
    this.question,
    this.options = const [],
    required this.correctIndex,
    this.imageAsset,
    this.optionImages,
    this.audioAsset,
    this.optionAudios,
  }) : assert(
  (question != null && question != '') ||
      (imageAsset != null && imageAsset != '') ||
      (audioAsset != null && audioAsset != ''),
  'A QuizQuestion needs at least one of: question text, imageAsset, '
      'or audioAsset — it cannot be entirely empty.',
  ),
        assert(
        options.length > 0 ||
            (optionImages != null && optionImages.length > 0) ||
            (optionAudios != null && optionAudios.length > 0),
        'A QuizQuestion needs at least one choice, via options, '
            'optionImages, and/or optionAudios.',
        ),
        assert(
        optionImages == null ||
            options.length == 0 ||
            options.length == optionImages.length,
        'options and optionImages must be the same length when both are '
            'provided — leave options empty for fully image-only choices.',
        ),
        assert(
        optionAudios == null ||
            options.length == 0 ||
            options.length == optionAudios.length,
        'options and optionAudios must be the same length when both are '
            'provided — leave options empty for fully audio-only choices.',
        ),
        assert(
        optionImages == null ||
            optionAudios == null ||
            optionImages.length == optionAudios.length,
        'optionImages and optionAudios must be the same length when both '
            'are provided.',
        );

  // Matches numbering that quiz authors embed inside the option text itself,
  // e.g. "① ", "(1) ", "1) ", "1. ", "1: ", "1- " — so it can be stripped
  // and rendered as a separate widget instead of as part of the string.
  static final RegExp _leadingMarker = RegExp(
    r'^\s*(?:[①-⑳]|\(\d{1,2}\)|\d{1,2}[.):\-])\s*',
  );

  bool get hasQuestionText => question != null && question!.trim().isNotEmpty;
  bool get hasImage => imageAsset != null && imageAsset!.trim().isNotEmpty;
  bool get hasOptionImages => optionImages != null && optionImages!.isNotEmpty;
  bool get hasAudio => audioAsset != null && audioAsset!.trim().isNotEmpty;
  bool get hasOptionAudios => optionAudios != null && optionAudios!.isNotEmpty;

  int get optionCount => options.isNotEmpty
      ? options.length
      : (optionImages?.length ?? optionAudios?.length ?? 0);

  bool hasOptionTextAt(int index) =>
      index >= 0 && index < options.length && options[index].trim().isNotEmpty;

  bool hasOptionImageAt(int index) =>
      hasOptionImages &&
          index >= 0 &&
          index < optionImages!.length &&
          optionImages![index].trim().isNotEmpty;

  bool hasOptionAudioAt(int index) =>
      hasOptionAudios &&
          index >= 0 &&
          index < optionAudios!.length &&
          optionAudios![index].trim().isNotEmpty;

  /// The option label with any author-embedded numbering (①, 1., (1), etc.)
  /// stripped out, since the UI now renders the option number separately.
  String displayOptionText(int index) {
    if (index < 0 || index >= options.length) return '';
    return options[index].replaceFirst(_leadingMarker, '').trim();
  }

  /// Whether this option has real text left over once embedded numbering is
  /// stripped — false for placeholder entries like "① " used purely to keep
  /// image/audio option lists the same length as `options`.
  bool hasMeaningfulTextAt(int index) => displayOptionText(index).isNotEmpty;
}

class QuizSet {
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final List<QuizQuestion> questions;

  QuizSet({
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

  static final List<QuizSet> sets = [
    QuizSet(
      id: 'set1',
      title: 'Set 1',
      icon: Icons.quiz_outlined,
      color: Color(0xFFDC2626),
      questions: [
        QuizQuestion(
          question: '이 표지는 무슨 뜻입니까? ',
          options: [
            '① 가져가면 안 됩니다.',
            '② 가까이 가면 안 됩니다.',
            '③ 만지면 안 됩니다.',
            '④ 사용하면 안 됩니다.',
          ],
          correctIndex: 0,
          imageAsset: 'assets/quiz/set1/q1_glove.png',
        ),
        QuizQuestion(
          question: '다음을 읽고 맞지 않는 것을 고르십시오.',
          options: [
            '① 전시회는 5 일 동안 합니다.',
            '② 전시회는 국제전시장에서 열립니다.',
            '③ 주말 관람 시간은 편일과 같습니다.',
            '④ 어린이는 어른보다 싸게 입장할 수 있습니다.',
          ],
          correctIndex: 1,
          imageAsset: 'assets/quiz/set1/q2_poster.png',
        ),
        QuizQuestion(
          question: '다음을 읽고 맞는 것을 고르십시오.',
          options: [
            '① 관심 있는 사람은 누구나 참가할 수 있다.',
            '② 이 대회에서 1등을 하면 여행 상품권을 받는다.',
            '③ 3 월 15일  오후 7 시까지 신청해야 한다.',
            '④ 이 대회는 전국 대회이다.',
          ],
          correctIndex: 1,
          imageAsset: 'assets/quiz/set1/q3_poster.png',
        ),
        QuizQuestion(
          question: '다음은 한류 열풍과 수출에 대한 그래프 입니다 .잘 읽고 맞지 않은 것을 고르십시오.',
          options: [
            '① 한국의 화장품은 현재 미국에서도 인기가 많아지고 있다.',
            '② K-pop 과 드라마의 검색량은 따로 알 수 있다.',
            '③ 2004 년보다 2013년에 검색량은 높다.',
            '④ 2007 년에 미국으로 수출한 화장품의 수는 2004년보다 적다.',
          ],
          correctIndex: 2,
          imageAsset: 'assets/quiz/set1/q4_graph.png',
        ),
        QuizQuestion(
          question: '우리 공장에서는 3 번 이상 무단결근을 하면 월급이_________ .',
          options: ['① 강봉됩니다', '② 징계됩니다', '③ 경고됩니다', '④ 해고 됩니다'],
          correctIndex: 3,
        ),
        QuizQuestion(
          question:
          '절은 한국의 전통적인 ________ 입니다.요즘은 과거에 비해 절을 하는 경우가 줄어들었지만 결혼식 때나 명절 때에는  꼭 절을 합니다.',
          options: ['① 풍습', '② 예절', '③ 호칭', '④ 인사법'],
          correctIndex: 3,
        ),
        QuizQuestion(
          question:
          '우리는 여행을 가면 그곳에서 유명한 유적지를 찾아갑니다. 유적지는 옛날  사람들이 남긴 건축물이나 역사적 사건이 일어났던 장소입니다. 유적지에 가면 어떻게 발전해 왔는지 돌아볼 수 있습니다.',
          options: [
            '① 유적지를 방문하는 이유',
            '② 유적지를 관리하는 기관',
            '③ 유적지를 보호하는 목적',
            '④ 유적지를 조사하는 방법',
          ],
          correctIndex: 2,
        ),
        QuizQuestion(
          question:
          '저는 한 달에 두 번 한국외국인력지원센터에서 네팔어 통역을 하고 있습니다. 돈을 받지는 않지만 다른 사람을 도와줄 수 있어서 참 기쁩니다. 고향 사람들을 만날 수 있는 것도 좋습니다. ‘ 받는 즐거움보다 주는 즐거움이 더 크다 ’는 말의 뜻을 알 것 같습니다.',
          options: ['① 문화 체험', '② 자원 봉사', '③ 안전 교육', '④ 법률 상담'],
          correctIndex: 2,
        ),
        QuizQuestion(
          question:
          '농축산업, 어업, 건설업은 근로계약 등에 차이가 있습니다. 눙축산업과 어업은 근로시간과 휴식 시간이 일정하지 않습니다. 그레서 연장, 야간 및 휴일 근로에 따른 가산금이 없고 근로계약서에 전체  근무 시간만 기재합니다. 직물 재배업은 농학기에 다른 사업장에서 일하도록 허용하고 있습니다. 건설업은 같은 공사 형장 내에서 사업주가 다른 업체로 이동하거나 사업주가 같은 상태에서 다른 공사 현장으로 이동해서 일할 수 있습니다 .',
          options: [
            '① 건설업은 사업주가 같은 다른 공사 현장에서 일할 수 있다.',
            '② 직물 재배업은 언제든지 다른 사업장에서 일할 수 있다.',
            '③ 농축산업과 어업은 근로 시간에 자주 쉰다.',
            '④ 농축산업과 어업은 휴일에 일을 하면 수당을 받는다.',
          ],
          correctIndex: 2,
        ),
        QuizQuestion(
          question:
          '1990 년대부터 중국과 동남아를 중심으로 인기를 얻기 시작한 한국의 대중문화를 한류라고 합니다. 취근에는 아이돌을 중심으로 한 K-pop이 아시아는 물론 유럽과 미국에서까지 큰 인기를 얻고 있고 배우들과 가수들이 외국에 나가서 활동하는 경우도 늘고 있습니다 . 한류로 인해 한국의 음식이나 한국어에 대한 관심도 같이 높아져서 관광 수입도 크게 늘어나고 있습니다.',
          options: [
            '① 한국 음식에 대한 관심이 많아졌다.',
            '② 한국 여행 오는 사람은 많지 않다.',
            '③ 한국어를 배우는 사람이 없다.',
            '④ 음악보다 드라마가 인기가 있다.',
          ],
          correctIndex: 2,
        ),
        QuizQuestion(
          question: '위험이 생기거나 사고가 나지 않도록 행동이나 절차에 지켜야 할 사항을 정한 규칙 입니다.',
          options: ['① 안전 과장', '② 안전 수칙', '③ 안전 복장', '④ 안전 교육'],
          correctIndex: 3,
        ),
        QuizQuestion(
          question:
          '출산 저의 건강이나 출산 후의 발육을 안전하게 보장하기 위해 산모나 입산부에게 제공되는 휴직기간을 말한다.',
          options: ['① 출산 휴가', '② 약정 휴가', '③ 연차 휴가', '④ 법정 휴가'],
          correctIndex: 3,
        ),
        QuizQuestion(
          options: [
            '① 연필이 한 개 있습니다.',
            '② 연필이 한 개 자루 있습니다.',
            '③ 연필이 한 개 그루 있습니다.',
            '④ 연필이 한 개 장 있습니다.',
          ],
          correctIndex: 2,
          imageAsset: 'assets/quiz/set1/q13_pencil.png',
        ),
        QuizQuestion(
          options: ['① 옷장입니다', '② 서랍입니다.', '③ 냉장고입니다.', '④ 문짝입니다.'],
          correctIndex: 2,
          imageAsset: 'assets/quiz/set1/q14_door.png',
        ),
        QuizQuestion(
          question: '다음 단어와 과계 있은 것은 무엇입니까? \n 인사, 조각, 피, 문단, 정',
          options: ['① 느르다', '② 나오다', '③ 놀다', '④ 나누다'],
          correctIndex: 2,
        ),
        QuizQuestion(
          question: '다음 단어의 비슷한 말은 무엇입니까? \n 정지하다',
          options: ['① 사다', '② 멈추다', '③ 사용하다', '④ 새우다'],
          correctIndex: 2,
        ),
        QuizQuestion(
          question:
          '가: 승진을 축하합니다 ! 입사하신지 3년도 안됬는데_____ 과장이 되신 거지요?\n나: 네,갑사합니다. 다 여러분들이 도와준 덕분이에요. 오늘은 제가 한턱낼게요.',
          options: ['① 처음', '② 먼저', '③ 미리', '④ 벌써'],
          correctIndex: 2,
        ),
        QuizQuestion(
          question: '간만에  집 안  대청소를  했더니______.',
          options: ['① 더럽습니다', '② 편안합니다', '③ 안전합니다', '④ 상쾌합니다'],
          correctIndex: 2,
        ),
        QuizQuestion(
          question:
          '한국은 사 계절이 있습니다. 그 중에서 날씨가 추워서 겨울을 _________ 싫어합니다. 그런데 날씨가 따뜻해서 봄은 좋아해요.',
          options: ['① 점점', '② 조금', '③ 거의', '④ 제일'],
          correctIndex: 2,
        ),
        QuizQuestion(
          question: '약을 계속 먹었는데도________다리 건강 검진을 받아야 할 것 같아요.',
          options: ['① 적지를 않아서', '② 낮지를 않아서', '③ 낫지를 않아서', '④ 맞지를 않아서'],
          correctIndex: 2,
        ),
        QuizQuestion(
          question: '잘 듣고 알맞은 것을 고르십시오.',
          options: ['① 모래', '② 부래', '③ 미래', '④ 비례'],
          correctIndex: 0,
          audioAsset: null,
        ),
        QuizQuestion(
          question: '잘 듣고 알맞은 것을 고르십시오.',
          options: ['① 약속', '② 악수', '③ 익숙', '④ 시속'],
          correctIndex: 0,
          audioAsset: null,
        ),
        QuizQuestion(
          question: '잘 듣고 알맞은 것을 고르십시오.',
          options: ['① ', '② ', '③ ', '④ '],
          optionImages: [
            'assets/quiz/set1/q23_elephant.png',
            'assets/quiz/set1/q23_monkey.png',
            'assets/quiz/set1/q23_grasshopper.png',
            'assets/quiz/set1/q23_tiger.png',
          ],
          correctIndex: 0,
          audioAsset: null,
        ),
        QuizQuestion(
          question: '잘 듣고 알맞은 것을 고르십시오.',
          options: ['① ', '② ', '③ ', '④ '],
          optionImages: [
            'assets/quiz/set1/q24_phone1.png',
            'assets/quiz/set1/q24_phone2.png',
            'assets/quiz/set1/q24_phone3.png',
            'assets/quiz/set1/q24_phone4.png',
          ],
          correctIndex: 0,
          audioAsset: null,
        ),

        QuizQuestion(
          question: '이것은 무엇입니까?',
          options: ['① 책입니다.', '② 잡지입니다.', '③ 신문입니다.', '④ 공책입니다.'],
          correctIndex: 0,
          imageAsset: 'assets/quiz/set1/q25_book.png',
          audioAsset: null, // TODO: add assets/quiz/set1/q25.mp3
        ),
        QuizQuestion(
          question: '이 사람은 무엇을 하고 있습니까?',
          options: [
            '① 짐을 옮기고 있습니다.',
            '② 청소를 하고 있습니다.',
            '③ 수리를 하고 있습니다.',
            '④ 쉬고 있습니다.',
          ],
          correctIndex: 0,
          imageAsset: 'assets/quiz/set1/q26_scene.png',
          audioAsset: null, // TODO: add assets/quiz/set1/q26.mp3
        ),
        QuizQuestion(
          question: '얼마나 있습니까?',
          options: ['① 다섯 포대입니다.', '② 여섯 포대입니다.', '③ 일곱 포대입니다.', '④ 여덟 포대입니다.'],
          correctIndex: 3,
          imageAsset: 'assets/quiz/set1/q27_cement.png',
          audioAsset: null, // TODO: add assets/quiz/set1/q27.mp3
        ),
        QuizQuestion(
          question: '통장에 잔액은 얼마 입니까?',
          options: [
            '① 53,000원입니다.',
            '② 35,000원입니다.',
            '③ 5,300원입니다.',
            '④ 530,000원입니다.',
          ],
          correctIndex: 0,
          imageAsset: 'assets/quiz/set1/q28_bankbook.png',
          audioAsset: null, // TODO: add assets/quiz/set1/q28.mp3
        ),
        QuizQuestion(
          question: '호텔은 어디에 있습니까?',
          options: ['① ', '② ', '③ ', '④ '],
          correctIndex: 1,
          imageAsset: 'assets/quiz/set1/q29_map.png',
          audioAsset: null, // TODO: add assets/quiz/set1/q29.mp3
        ),

        QuizQuestion(
          question: '다음을 듣고 이어지는 말로 알맞은 것을 고르십시오.',
          options: [
            '① 삼성화재에 가 보세요.',
            '② 보험은 4 가지가 있습니다.',
            '③ 건강보험공단에서 보험을 가입하세요.',
            '④ 귀국비용보험을 가입하러 신청하세요.',
          ],
          correctIndex: 0,
          audioAsset: null, // TODO: add assets/quiz/set1/q30.mp3
        ),
        QuizQuestion(
          question: '다음을 듣고 이어지는 말로 알맞은 것을 고르십시오.',
          options: [
            '① 조금만 기다리세요. 바로 계산해 드릴게요.',
            '② 교환해 드릴게요. 먼저 영수증 좀 보여 주세요.',
            '③ 동대문 시장에 가 보세요. 예쁜 신발이 많이 있어요.',
            '④ 여기 신발하고 거스름돈 받으세요. 다음에 또 오세요.',
          ],
          correctIndex: 0,
          audioAsset: null, // TODO: add assets/quiz/set1/q31.mp3
        ),
        QuizQuestion(
          question: '다음을 듣고 이어지는 말로 알맞은 것을 고르십시오.',
          options: [
            '① 더 체류하려면 체류기간이 빨리 연장해야 해요.',
            '② 체류기간이 지나서 연장하려면 벌금을 내야 해요.',
            '③ 혹시 체류기간은 대리인이도 연장할 수 있어요.',
            '④ 오늘은 만료일이라서 연장하러 갈 거예요.',
          ],
          correctIndex: 0,
          audioAsset: null, // TODO: add assets/quiz/set1/q32.mp3
        ),
        QuizQuestion(
          question: '다음을 듣고 이어지는 말로 알맞은 것을 고르십시오.',
          options: [
            '① 여기가 시험장 이어서 복잡할 것 같아요.',
            '② 이번엔 한국어능력 시험을 보러 왔어요.',
            '③ 한국에서 취업하려면 먼저 시험을 보세요.',
            '④ 시험장에는 큰 소리로 떠들면 안돼요.',
          ],
          correctIndex: 0,
          audioAsset: null, // TODO: add assets/quiz/set1/q33.mp3
        ),
        QuizQuestion(
          question: '질문을 듣고 이어지는 말을 고르십시오.',
          options: [
            '① 어제는 정말 즐거웠어요.',
            '② 길이 막혀서 좀 늦었어요.',
            '③ 갑자기 급한 일이 생겨서요.',
            '④ 초대해 줘서 정말 고마워요.',
          ],
          correctIndex: 0,
          audioAsset: null, // TODO: add assets/quiz/set1/q34.mp3
        ),
        QuizQuestion(
          question: '질문을 듣고 이어지는 말을 고르십시오.',
          options: [
            '① 어쩔 수 없지요.',
            '② 필요한 게 없는데요.',
            '③ 마음만으로도 고맙습니다.',
            '④ 도움이 필요하시면 연락하세요.',
          ],
          correctIndex: 0,
          audioAsset: null, // TODO: add assets/quiz/set1/q35.mp3
        ),
        QuizQuestion(
          question: '잘 듣고 들은 내용과 관계있는 그림을 고르십시오.',
          options: ['① ', '② ', '③ ', '④ '],
          optionImages: [
            'assets/quiz/set1/q36_scene1.png',
            'assets/quiz/set1/q36_scene2.png',
            'assets/quiz/set1/q36_scene3.png',
            'assets/quiz/set1/q36_scene4.png',
          ],
          correctIndex: 0,
          audioAsset: null, // TODO: add assets/quiz/set1/q36.mp3
        ),
        QuizQuestion(
          question: '잘 듣고 들은 내용과 관계있는 그림을 고르십시오.',
          options: ['① ', '② ', '③ ', '④ '],
          optionImages: [
            'assets/quiz/set1/q37_scene1.png',
            'assets/quiz/set1/q37_scene2.png',
            'assets/quiz/set1/q37_scene3.png',
            'assets/quiz/set1/q37_scene4.png',
          ],
          correctIndex: 0,
          audioAsset: null, // TODO: add assets/quiz/set1/q37.mp3
        ),
        QuizQuestion(
          question: '남자에 대한 이야기로 맞지 않는 것을 고르십시오.',
          options: [
            '① 배 만드는 일을 하겠습니다.',
            '② 공장 기숙사에서 살겠습니다.',
            '③ 배를 타고 한국에 가겠습니다.',
            '④ 내년에 한국에 가겠습니다.',
          ],
          correctIndex: 0,
          audioAsset: null, // TODO: add assets/quiz/set1/q38.mp3
        ),
        QuizQuestion(
          question: '여자는 왜 가계에 전화하려고 합니까?',
          options: [
            '① 구입한 카메라가 원하는 것이 이나어서',
            '② 새로 구입한 카메라가 성능이 안 좋아서',
            '③ 상자 안에 사용 설명서가 들어 있지 않아서',
            '④ 카메라 사용법을 읽었는데로 이해할 수 없어서',
          ],
          correctIndex: 0,
          audioAsset: null, // TODO: add assets/quiz/set1/q39.mp3
        ),
        QuizQuestion(
          question: '무엇에 대해서 이야기하고 있습니까?',
          options: [
            '① 계절을 소개하고 있습니다.',
            '② 날씨를 아려주고 있습니다.',
            '③ 주말 여행을 안내하고 있습니다.',
            '④ 남자는 어떻게 하겠습니까?.',
          ],
          correctIndex: 0,
          audioAsset: null, // TODO: add assets/quiz/set1/q40.mp3
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