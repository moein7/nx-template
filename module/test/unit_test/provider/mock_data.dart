import 'package:address_module/domain/entity/address.dart';

final mockSenderAddress = AddressEntity.fromSenderMap({
  "senderId": "newId",
  "senderAddress": "16 Wyndham St",
  "senderEmail": "",
  "senderCity": "Bridgend",
  "senderName": "",
  "senderPostcode": "CF31 1EF",
  "senderPhoneNumber": "",
  "senderCompanyName": "",
  "senderSpecifyingInfo": "Mid Glamorgan",
  "senderCountry": {"code": "GB", "name": "United Kingdom"}
});

final mockUserAddress = AddressEntity.fromSenderMap({
  "id": 0,
  "userId": 0,
  "senderCountry": "string",
  "senderPostcode": "string",
  "senderName": "string",
  "senderAddress": "string",
  "senderCity": "string",
  "senderSpecifyingInfo": "string",
  "senderPhoneNumber": "string",
  "senderCompanyName": "string",
  "senderEmail": "string"
});
final mockDomesticSuggestion = {
  "postcode": "NN1 3ER",
  "latitude": 52.24593734741211,
  "longitude": -0.891636312007904,
  "addresses": [
    {
      "formatted_address": [
        "10 Watkin Terrace",
        "",
        "",
        "Northampton",
        "Northamptonshire"
      ],
      "thoroughfare": "Watkin Terrace",
      "building_name": "",
      "sub_building_name": "",
      "sub_building_number": "",
      "building_number": "10",
      "line_1": "10 Watkin Terrace",
      "line_2": "",
      "line_3": "",
      "line_4": "",
      "locality": "",
      "town_or_city": "Northampton",
      "county": "Northamptonshire",
      "district": "Northampton",
      "country": "England"
    }
  ]
};
final mockInternationalSuggestion = {
  "predictions": [
    {
      "description": "7802 Bob Bullock Loop, Laredo, TX, USA",
      "matched_substrings": [
        {"length": 3, "offset": 0}
      ],
      "place_id": "ChIJlUpCyvTfYIYRC_XVBitHURw",
      "reference": "ChIJlUpCyvTfYIYRC_XVBitHURw",
      "structured_formatting": {
        "main_text": "7802 Bob Bullock Loop",
        "main_text_matched_substrings": [
          {"length": 3, "offset": 0}
        ],
        "secondary_text": "Laredo, TX, USA"
      },
      "terms": [
        {"offset": 0, "value": "7802"},
        {"offset": 5, "value": "Bob Bullock Loop"},
        {"offset": 23, "value": "Laredo"},
        {"offset": 31, "value": "TX"},
        {"offset": 35, "value": "USA"}
      ],
      "types": ["street_address", "geocode"]
    },
    {
      "description":
          "7800 Col. H. Weir Cook Memorial Drive, Indianapolis, IN, USA",
      "matched_substrings": [
        {"length": 3, "offset": 0}
      ],
      "place_id": "ChIJ11J64XSnbIgRK_hLMsVbr44",
      "reference": "ChIJ11J64XSnbIgRK_hLMsVbr44",
      "structured_formatting": {
        "main_text": "7800 Col. H. Weir Cook Memorial Drive",
        "main_text_matched_substrings": [
          {"length": 3, "offset": 0}
        ],
        "secondary_text": "Indianapolis, IN, USA"
      },
      "terms": [
        {"offset": 0, "value": "7800"},
        {"offset": 5, "value": "Col. H. Weir Cook Memorial Drive"},
        {"offset": 39, "value": "Indianapolis"},
        {"offset": 53, "value": "IN"},
        {"offset": 57, "value": "USA"}
      ],
      "types": ["street_address", "geocode"]
    },
    {
      "description": "780 South Dupont Highway, New Castle, DE, USA",
      "matched_substrings": [
        {"length": 3, "offset": 0}
      ],
      "place_id": "ChIJI7EvP_wHx4kRYGSfqc5aSrU",
      "reference": "ChIJI7EvP_wHx4kRYGSfqc5aSrU",
      "structured_formatting": {
        "main_text": "780 South Dupont Highway",
        "main_text_matched_substrings": [
          {"length": 3, "offset": 0}
        ],
        "secondary_text": "New Castle, DE, USA"
      },
      "terms": [
        {"offset": 0, "value": "780"},
        {"offset": 4, "value": "South Dupont Highway"},
        {"offset": 26, "value": "New Castle"},
        {"offset": 38, "value": "DE"},
        {"offset": 42, "value": "USA"}
      ],
      "types": ["street_address", "geocode"]
    },
    {
      "description": "7800 Airport Boulevard, Houston, TX, USA",
      "matched_substrings": [
        {"length": 3, "offset": 0}
      ],
      "place_id": "ChIJZ_tp5EiWQIYRTCIp9DZTaug",
      "reference": "ChIJZ_tp5EiWQIYRTCIp9DZTaug",
      "structured_formatting": {
        "main_text": "7800 Airport Boulevard",
        "main_text_matched_substrings": [
          {"length": 3, "offset": 0}
        ],
        "secondary_text": "Houston, TX, USA"
      },
      "terms": [
        {"offset": 0, "value": "7800"},
        {"offset": 5, "value": "Airport Boulevard"},
        {"offset": 24, "value": "Houston"},
        {"offset": 33, "value": "TX"},
        {"offset": 37, "value": "USA"}
      ],
      "types": ["street_address", "geocode"]
    },
    {
      "description": "780 Logan Avenue North, Renton, WA, USA",
      "matched_substrings": [
        {"length": 3, "offset": 0}
      ],
      "place_id": "ChIJIQ2cWBlokFQRDO5MfUFbJT4",
      "reference": "ChIJIQ2cWBlokFQRDO5MfUFbJT4",
      "structured_formatting": {
        "main_text": "780 Logan Avenue North",
        "main_text_matched_substrings": [
          {"length": 3, "offset": 0}
        ],
        "secondary_text": "Renton, WA, USA"
      },
      "terms": [
        {"offset": 0, "value": "780"},
        {"offset": 4, "value": "Logan Avenue North"},
        {"offset": 24, "value": "Renton"},
        {"offset": 32, "value": "WA"},
        {"offset": 36, "value": "USA"}
      ],
      "types": ["street_address", "geocode"]
    }
  ],
  "status": "OK"
};
