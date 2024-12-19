enum ServerMode { production, development }

ServerMode serverMode = ServerMode.development;

const urlDevelopment = 'http://10.0.2.2:3000';

const urlProduction = 'ec2-18-220-163-119.us-east-2.compute.amazonaws.com:3000';

// ignore: non_constant_identifier_names
String base_url =
    serverMode == ServerMode.development ? urlDevelopment : urlProduction;
