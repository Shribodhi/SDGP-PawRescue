import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Care'),
        backgroundColor: Colors.yellow,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: 'Med Store'),
            Tab(text: 'Adopt a Pet'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MedStoreTab(),
          PetAdoptionTab(),
        ],
      ),
    );
  }
}

class MedStoreTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text('Medicine Store',
            style: TextStyle(fontSize: 20, color: Colors.black)),
      ),
    );
  }
}

class PetAdoptionTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text('Pet Adoption',
            style: TextStyle(fontSize: 20, color: Colors.black)),
      ),
    );
  }
}
