import 'package:flutter/material.dart';

const String BASE_REMOTE_URL = "https://reformationvoice.org";
const String BASE_LOCAL_URL = "http://192.168.8.100:5600";

const String LOCAL_API_URL = "$BASE_LOCAL_URL/api/v1";
const  String REMOTE_API_URL = "$BASE_REMOTE_URL/api/v1";

const String IMAGE_PATH = "$BASE_REMOTE_URL/images";

const String topicsUrl = "$REMOTE_API_URL/topics";

const Color primaryColor = Colors.indigo;
const Color secondaryColor = Color(0xfff12bb8);
const Color bgColor = Color(0xffF9E0E3);
TextStyle titleHeadingStyle({Color color = secondaryColor}) => TextStyle(
  color: color,
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);