import 'package:flutter/material.dart';
import 'package:week_4_task/model/user_model.dart';

class ProfileScreen extends StatelessWidget {
  final Results user;

  ProfileScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section with Profile Picture from API
            Container(
              width: double.infinity,
              color: Colors.blue,
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  // Profile Picture
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: user.picture?.large != null
                            ? Image.network(
                                user.picture!.large!,
                                width: 130,
                                height: 130,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return CircleAvatar(
                                    radius: 65,
                                    backgroundColor: Colors.blue.shade100,
                                    child: Text(
                                      user.name?.first?[0]?.toUpperCase() ?? '?',
                                      style: TextStyle(
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  );
                                },
                              )
                            : CircleAvatar(
                                radius: 65,
                                backgroundColor: Colors.blue.shade100,
                                child: Text(
                                  user.name?.first?[0]?.toUpperCase() ?? '?',
                                  style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    user.name?.getFullName() ?? 'No Name',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '@${user.login?.username ?? 'username'}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      user.gender?.toUpperCase() ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Details Section
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Personal Information
                  _buildSectionHeader(Icons.person, "Personal Information"),
                  SizedBox(height: 10),
                  _buildInfoCard([
                    _buildInfoRow(Icons.badge, "Title", user.name?.title),
                    _buildInfoRow(Icons.person, "First Name", user.name?.first),
                    _buildInfoRow(Icons.person_outline, "Last Name", user.name?.last),
                    _buildInfoRow(Icons.cake, "Age", user.dob?.age?.toString()),
                    _buildInfoRow(Icons.calendar_today, "Birthday", _formatDate(user.dob?.date)),
                  ]),
                  
                  SizedBox(height: 20),
                  
                  // Contact Information
                  _buildSectionHeader(Icons.contact_phone, "Contact Information"),
                  SizedBox(height: 10),
                  _buildInfoCard([
                    _buildInfoRow(Icons.email, "Email", user.email),
                    _buildInfoRow(Icons.phone, "Phone", user.phone),
                    _buildInfoRow(Icons.smartphone, "Cell", user.cell),
                    _buildInfoRow(Icons.public, "Nationality", user.nat),
                  ]),
                  
                  SizedBox(height: 20),
                  
                  // Location Information
                  _buildSectionHeader(Icons.location_on, "Location"),
                  SizedBox(height: 10),
                  _buildInfoCard([
                    _buildInfoRow(Icons.streetview, "Street", 
                        user.location?.street != null 
                            ? "${user.location!.street!.number} ${user.location!.street!.name}"
                            : null),
                    _buildInfoRow(Icons.location_city, "City", user.location?.city),
                    _buildInfoRow(Icons.map, "State", user.location?.state),
                    _buildInfoRow(Icons.flag, "Country", user.location?.country),
                    _buildInfoRow(Icons.pin_drop, "Postcode", user.location?.getPostcodeString()),
                  ]),
                  
                  SizedBox(height: 20),
                  
                  // Account Information
                  _buildSectionHeader(Icons.account_circle, "Account Information"),
                  SizedBox(height: 10),
                  _buildInfoCard([
                    _buildInfoRow(Icons.person, "Username", user.login?.username),
                    _buildInfoRow(Icons.calendar_today, "Registered", _formatDate(user.registered?.date)),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Not provided';
    try {
      DateTime date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue, size: 28),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value ?? 'Not provided',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}