import 'package:flutter/material.dart';
import 'package:stoxplay/utils/constants/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  // Function to open mail app
  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'help.stoxplay@gmail.com',
      queryParameters: {'subject': 'StoxPlay Support Request'},
    );
    if (!await launchUrl(emailLaunchUri)) {
      throw Exception('Could not launch email client');
    }
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontSize: 16, height: 1.5)),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 4),
            Text(answer, style: const TextStyle(fontSize: 15, height: 1.4)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          color: AppColors.black,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Help Center", style: TextStyle(color: AppColors.black)),
        centerTitle: true,
        backgroundColor: AppColors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 8),
          const Text(
            "We’re here to make your StoxPlay experience smooth and enjoyable. "
            "If you face any issue or have a question, check the sections below or contact our support team.",
            style: TextStyle(fontSize: 16, height: 1.5),
          ),

          // Contact Support
          _buildSectionTitle("Contact Support", Icons.support_agent),
          _buildText("Having trouble using the app or found a bug? Our support team is ready to help you."),
          InkWell(
            onTap: _launchEmail,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: const [
                  Icon(Icons.email_outlined, color: Colors.blueAccent),
                  SizedBox(width: 10),
                  Text(
                    "help.stoxplay@gmail.com",
                    style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Text("Response time: typically within 24 hours.", style: TextStyle(fontSize: 14, color: Colors.grey)),

          // FAQs
          _buildSectionTitle("Frequently Asked Questions", Icons.question_answer_outlined),
          _buildFaqItem(
            "I didn’t receive the OTP. What should I do?",
            "Make sure your phone number is correct and you have a stable network connection. "
                "If the issue continues, try again after a few minutes or contact support.",
          ),
          _buildFaqItem(
            "My data is not updating in real-time.",
            "Ensure your internet connection is stable. If the issue persists, restart the app or log in again.",
          ),
          _buildFaqItem(
            "How do I report a bug or suggest a feature?",
            "Send us details and screenshots (if possible) at help.stoxplay@gmail.com.",
          ),

          // Privacy
          _buildSectionTitle("Account & Privacy", Icons.lock_outline),
          _buildText(
            "Your privacy and data security are our top priorities. "
            "We never share your personal information with third parties. "
            "To learn more, visit the Privacy Policy section in Settings.",
          ),

          // Tips
          _buildSectionTitle("Tips for a Better Experience", Icons.lightbulb_outline),
          _buildText("• Keep your app updated to the latest version."),
          _buildText("• Ensure a stable internet connection for live updates."),
          _buildText("• Use the in-app refresh button to get the latest stock data."),

          // Feedback
          _buildSectionTitle("We’re Listening", Icons.favorite_outline),
          _buildText(
            "Your feedback helps us improve StoxPlay every day. "
            "If you have ideas or suggestions, reach out anytime.",
          ),
          InkWell(
            onTap: _launchEmail,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: const [
                  Icon(Icons.mail_outline, color: Colors.blueAccent),
                  SizedBox(width: 10),
                  Text(
                    "help.stoxplay@gmail.com",
                    style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
