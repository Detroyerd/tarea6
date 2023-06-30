import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(ToolboxApp());
}

class ToolboxApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarea 6 (Couteau)',
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = [
    ToolboxWidget(),
    GenderPredictionWidget(),
    AgePredictionWidget(),
    UniversitiesWidget(),
    WeatherWidget(),
    WordPressNewsWidget(),
    AboutWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarea 6 (Couteau)'),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Género',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility),
            label: 'Edad',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Universidades',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'Clima',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Noticias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Acerca de',
          ),
        ],
      ),
    );
  }
}

class ToolboxWidget extends StatelessWidget {
  const ToolboxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/caja.png', 
            width: 150,
            height: 150,
          ),
          const SizedBox(height: 16),
          const Text(
            'Caja de herramienta',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}


class GenderPredictionWidget extends StatefulWidget {
  @override
  _GenderPredictionWidgetState createState() => _GenderPredictionWidgetState();
}

class _GenderPredictionWidgetState extends State<GenderPredictionWidget> {
  TextEditingController _nameController = TextEditingController();
  String _gender = '';
  Color _color = Colors.white;

  Future<void> _predictGender() async {
    final response = await http.get(Uri.parse('https://api.genderize.io/?name=${_nameController.text}'));
    final data = json.decode(response.body);
    setState(() {
      _gender = data['gender'];
      _color = _gender == 'male' ? Colors.blue : Colors.pink;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Nombre',
          ),
        ),
        ElevatedButton(
          onPressed: _predictGender,
          child: Text('Predecir género'),
        ),
        SizedBox(height: 20),
        Text(
          'Género: $_gender',
          style: TextStyle(
            color: _color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class AgePredictionWidget extends StatefulWidget {
  @override
  _AgePredictionWidgetState createState() => _AgePredictionWidgetState();
}

class _AgePredictionWidgetState extends State<AgePredictionWidget> {
  TextEditingController _nameController = TextEditingController();
  String _ageGroup = '';
  String _ageImageUrl = '';

  Future<void> _predictAge() async {
  final response = await http.get(Uri.parse('https://api.agify.io/?name=${_nameController.text}'));
  final data = json.decode(response.body);
  setState(() {
    
    final age = data['age'];

    
    _ageGroup = age < 30 ? 'Joven' : (age < 60 ? 'Adulto' : 'Anciano');
    _ageImageUrl = age < 30 ? 'assets/images/adulto.jpg,'  : (age < 60 ? 'assets/images/adulto.jpg' : 'assets/images/vieja.jpg');

    
  });
}


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Nombre',
          ),
        ),
        ElevatedButton(
          onPressed: _predictAge,
          child: Text('Predecir edad'),
        ),
        SizedBox(height: 20),
        Text(
          'Grupo de edad: $_ageGroup',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        if (_ageImageUrl.isNotEmpty)
          Image.asset(
            _ageImageUrl,
            height: 100,
          ),
      ],
    );
  }
}

class UniversitiesWidget extends StatefulWidget {
  @override
  _UniversitiesWidgetState createState() => _UniversitiesWidgetState();
}

class _UniversitiesWidgetState extends State<UniversitiesWidget> {
  List<dynamic> _universities = [];

  Future<void> _fetchUniversities() async {
    final apiUrl = 'http://universities.hipolabs.com/search?country=Dominican+Republic';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final universitiesData = jsonDecode(response.body);
      setState(() {
        _universities = universitiesData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Universidades en República Dominicana',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: _fetchUniversities,
            child: Text('Obtener Universidades'),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _universities.length,
              itemBuilder: (context, index) {
                final university = _universities[index];
                final name = university['name'];
                final domain = university['domains'][0];
                final website = university['web_pages'][0];

                return ListTile(
                  title: Text(name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dominio: $domain'),
                      Text('Sitio web: $website'),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WeatherWidget extends StatefulWidget {
  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  String _weather = '';

  Future<void> _fetchWeather() async {
  
    setState(() {
      
      _weather = 'Soleado';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Clima en República Dominicana',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: _fetchWeather,
            child: Text('Obtener Clima'),
          ),
          SizedBox(height: 16),
          Text(
            'Clima: $_weather',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class WordPressNewsWidget extends StatefulWidget {
  @override
  _WordPressNewsWidgetState createState() => _WordPressNewsWidgetState();
}

class _WordPressNewsWidgetState extends State<WordPressNewsWidget> {
  List<dynamic> _news = [];

  Future<void> _fetchNews() async {
    const apiUrl = 'https://newsapi.org/v2/everything?q=tesla&from=2023-05-28&sortBy=publishedAt&apiKey=34b32d6620104ac2b1e603f92f72f88c'; 
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final newsData = jsonDecode(response.body);
      setState(() {
        _news = newsData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Noticias de WordPress',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: _fetchNews,
            child: Text('Obtener Noticias'),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _news.length,
              itemBuilder: (context, index) {
                final newsItem = _news[index];
                final title = newsItem['title'];
                final summary = newsItem['summary'];
                final link = newsItem['link'];

                return ListTile(
                  title: Text(title),
                  subtitle: Text(summary),
                  onTap: () {
                  
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AboutWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Acerca de',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/tarea3.jpg'),
            radius: 50,
          ),
          SizedBox(height: 16),
          Text(
            'Contáctame:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('Email: luisfermin25@gmail.com'),
          Text('Teléfono: 809-456-7890'),
        ],
      ),
    );
  }
}








