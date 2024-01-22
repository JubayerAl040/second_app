import 'package:flutter/material.dart';
import 'package:flutter_sslcommerz/model/SSLCCustomerInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

enum SdkType { testBox, live }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _key = GlobalKey<FormState>();
  dynamic formData = {};
  SdkType _radioSelected = SdkType.testBox;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        title: const Text('SSLCommerz'),
      ),
      body: Form(
        key: _key,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Store Id
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: "jbcom64816e44c87a2",
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      hintText: "Store ID",
                    ),
                    validator: (value) {
                      if (value != null) {
                        return "Please input store id";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      formData['store_id'] = value;
                    },
                  ),
                ),
                // store password
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: "jbcom64816e44c87a2@ssl",
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      hintText: "Store password",
                    ),
                    validator: (value) {
                      if (value != null) {
                        return "Please input store password";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      formData['store_password'] = value;
                    },
                  ),
                ),
                // live or TextBox radio-buttons
                Row(
                  children: [
                    Radio(
                      value: SdkType.testBox,
                      groupValue: _radioSelected,
                      activeColor: Colors.blue,
                      onChanged: (value) {
                        setState(() {
                          _radioSelected = value as SdkType;
                        });
                      },
                    ),
                    const Text("TEXTBOX"),
                    Radio(
                      value: SdkType.live,
                      groupValue: _radioSelected,
                      activeColor: Colors.blue,
                      onChanged: (value) {
                        setState(() {
                          _radioSelected = value as SdkType;
                        });
                      },
                    ),
                    const Text('LIVE'),
                  ],
                ),
                // phone customer
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: "01628430948",
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      hintText: "Phone number",
                    ),
                    onSaved: (value) {
                      formData['phone'] = value;
                    },
                  ),
                ),
                // amount
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: "10",
                    // keyboardType: TextInputType.number,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      hintText: "Payment amount",
                    ),
                    validator: (value) {
                      if (value != null) {
                        return "Please input amount";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      formData['amount'] = double.parse(value!);
                    },
                  ),
                ),
                // payment options
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    initialValue: "visa, master, bkash",
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      hintText: "Enter multi card",
                    ),
                    onSaved: (value) {
                      formData['multicard'] = value;
                    },
                  ),
                ),
                ElevatedButton(
                  child: const Text("Pay now"),
                  onPressed: () {
                    if (_key.currentState != null) {
                      _key.currentState?.save();
                      sslCommerzCustomizedCall();
                      // sslCommerzCustomizedCall();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sslCommerzGeneralCall() async {
    Sslcommerz sslcommerz = Sslcommerz(
      initializer: SSLCommerzInitialization(
        //Use the ipn if you have valid one, or it will fail the transaction.
        ipn_url: "www.ipnurl.com",
        multi_card_name: formData['multicard'],
        currency: SSLCurrencyType.BDT,
        product_category: "Food",
        sdkType: _radioSelected == SdkType.testBox
            ? SSLCSdkType.TESTBOX
            : SSLCSdkType.LIVE,
        store_id: formData['store_id'],
        store_passwd: formData['store_password'],
        total_amount: formData['amount'],
        tran_id: "1231123131212",
      ),
    );
    try {
      SSLCTransactionInfoModel result = await sslcommerz.payNow();
      print('111111 ${result.status!}');
      print('222222 ${result.status!}');
      print('333333 ${result.status!}');
      if (result.status!.toLowerCase() == "failed") {
        Fluttertoast.showToast(
          msg: "Transaction is ${result.status!}....",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else if (result.status!.toLowerCase() == "closed") {
        Fluttertoast.showToast(
          msg: "SDK ${result.status!} by User",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
            msg:
                "Transaction is ${result.status} and Amount is ${result.amount}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
      print(e);
    }
  }

  Future<void> sslCommerzCustomizedCall() async {
    Sslcommerz sslcommerz = Sslcommerz(
      initializer: SSLCommerzInitialization(
        //Use the ipn if you have valid one, or it will fail the transaction.
        ipn_url: "www.ipnurl.com",
        multi_card_name: formData['multicard'],
        currency: SSLCurrencyType.BDT,
        product_category: "Food",
        sdkType: SSLCSdkType.TESTBOX,
        store_id: formData['store_id'],
        store_passwd: formData['store_password'],
        total_amount: formData['amount'],
        tran_id: "1231321321321312",
      ),
    );

    sslcommerz
        // .addEMITransactionInitializer(
        //   sslcemiTransactionInitializer: SSLCEMITransactionInitializer(
        //       emi_options: 1, emi_max_list_options: 9, emi_selected_inst: 0),
        // )
        // .addShipmentInfoInitializer(
        //     sslcShipmentInfoInitializer: SSLCShipmentInfoInitializer(
        //         shipmentMethod: "yes",
        //         numOfItems: 5,
        //         shipmentDetails: ShipmentDetails(
        //             shipAddress1: "Ship address 1",
        //             shipCity: "Faridpur",
        //             shipCountry: "Bangladesh",
        //             shipName: "Ship name 1",
        //             shipPostCode: "7860")))
        .addCustomerInfoInitializer(
      customerInfoInitializer: SSLCCustomerInfoInitializer(
        customerState: "Chattogram",
        customerName: "Abu Sayed Chowdhury",
        customerEmail: "sayem227@gmail.com",
        customerAddress1: "Anderkilla",
        customerCity: "Chattogram",
        customerPostCode: "200",
        customerCountry: "Bangladesh",
        customerPhone: formData['phone'],
      ),
    );
    // .addProductInitializer(
    //     sslcProductInitializer:
    //         // ***** ssl product initializer for general product STARTS*****
    //         SSLCProductInitializer(
    //   productName: "Water Filter",
    //   productCategory: "Widgets",
    //   general: General(
    //     general: "General Purpose",
    //     productProfile: "Product Profile",
    //   ),
    // )
    // ***** ssl product initializer for general product ENDS*****

    // ***** ssl product initializer for non physical goods STARTS *****
    // SSLCProductInitializer.WithNonPhysicalGoodsProfile(
    //     productName:
    //   "productName",
    //   productCategory:
    //   "productCategory",
    //   nonPhysicalGoods:
    //   NonPhysicalGoods(
    //      productProfile:
    //       "Product profile",
    //     nonPhysicalGoods:
    //     "non physical good"
    //       ))
    // ***** ssl product initializer for non physical goods ENDS *****

    // ***** ssl product initialization for travel vertices STARTS *****
    //       SSLCProductInitializer.WithTravelVerticalProfile(
    //          productName:
    //         "productName",
    //         productCategory:
    //         "productCategory",
    //         travelVertical:
    //         TravelVertical(
    //               productProfile: "productProfile",
    //               hotelName: "hotelName",
    //               lengthOfStay: "lengthOfStay",
    //               checkInTime: "checkInTime",
    //               hotelCity: "hotelCity"
    //             )
    //       )
    // ***** ssl product initialization for travel vertices ENDS *****

    // ***** ssl product initialization for physical goods STARTS *****

    // SSLCProductInitializer.WithPhysicalGoodsProfile(
    //     productName: "productName",
    //     productCategory: "productCategory",
    //     physicalGoods: PhysicalGoods(
    //         productProfile: "Product profile",
    //         physicalGoods: "non physical good"))

    // ***** ssl product initialization for physical goods ENDS *****

    // ***** ssl product initialization for telecom vertice STARTS *****
    // SSLCProductInitializer.WithTelecomVerticalProfile(
    //     productName: "productName",
    //     productCategory: "productCategory",
    //     telecomVertical: TelecomVertical(
    //         productProfile: "productProfile",
    //         productType: "productType",
    //         topUpNumber: "topUpNumber",
    //         countryTopUp: "countryTopUp"))
    // ***** ssl product initialization for telecom vertice ENDS *****
    //     )
    // .addAdditionalInitializer(
    //   sslcAdditionalInitializer: SSLCAdditionalInitializer(
    //     valueA: "value a ",
    //     valueB: "value b",
    //     valueC: "value c",
    //     valueD: "value d",
    //   ),
    // );

    try {
      SSLCTransactionInfoModel result = await sslcommerz.payNow();
      print('jb');
      print("result $result");
      print('jb2');
      print("1. ${result.aPIConnect}");
      print("2. ${result.amount}");
      print("3. ${result.bankTranId}");
      print("4. ${result.baseFair}");
      print("5. ${result.cardBrand}");
      print("6. ${result.cardIssuer}");
      print("7. ${result.cardIssuerCountry}");
      print("8. ${result.cardIssuerCountryCode}");
      print("9. ${result.cardNo}");
      print("10. ${result.cardType}");
      print("11. ${result.currencyAmount}");
      print("12. ${result.currencyRate}");
      print("13. ${result.currencyType}");
      print("14. ${result.gwVersion}");
      print("15. ${result.riskLevel}");
      print("16. ${result.riskTitle}");
      print("17. ${result.sessionkey}");
      print("18. ${result.status}");
      print("19. ${result.storeAmount}");
      print("20. ${result.tranDate}");
      print("21. ${result.tranId}");
      print("22. ${result.valId}");
      print("23. ${result.validatedOn}");
      print("24. ${result.valueA}");
      print("25. ${result.valueB}");
      print("26. ${result.valueC}");
      print("27. ${result.valueD}");
      print('jb');
      print('jb2');

      if (result.status!.toLowerCase() == "failed") {
        Fluttertoast.showToast(
          msg: "Transaction is ${result.status!}....",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else if (result.status!.toLowerCase() == "closed") {
        Fluttertoast.showToast(
          msg: "SDK ${result.status!} by User",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
            msg:
                "Transaction is ${result.status} and Amount is ${result.amount}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
      print(e);
    }
  }
}
