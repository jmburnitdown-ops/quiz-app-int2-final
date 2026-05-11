import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/question.dart';

class QuizProvider with ChangeNotifier {
  int _currentIndex = 0;
  int _score = 0;
  bool _isFinished = false;
  String _selectedCategory = '';
  final List<int?> _userAnswers = [];
  static const int pointsPerCorrectAnswer = 10;

  // Getters
  Map<String, List<Question>> get allQuestions => _questions;
  List<int?> get userAnswers => List.unmodifiable(_userAnswers);
  String get selectedCategory => _selectedCategory;
  int get score => _score;
  int get correctAnswers => _score ~/ pointsPerCorrectAnswer;
  String get earnedBadge {
    if (correctAnswers >= 15) return 'Gold';
    if (correctAnswers >= 10) return 'Silver';
    if (correctAnswers >= 5) return 'Bronze';
    return 'No Badge';
  }

  int get currentIndex => _currentIndex;
  bool get isFinished => _isFinished;
  int get totalQuestions => _questions[_selectedCategory]?.length ?? 0;
  Question get currentQuestion => _questions[_selectedCategory]![_currentIndex];

  final Map<String, List<Question>> _questions = {
    'HTML': [
      Question(
          id: 'h1',
          text: 'What does HTML stand for?',
          options: [
            'Hyperlinks and Text Markup Language',
            'Hyper Text Markup Language',
            'Home Tool Markup Language',
            'Hyper Tool Markup Language'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'h2',
          text: 'Which tag is used for the largest heading?',
          options: ['<heading>', '<h6>', '<h1>', '<head>'],
          correctAnswerIndex: 2),
      Question(
          id: 'h3',
          text: 'What is the correct HTML element for a line break?',
          options: ['<break>', '<lb>', '<br>', '<hr>'],
          correctAnswerIndex: 2),
      Question(
          id: 'h4',
          text: 'What is the correct HTML for creating a hyperlink?',
          options: [
            '<a url="http://test.com">',
            '<a>http://test.com</a>',
            '<a href="http://test.com">',
            '<a name="http://test.com">'
          ],
          correctAnswerIndex: 2),
      Question(
          id: 'h5',
          text: 'Which character is used to indicate an end tag?',
          options: ['*', '<', '/', '^'],
          correctAnswerIndex: 2),
      Question(
          id: 'h6',
          text: 'How can you make a numbered list?',
          options: ['<ul>', '<list>', '<ol>', '<dl>'],
          correctAnswerIndex: 2),
      Question(
          id: 'h7',
          text: 'How can you make a bulleted list?',
          options: ['<ul>', '<ol>', '<list>', '<dl>'],
          correctAnswerIndex: 0),
      Question(
          id: 'h8',
          text: 'Which HTML element defines important text?',
          options: ['<i>', '<important>', '<strong>', '<br>'],
          correctAnswerIndex: 2),
      Question(
          id: 'h9',
          text: 'Which attribute specifies alternate text for an image?',
          options: ['title', 'alt', 'src', 'longdesc'],
          correctAnswerIndex: 1),
      Question(
          id: 'h10',
          text: 'Which HTML element defines the title of a document?',
          options: ['<meta>', '<head>', '<title>', '<header>'],
          correctAnswerIndex: 2),
      Question(
          id: 'h11',
          text: 'Which HTML element is used to specify a footer?',
          options: ['<bottom>', '<section>', '<footer>', '<aside>'],
          correctAnswerIndex: 2),
      Question(
          id: 'h12',
          text: 'Which attribute is used to specify an inline style?',
          options: ['font', 'class', 'styles', 'style'],
          correctAnswerIndex: 3),
      Question(
          id: 'h13',
          text: 'Which HTML element defines a multi-line input field?',
          options: [
            '<input type="text">',
            '<textarea>',
            '<textinput>',
            '<input type="multiline">'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'h14',
          text: 'What is the correct HTML for making a checkbox?',
          options: [
            '<check>',
            '<checkbox>',
            '<input type="check">',
            '<input type="checkbox">'
          ],
          correctAnswerIndex: 3),
      Question(
          id: 'h15',
          text: 'Which HTML tag defines an internal style sheet?',
          options: ['<css>', '<script>', '<style>', '<link>'],
          correctAnswerIndex: 2),
    ],
    'CSS': [
      Question(
          id: 'c1',
          text: 'What does CSS stand for?',
          options: [
            'Creative Style Sheets',
            'Computer Style Sheets',
            'Cascading Style Sheets',
            'Colorful Style Sheets'
          ],
          correctAnswerIndex: 2),
      Question(
          id: 'c2',
          text: 'Which HTML attribute defines inline styles?',
          options: ['class', 'style', 'font', 'styles'],
          correctAnswerIndex: 1),
      Question(
          id: 'c3',
          text: 'Which property changes background color?',
          options: ['color', 'bgcolor', 'background-color', 'canvas-color'],
          correctAnswerIndex: 2),
      Question(
          id: 'c4',
          text: 'Which CSS property changes text color?',
          options: ['text-color', 'color', 'fgcolor', 'font-color'],
          correctAnswerIndex: 1),
      Question(
          id: 'c5',
          text: 'Which property controls text size?',
          options: ['text-style', 'font-size', 'text-size', 'font-style'],
          correctAnswerIndex: 1),
      Question(
          id: 'c6',
          text: 'Correct CSS syntax to make all <p> bold?',
          options: [
            '<p style="text-size:bold;">',
            'p {font-weight:bold;}',
            'p {text-size:bold;}',
            'all.p {font-weight:bold;}'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'c7',
          text: 'How do you select an element with id "demo"?',
          options: ['.demo', 'demo', '#demo', '*demo'],
          correctAnswerIndex: 2),
      Question(
          id: 'c8',
          text: 'How do you select elements with class name "test"?',
          options: ['#test', '.test', 'test', '*test'],
          correctAnswerIndex: 1),
      Question(
          id: 'c9',
          text: 'Display hyperlinks without an underline?',
          options: [
            'a {text-decoration:none;}',
            'a {underline:none;}',
            'a {decoration:no-underline;}',
            'a {text-underline:none;}'
          ],
          correctAnswerIndex: 0),
      Question(
          id: 'c10',
          text: 'Which property changes the left margin?',
          options: [
            'padding-left',
            'margin-left',
            'indent-left',
            'spacing-left'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'c11',
          text: 'Which property changes the font?',
          options: ['font-style', 'font-weight', 'font-family', 'font-type'],
          correctAnswerIndex: 2),
      Question(
          id: 'c12',
          text: 'How do you make the text bold?',
          options: [
            'font:bold;',
            'font-weight:bold;',
            'style:bold;',
            'text-weight:bold;'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'c13',
          text: 'Change list style to square?',
          options: [
            'list-style-type: square;',
            'list-type: square;',
            'type: square;',
            'bullet-style: square;'
          ],
          correctAnswerIndex: 0),
      Question(
          id: 'c14',
          text: 'How to add a border?',
          options: [
            'border-width: 5px;',
            'border: 5px solid black;',
            'stroke: 5px;',
            'outline: 5px;'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'c15',
          text: 'Default value of position property?',
          options: ['relative', 'fixed', 'absolute', 'static'],
          correctAnswerIndex: 3),
    ],
    'JAVASCRIPT': [
      Question(
          id: 'j1',
          text: 'Inside which HTML element do we put JS?',
          options: ['<javascript>', '<scripting>', '<script>', '<js>'],
          correctAnswerIndex: 2),
      Question(
          id: 'j2',
          text: 'How to write "Hello World" in alert?',
          options: [
            'msgBox("Hello World");',
            'alertBox("Hello World");',
            'alert("Hello World");',
            'msg("Hello World");'
          ],
          correctAnswerIndex: 2),
      Question(
          id: 'j3',
          text: 'How do you create a function?',
          options: [
            'function myFunction()',
            'function:myFunction()',
            'function = myFunction()',
            'def myFunction()'
          ],
          correctAnswerIndex: 0),
      Question(
          id: 'j4',
          text: 'How do you call "myFunction"?',
          options: [
            'call myFunction()',
            'myFunction()',
            'call function myFunction()',
            'execute myFunction()'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'j5',
          text: 'Correct IF statement syntax?',
          options: [
            'if i = 5',
            'if i == 5 then',
            'if (i == 5)',
            'if i = 5 then'
          ],
          correctAnswerIndex: 2),
      Question(
          id: 'j6',
          text: 'How does a WHILE loop start?',
          options: [
            'while (i <= 10)',
            'while i <= 10',
            'while i = 1 to 10',
            'loop while (i <= 10)'
          ],
          correctAnswerIndex: 0),
      Question(
          id: 'j7',
          text: 'How does a FOR loop start?',
          options: [
            'for (i = 0; i <= 5; i++)',
            'for (i <= 5; i++)',
            'for i = 1 to 5',
            'for (i = 0; i <= 5)'
          ],
          correctAnswerIndex: 0),
      Question(
          id: 'j8',
          text: 'How to add a JS comment?',
          options: [
            '\'This is a comment',
            '//This is a comment',
            '',
            '#This is a comment'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'j9',
          text: 'Correct way to write a JS array?',
          options: [
            'var colors = "red", "blue"',
            'var colors = (1:"red", 2:"blue")',
            'var colors = ["red", "blue"]',
            'var colors = 1=("red"), 2=("blue")'
          ],
          correctAnswerIndex: 2),
      Question(
          id: 'j10',
          text: 'Round 7.25 to nearest integer?',
          options: [
            'round(7.25)',
            'Math.rnd(7.25)',
            'Math.round(7.25)',
            'rnd(7.25)'
          ],
          correctAnswerIndex: 2),
      Question(
          id: 'j11',
          text: 'Event when user clicks element?',
          options: ['onmouseclick', 'onchange', 'onclick', 'onmouseover'],
          correctAnswerIndex: 2),
      Question(
          id: 'j12',
          text: 'How do you declare a JS variable?',
          options: [
            'v carName;',
            'variable carName;',
            'var carName;',
            'dim carName;'
          ],
          correctAnswerIndex: 2),
      Question(
          id: 'j13',
          text: 'Operator used to assign value?',
          options: ['*', 'x', '=', '-'],
          correctAnswerIndex: 2),
      Question(
          id: 'j14',
          text: 'What will "2" + 2 return in JS?',
          options: ['4', '"22"', 'NaN', 'Error'],
          correctAnswerIndex: 1),
      Question(
          id: 'j15',
          text: 'Find length of string "txt"?',
          options: ['txt.size', 'txt.length', 'len(txt)', 'txt.count'],
          correctAnswerIndex: 1),
    ],
    'ANGULAR': [
      Question(
          id: 'a1',
          text: 'Command to create new Angular project?',
          options: [
            'ng new project',
            'npm start project',
            'angular create',
            'ng start'
          ],
          correctAnswerIndex: 0),
      Question(
          id: 'a2',
          text: 'Decorator defining an Angular component?',
          options: ['@Module', '@Component', '@Directive', '@Injectable'],
          correctAnswerIndex: 1),
      Question(
          id: 'a3',
          text: 'Purpose of ngOnInit?',
          options: [
            'To destroy components',
            'To handle clicks',
            'To initialize logic',
            'To style components'
          ],
          correctAnswerIndex: 2),
      Question(
          id: 'a4',
          text: 'Directive for conditional rendering?',
          options: ['*ngFor', '*ngIf', '*ngShow', '*ngSwitch'],
          correctAnswerIndex: 1),
      Question(
          id: 'a5',
          text: 'Directive for list rendering?',
          options: ['*ngRepeat', '*ngList', '*ngFor', '*ngEach'],
          correctAnswerIndex: 2),
      Question(
          id: 'a6',
          text: 'What is an Angular Module?',
          options: [
            'A CSS file',
            'A way to group components',
            'A type of variable',
            'A database'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'a7',
          text: 'Pass data from parent to child?',
          options: ['@Output()', '@Input()', '@Inject()', '@Bound()'],
          correctAnswerIndex: 1),
      Question(
          id: 'a8',
          text: 'Pass data from child to parent?',
          options: ['@Input()', '@Output()', '@Event()', '@Emit()'],
          correctAnswerIndex: 1),
      Question(
          id: 'a9',
          text: 'What is a Service in Angular?',
          options: [
            'A UI component',
            'A reusable piece of logic',
            'A routing rule',
            'A build tool'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'a10',
          text: 'What is Dependency Injection?',
          options: [
            'Way to fix bugs',
            'Design pattern for services',
            'Type of CSS',
            'Testing tool'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'a11',
          text: 'Purpose of router-outlet?',
          options: [
            'To load CSS',
            'To display routed components',
            'Connect to APIs',
            'Style buttons'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'a12',
          text: 'How to define a route path?',
          options: [
            'path: "home"',
            'url: "home"',
            'route: "home"',
            'link: "home"'
          ],
          correctAnswerIndex: 0),
      Question(
          id: 'a13',
          text: 'What are Pipes used for?',
          options: [
            'Connect components',
            'Transform data in templates',
            'Routing',
            'Styling'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'a14',
          text: 'Character for Two-Way Binding?',
          options: ['{{ }}', '[ ]', '( )', '[( )]'],
          correctAnswerIndex: 3),
      Question(
          id: 'a15',
          text: 'Tool used to compile Angular apps?',
          options: ['Angular CLI', 'WebPack', 'Babel', 'Vite'],
          correctAnswerIndex: 0),
    ],
    'DART': [
      Question(
          id: 'd1',
          text: 'Who developed Dart?',
          options: ['Apple', 'Microsoft', 'Google', 'Facebook'],
          correctAnswerIndex: 2),
      Question(
          id: 'd2',
          text: 'Entry point of a Dart app?',
          options: ['start()', 'run()', 'main()', 'init()'],
          correctAnswerIndex: 2),
      Question(
          id: 'd3',
          text: 'Declare a constant in Dart?',
          options: ['const', 'let', 'final', 'Both const and final'],
          correctAnswerIndex: 3),
      Question(
          id: 'd4',
          text: 'What does ?? operator do?',
          options: [
            'Checks equality',
            'Null-aware assignment',
            'Not equal',
            'Ternary if'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'd5',
          text: 'Keyword used for inheritance?',
          options: ['implements', 'extends', 'with', 'inherits'],
          correctAnswerIndex: 1),
      Question(
          id: 'd6',
          text: 'Define a list in Dart?',
          options: ['List x = []', 'Array x = []', 'Map x = []', 'Set x = []'],
          correctAnswerIndex: 0),
      Question(
          id: 'd7',
          text: 'String Interpolation syntax?',
          options: [
            '"Val: &var"',
            '"Val: {var}"',
            '"Val: \$var"',
            '"Val: #var"'
          ],
          correctAnswerIndex: 2),
      Question(
          id: 'd8',
          text: 'Create a class in Dart?',
          options: [
            'class MyClass {}',
            'new class MyClass {}',
            'define MyClass {}',
            'struct MyClass {}'
          ],
          correctAnswerIndex: 0),
      Question(
          id: 'd9',
          text: 'Does Dart support multiple inheritance?',
          options: ['Yes', 'No', 'Only for lists', 'Only for strings'],
          correctAnswerIndex: 1),
      Question(
          id: 'd10',
          text: 'Use of factory keyword?',
          options: [
            'Create objects',
            'Implement singletons',
            'Speed up code',
            'Handle UI'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'd11',
          text: 'Handle exceptions in Dart?',
          options: ['if/else', 'try/catch', 'switch/case', 'await/async'],
          correctAnswerIndex: 1),
      Question(
          id: 'd12',
          text: 'What is an Asynchronous function?',
          options: [
            'Runs instantly',
            'Returns a Future',
            'Blocks UI',
            'Only for CSS'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'd13',
          text: 'What does await keyword do?',
          options: [
            'Pauses until Future completes',
            'Speeds up code',
            'Closes app',
            'Loops'
          ],
          correctAnswerIndex: 0),
      Question(
          id: 'd14',
          text: 'Define a Map in Dart?',
          options: ['Map x = {}', 'Map x = []', 'Map x = ()', 'Map x = <>'],
          correctAnswerIndex: 0),
      Question(
          id: 'd15',
          text: 'Default value of uninitialized int?',
          options: ['0', '1', 'null', 'undefined'],
          correctAnswerIndex: 2),
    ],
    'FLUTTER': [
      Question(
          id: 'f1',
          text: 'What is Flutter?',
          options: [
            'Database',
            'SDK for mobile/web apps',
            'Browser',
            'Programming language'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'f2',
          text: 'Language used for Flutter?',
          options: ['Java', 'Swift', 'Dart', 'Kotlin'],
          correctAnswerIndex: 2),
      Question(
          id: 'f3',
          text: 'What is a Widget?',
          options: [
            'Building block of UI',
            'Type of data',
            'Backend server',
            'Compiler'
          ],
          correctAnswerIndex: 0),
      Question(
          id: 'f4',
          text: 'Stateless vs Stateful?',
          options: [
            'No difference',
            'Stateful changes UI dynamically',
            'Stateless for DB',
            'Stateful faster'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'f5',
          text: 'pubspec.yaml purpose?',
          options: [
            'Write code',
            'Manage dependencies/assets',
            'Style UI',
            'Handle routing'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'f6',
          text: 'What is Hot Reload?',
          options: [
            'Restarting phone',
            'Updating code instantly',
            'Compiling',
            'Saving to DB'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'f7',
          text: 'Widget for basic layout?',
          options: ['App', 'Scaffold', 'Center', 'Column'],
          correctAnswerIndex: 1),
      Question(
          id: 'f8',
          text: 'Align widgets in a Row?',
          options: ['CrossAxis', 'MainAxis', 'TextAlign', 'VerticalAlign'],
          correctAnswerIndex: 1),
      Question(
          id: 'f9',
          text: 'Widget for repeated lists?',
          options: ['Column', 'ListView', 'ScrollView', 'Stack'],
          correctAnswerIndex: 1),
      Question(
          id: 'f10',
          text: 'What is BuildContext?',
          options: [
            'Variable',
            'Handle to location in widget tree',
            'Build tool',
            'Style guide'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'f11',
          text: 'Navigate to a new screen?',
          options: [
            'Route.push',
            'Navigator.push',
            'Screen.load',
            'Window.open'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'f12',
          text: 'Purpose of main()?',
          options: [
            'Style app',
            'Entry point to run app',
            'Connect Firebase',
            'Define widgets'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'f13',
          text: 'Add an image asset?',
          options: [
            'Image.file',
            'Image.asset',
            'Image.network',
            'Image.memory'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'f14',
          text: 'Stream in Flutter?',
          options: [
            'Sequence of async data',
            'Type of list',
            'UI widget',
            'DB table'
          ],
          correctAnswerIndex: 0),
      Question(
          id: 'f15',
          text: 'Command to create Flutter project?',
          options: [
            'flutter start',
            'flutter init',
            'flutter create',
            'flutter build'
          ],
          correctAnswerIndex: 2),
    ],
    'REACT': [
      Question(
          id: 'r1',
          text: 'What is React?',
          options: [
            'Database',
            'JS library for UI',
            'CSS framework',
            'Language'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'r2',
          text: 'Who developed React?',
          options: ['Google', 'Microsoft', 'Meta (Facebook)', 'Apple'],
          correctAnswerIndex: 2),
      Question(
          id: 'r3',
          text: 'What is JSX?',
          options: [
            'JavaScript XML',
            'Java Style Ext',
            'JSON Syntax',
            'JS Syntax'
          ],
          correctAnswerIndex: 0),
      Question(
          id: 'r4',
          text: 'What are Hooks?',
          options: [
            'Functions for state in functional components',
            'CSS selectors',
            'HTML attributes',
            'Build tools'
          ],
          correctAnswerIndex: 0),
      Question(
          id: 'r5',
          text: 'What does useState do?',
          options: [
            'Returns current state and update func',
            'Loads API',
            'Styles comp',
            'Deletes data'
          ],
          correctAnswerIndex: 0),
      Question(
          id: 'r6',
          text: 'What is Virtual DOM?',
          options: [
            'Real DOM',
            'Lightweight copy of DOM',
            'Database',
            'Routing tool'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'r7',
          text: 'Pass data to a component?',
          options: ['States', 'Props', 'Refs', 'Hooks'],
          correctAnswerIndex: 1),
      Question(
          id: 'r8',
          text: 'What is functional component?',
          options: [
            'JS function returning JSX',
            'CSS class',
            'HTML tag',
            'JSON object'
          ],
          correctAnswerIndex: 0),
      Question(
          id: 'r9',
          text: 'Purpose of useEffect?',
          options: [
            'Style text',
            'Handle side effects (APIs)',
            'Create lists',
            'Delete components'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'r10',
          text: 'Handle events in React?',
          options: ['onclick', 'onClick', 'on-click', 'click'],
          correctAnswerIndex: 1),
      Question(
          id: 'r11',
          text: 'What is Lifting State Up?',
          options: [
            'Deleting state',
            'Moving state to parent',
            'Styling state',
            'Cookies'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'r12',
          text: 'What is React Router?',
          options: [
            'State tool',
            'Library for navigation',
            'Layout widget',
            'Server'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'r13',
          text: 'Use of "key" prop?',
          options: [
            'Style lists',
            'Identify unique items',
            'Lock data',
            'Hide items'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'r14',
          text: 'What is Redux?',
          options: [
            'UI library',
            'State management tool',
            'Compiler',
            'Framework'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'r15',
          text: 'What is a Fragment?',
          options: [
            'Broken component',
            'Group children without extra nodes',
            'Hook',
            'CSS rule'
          ],
          correctAnswerIndex: 1),
    ],
    'PYTHON': [
      Question(
          id: 'p1',
          text: 'Keyword creates a function?',
          options: ['function', 'def', 'fun', 'define'],
          correctAnswerIndex: 1),
      Question(
          id: 'p2',
          text: 'Start a comment in Python?',
          options: ['//', '/*', '#', '--'],
          correctAnswerIndex: 2),
      Question(
          id: 'p3',
          text: 'File extension?',
          options: ['.pyth', '.pt', '.py', '.pyt'],
          correctAnswerIndex: 2),
      Question(
          id: 'p4',
          text: 'How to create a list?',
          options: ['x = []', 'x = {}', 'x = ()', 'x = <>'],
          correctAnswerIndex: 0),
      Question(
          id: 'p5',
          text: 'How to create a dictionary?',
          options: ['x = []', 'x = {}', 'x = ()', 'x = ""'],
          correctAnswerIndex: 1),
      Question(
          id: 'p6',
          text: 'Exponentiation operator?',
          options: ['^', 'exp', '**', 'pow'],
          correctAnswerIndex: 2),
      Question(
          id: 'p7',
          text: 'What is PEP 8?',
          options: ['Version', 'Style guide', 'Library', 'Error'],
          correctAnswerIndex: 1),
      Question(
          id: 'p8',
          text: 'How to handle errors?',
          options: ['if/else', 'try/except', 'switch/case', 'while'],
          correctAnswerIndex: 1),
      Question(
          id: 'p9',
          text: 'What is a Lambda function?',
          options: [
            'Large class',
            'Anonymous inline function',
            'Build tool',
            'Type of list'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'p10',
          text: 'How to import a module?',
          options: ['require', 'load', 'import', 'include'],
          correctAnswerIndex: 2),
      Question(
          id: 'p11',
          text: 'What does len() do?',
          options: [
            'Clears data',
            'Returns item count',
            'Sums numbers',
            'Finds max'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'p12',
          text: 'Is Python interpreted?',
          options: ['Yes', 'No', 'Only web', 'Only Linux'],
          correctAnswerIndex: 0),
      Question(
          id: 'p13',
          text: 'How to define a class?',
          options: [
            'class MyClass:',
            'define MyClass:',
            'struct MyClass:',
            'new MyClass:'
          ],
          correctAnswerIndex: 0),
      Question(
          id: 'p14',
          text: 'Correct way to write a for loop?',
          options: [
            'for x in y:',
            'for(x in y)',
            'foreach x in y',
            'for x to y'
          ],
          correctAnswerIndex: 0),
      Question(
          id: 'p15',
          text: 'Function outputs text?',
          options: ['echo', 'print()', 'console.log', 'display'],
          correctAnswerIndex: 1),
    ],
    'C++': [
      Question(
          id: 'cp1',
          text: 'Who created C++?',
          options: [
            'James Gosling',
            'Bjarne Stroustrup',
            'Dennis Ritchie',
            'Guido van Rossum'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'cp2',
          text: 'How to output text?',
          options: ['print', 'echo', 'cout <<', 'System.out'],
          correctAnswerIndex: 2),
      Question(
          id: 'cp3',
          text: 'Single-line comment syntax?',
          options: ['#', '//', '/*', '--'],
          correctAnswerIndex: 1),
      Question(
          id: 'cp4',
          text: 'Text variable data type?',
          options: ['String', 'txt', 'string', 'char[]'],
          correctAnswerIndex: 2),
      Question(
          id: 'cp5',
          text: 'Reference variable operator?',
          options: ['*', '&', '@', '^'],
          correctAnswerIndex: 1),
      Question(
          id: 'cp6',
          text: 'Multiplication operator?',
          options: ['x', 'mult', '*', '^'],
          correctAnswerIndex: 2),
      Question(
          id: 'cp7',
          text: 'Keyword for classes?',
          options: ['define', 'struct', 'class', 'object'],
          correctAnswerIndex: 2),
      Question(
          id: 'cp8',
          text: 'What is a pointer?',
          options: [
            'Loop',
            'Variable storing memory address',
            'Math function',
            'CSS rule'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'cp9',
          text: 'How to allocate memory?',
          options: ['malloc', 'alloc', 'new', 'create'],
          correctAnswerIndex: 2),
      Question(
          id: 'cp10',
          text: 'What is namespace std?',
          options: [
            'CSS rule',
            'Standard library namespace',
            'Variable',
            'Database'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'cp11',
          text: 'What is a constructor?',
          options: [
            'Func to delete objects',
            'Init objects',
            'Build tool',
            'Loop'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'cp12',
          text: 'Method Overloading?',
          options: [
            'Errors',
            'Multiple functions same name different params',
            'Overfilling',
            'Styling'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'cp13',
          text: 'What is Inheritance?',
          options: [
            'Deleting code',
            'Deriving class from another',
            'Hiding data',
            'Looping'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 'cp14',
          text: 'Statement end character?',
          options: [':', '.', ';', ','],
          correctAnswerIndex: 2),
      Question(
          id: 'cp15',
          text: 'Equality comparison operator?',
          options: ['=', '==', '===', 'is'],
          correctAnswerIndex: 1),
    ],
    'SWIFT': [
      Question(
          id: 's1',
          text: 'Who developed Swift?',
          options: ['Google', 'Microsoft', 'Apple', 'Facebook'],
          correctAnswerIndex: 2),
      Question(
          id: 's2',
          text: 'Keyword for constants?',
          options: ['var', 'const', 'let', 'final'],
          correctAnswerIndex: 2),
      Question(
          id: 's3',
          text: 'Keyword for variables?',
          options: ['var', 'let', 'val', 'dim'],
          correctAnswerIndex: 0),
      Question(
          id: 's4',
          text: 'Function definition keyword?',
          options: ['def', 'function', 'func', 'method'],
          correctAnswerIndex: 2),
      Question(
          id: 's5',
          text: 'What is an Optional?',
          options: [
            'Variable that can hold nil',
            'Required type',
            'List',
            'UI widget'
          ],
          correctAnswerIndex: 0),
      Question(
          id: 's6',
          text: 'How to unwrap an optional?',
          options: ['if let', 'force unwrap (!)', 'guard let', 'All of these'],
          correctAnswerIndex: 3),
      Question(
          id: 's7',
          text: 'What is a Closure?',
          options: ['Loop', 'Block of functionality', 'Class', 'Database'],
          correctAnswerIndex: 1),
      Question(
          id: 's8',
          text: 'What is a Struct?',
          options: [
            'Reference type',
            'Value type',
            'Styling rule',
            'Build tool'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 's9',
          text: 'Difference Class/Struct?',
          options: [
            'Classes are reference types',
            'Structs faster',
            'Classes support inheritance',
            'All of these'
          ],
          correctAnswerIndex: 3),
      Question(
          id: 's10',
          text: 'What is an Extension?',
          options: [
            'Adding functionality to types',
            'File format',
            'Plugin',
            'Loop'
          ],
          correctAnswerIndex: 0),
      Question(
          id: 's11',
          text: 'What is a Protocol?',
          options: [
            'DB rule',
            'Blueprint of requirements',
            'Network link',
            'Style sheet'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 's12',
          text: 'How to create an array?',
          options: [
            'var x = []',
            'var x = Array()',
            'var x = [Int]()',
            'All of these'
          ],
          correctAnswerIndex: 3),
      Question(
          id: 's13',
          text: 'What is Type Inference?',
          options: [
            'Compiler guesses type',
            'Manually setting',
            'Errors',
            'UI layout'
          ],
          correctAnswerIndex: 0),
      Question(
          id: 's14',
          text: 'What is a Guard statement?',
          options: [
            'Loops',
            'Exits early if condition not met',
            'Styles text',
            'Connects API'
          ],
          correctAnswerIndex: 1),
      Question(
          id: 's15',
          text: 'What is SwiftUI?',
          options: [
            'Database',
            'UI framework for Apple platforms',
            'Browser',
            'Type of list'
          ],
          correctAnswerIndex: 1),
    ],
  };

  void selectCategory(String category) {
    _selectedCategory = category;
    resetQuiz(); // This will now work
    notifyListeners();
  }

  // FIX: Added the missing resetQuiz method
  void resetQuiz() {
    _currentIndex = 0;
    _score = 0;
    _isFinished = false;
    _userAnswers.clear();
    notifyListeners();
  }

  void answerQuestion(int selectedIndex) {
    if (_userAnswers.length > _currentIndex) {
      _userAnswers[_currentIndex] = selectedIndex;
    } else {
      _userAnswers.add(selectedIndex);
    }

    if (selectedIndex == currentQuestion.correctAnswerIndex) {
      _score += pointsPerCorrectAnswer;
    }

    if (_currentIndex < _questions[_selectedCategory]!.length - 1) {
      _currentIndex++;
    } else {
      _isFinished = true;
      _saveResultsToFirestore();
    }
    notifyListeners();
  }

  Future<void> _saveResultsToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'all_scores': {
            _selectedCategory: {
              'score': _score,
              'total': totalQuestions * pointsPerCorrectAnswer,
              'correctAnswers': correctAnswers,
              'badge': earnedBadge,
              'timestamp': FieldValue.serverTimestamp(),
            }
          },
          'lastQuizCategory': _selectedCategory,
          'lastQuizScore': _score,
          'lastQuizBadge': earnedBadge,
          'isActive': true,
          'earnedCertificates': {
            _selectedCategory: true,
          },
        }, SetOptions(merge: true));
      } catch (e) {
        debugPrint("Error saving results: $e");
      }
    }
  }
}
