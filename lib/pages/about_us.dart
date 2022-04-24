import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final langSocials = socialMedias['en'];
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
                      child: Text(translate('about_us.about_us_description'), style: TextStyle(fontSize: 20, letterSpacing: 1.5)),
                    ),
                    const SizedBox(height: 10.0),
                    _buildCardInfo(
                        context,
                        Icons.web,
                        translate('app.app'),
                        translate('about_us.about_us_visit_web'),
                        BASE_URL),
                    SizedBox(height: 10.0),
                    _buildCardInfo(
                        context,
                        Icons.yard_outlined,
                        translate('about_us.about_us_youtube'),
                        translate('about_us.about_us_youtube_desc'),
                        langSocials!.firstWhere((item) => item.title=='Youtube').url??''),
                    SizedBox(height: 10.0),
                    MaterialButton(
                        color: bgColor,
                        padding: const EdgeInsets.all(16.0),
                        onPressed: () {},
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              _buildTitle(translate('about_us.about_us_contact')),
                              SizedBox(height: 5.0),
                              _buildContact(Icons.phone, '+250786853257'),
                              SizedBox(height: 10.0),
                              _buildContact(
                                  Icons.email, 'info@reformationvoice.org'),
                              _buildSocialsRow(),
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
        _launchURL(url);
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

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  IconButton _buildSocial(Color color, IconData icon, String url) {
    return IconButton(
      color: color,
      icon: Icon(icon),
      onPressed: () {
        _launchURL(url);
      },
    );
  }

  Row _buildSocialsRow() {
    return Row(
      children: <Widget>[
        SizedBox(width: 20.0),
        _buildSocial(Colors.indigo, FontAwesomeIcons.facebookF, fbPage),
        SizedBox(width: 5.0),
        _buildSocial(Colors.red, FontAwesomeIcons.youtube, youtubeChannel),
        SizedBox(width: 5.0),
        _buildSocial(Colors.blue, FontAwesomeIcons.twitter, twitterPage),
        SizedBox(width: 10.0),
        _buildSocial(Colors.deepOrange, FontAwesomeIcons.instagram, igPage),
        SizedBox(width: 10.0),
        _buildSocial(Colors.blue, FontAwesomeIcons.flickr, flickPage),
        SizedBox(width: 10.0),
      ],
    );
  }

  Row _buildContact(IconData iconData, String contact) {
    return Row(
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
