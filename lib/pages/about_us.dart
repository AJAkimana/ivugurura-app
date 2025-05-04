import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:ivugurura_app/core/models/social_media.dart';
import 'package:ivugurura_app/core/utils/constants.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var currentLang = LocalizedApp.of(context).delegate.currentLocale;

    final langSocials = socialMedias[currentLang.languageCode];
    return Theme(
        data: Theme.of(context).copyWith(primaryColor: primaryColor),
        child: Builder(builder: (context) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Reformation Voice'),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(color: bgColor),
                      child: Text(translate('about_us.about_us_description'),
                          style: TextStyle(fontSize: 20, letterSpacing: 1.5)),
                    ),
                    const SizedBox(height: 10.0),
                    _buildCardInfo(context, Icons.web, translate('app.app'),
                        translate('about_us.about_us_visit_web'), '$BASE_URL/${currentLang.languageCode}'),
                    SizedBox(height: 10.0),
                    _buildCardInfo(
                        context,
                        Icons.yard_outlined,
                        translate('about_us.about_us_youtube'),
                        translate('about_us.about_us_youtube_desc'),
                        "https://${langSocials!
                                .firstWhere((item) => item.title == 'Youtube')
                                .url}"),
                    SizedBox(height: 10.0),
                    MaterialButton(
                        color: bgColor,
                        padding: const EdgeInsets.all(16.0),
                        onPressed: () {},
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              _buildTitle(
                                  translate('about_us.about_us_contact')),
                              SizedBox(height: 5.0),
                              _buildContact(Icons.phone, '+250786853257', 'tel'),
                              SizedBox(height: 10.0),
                              _buildContact(
                                  Icons.email, 'info@reformationvoice.org', 'mailto'),
                              // _buildSocialsRow(),
                              SizedBox(width: 20.0),
                              Row(children: _buildSocials(langSocials))
                            ])),
                    SizedBox(height: 20.0),
                  ],
                ),
              ));
        }));
  }

  Widget _buildCardInfo(BuildContext context, IconData icon, String title,
      String description, String url) {
    return MaterialButton(
      color: bgColor,
      padding: const EdgeInsets.all(16.0),
      onPressed: () {
        launchURL(url);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.web, color: primaryColor),
              const SizedBox(width: 10.0),
              Text(
                title,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          const SizedBox(height: 10.0),
          Text(description),
        ],
      ),
    );
  }

  List<Widget> _buildSocials(List<SocialMedia> langSocials) {
    List<Widget> socials = [SizedBox(width: 20.0)];
    for (var social in langSocials) {
      socials.add(IconButton(
        color: social.color,
        icon: Icon(social.iconData),
        onPressed: () {
          launchURL('https://${social.url}');
        },
      ));
    }
    return socials;
  }

  Widget _buildContact(IconData iconData, String contact, String type) {
    return InkWell(
      child: Row(
        children: <Widget>[
          SizedBox(width: 30.0),
          Icon(
            iconData,
            color: Colors.black54,
          ),
          SizedBox(width: 10.0),
          Text(
            contact,
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
      onTap: (){
        launchURL('$type:$contact');
      },
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title.toUpperCase(),
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          Divider(
            color: Colors.black54,
          ),
        ],
      ),
    );
  }
}
