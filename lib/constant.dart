// DOMAIN
import 'package:flutter/material.dart';

const String prodDomain = "http://api.coronatracker.com";
const String devDomain = "";

// REFERENCES
const String countryCode = 'MY';
const String news_limit = '20';

// API : GET
const String get_endpoint_news =
    "/news/trending?limit=$news_limit&country=Malaysia&countryCode=$countryCode";

// COLOR
const Color black = Colors.black;
const Color ground = Colors.blueGrey;
const Color white = Colors.white;
const Color red = Colors.redAccent;
