import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/drawer.dart';

class ElectricBillPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 28, 25, 106),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: AppDrawer(),
      backgroundColor: const Color.fromARGB(255, 28, 25, 106),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // const SizedBox(height: 20),
              Center(
                child: Text(
                  'Electric Bill Notice',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: Container(
                  width: 350,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF4A4A9F), Color(0xFF6A6AD9)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              color: Colors.white,
                              size: 40,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'BAPA CONSUMPTION FORM',
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildInfoRow('BAPA Member Name', 'John Doe'),
                      const SizedBox(height: 10),
                      _buildInfoRow('Meter No.', '123456'),
                      const SizedBox(height: 10),
                      _buildInfoRow('Month/Year', 'August 2024'),
                      const SizedBox(height: 10),
                      _buildInfoRow('Total Amount', '₱ 2,500.00'),
                      const SizedBox(height: 10),
                      _buildInfoRow('Date Released', 'August 15, 2024'),
                      const SizedBox(height: 10),
                      _buildInfoRow('Due Date', 'August 30, 2024'),
                      const SizedBox(height: 10),
                      _buildInfoRow('Disconnection Date', 'September 7, 2024'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.lato(
            textStyle: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.lato(
            textStyle: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }
}
