import 'package:flutter/material.dart';

//screen for displaying app's privacy policy
class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Privacy Policy',style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
            ),),
            SizedBox(height: 5,),
            Text(privacyPolicy)
          ],
        ),
      ),
    );
  }
}

String privacyPolicy = '''Not everyone knows how to make a Privacy Policy agreement, especially with CCPA or GDPR or CalOPPA or PIPEDA or Australia's Privacy Act provisions. If you are not a lawyer or someone who is familiar to Privacy Policies, you will be clueless. Some people might even take advantage of you because of this. Some people may even extort money from you. These are some examples that we want to stop from happening to you.
We will help you protect yourself by generating a

Privacy Policy.
Our Privacy Policy Generator can help you make sure that your business complies with the law. We are here to help you protect your business, yourself and your customers.

Fill in the blank spaces below and we will create a personalised website Privacy Policy for your business. No account registration required. Simply generate & download a Privacy Policy in seconds!
Small remark when filling in this Privacy Policy generator: Not all parts of this Privacy Policy might be applicable to your website. When there are parts that are not applicable, these can be removed. Optional elements can be selected in step 2.
The accuracy of the generated Privacy Policy on this website is not legally binding. Use at your own risk.''';