import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jendela_dbp/controllers/screen_size.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:jendela_dbp/controllers/dbp_color.dart';
import 'package:jendela_dbp/controllers/global_var.dart';

// ignore: must_be_immutable
class CustomerDetails extends StatefulWidget {
  TextEditingController? firstName;
  TextEditingController? lastName;
  TextEditingController? company;
  TextEditingController? email;
  TextEditingController? phone;
  TextEditingController? address;
  TextEditingController? city;
  TextEditingController? state;
  TextEditingController? postalcode;
  TextEditingController? country;

  CustomerDetails(
      {super.key,
      this.firstName,
      this.lastName,
      this.company,
      this.email,
      this.phone,
      this.address,
      this.city,
      this.state,
      this.postalcode,
      this.country});

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  final DbpColor colors = DbpColor();
  dynamic userData;
  dynamic userSavedBillingDetails;

  @override
  void initState() {
    super.initState();

    getAndSetCustomerDetails();
  }

  Future<void> getAndSetCustomerDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userData = json.decode(prefs.getString('userData') ?? '');
    userSavedBillingDetails = prefs.getString('BillingDetails');
    setCustomerDetails(userData);
    if (userSavedBillingDetails != null) {
      userSavedBillingDetails = json.decode(userSavedBillingDetails);
      if (userSavedBillingDetails['id'] == userData['id']) {
        setCustomerDetails(userSavedBillingDetails);
      }
    } else {
      setCustomerDetails(userData);
    }
  }

  void setCustomerDetails(billingDetails) {
    setState(() {
      widget.firstName!.text = billingDetails['name'] ?? '';
      widget.lastName!.text = billingDetails['last_name'] ?? '';
      widget.company!.text = billingDetails['company'] ?? '';
      widget.email!.text = billingDetails['email'] ?? '';
      widget.phone!.text = billingDetails['phone'] ?? '';
      widget.address!.text = billingDetails['address_1'] ?? '';
      widget.city!.text = billingDetails['city'] ?? '';
      widget.state!.text = billingDetails['state'] ?? '';
      widget.postalcode!.text = billingDetails['postcode'] ?? '';
      widget.country!.value = const TextEditingValue(text: "MY");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xffE5E5E5),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Maklumat Pembelian',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: colors.bgPrimaryColor,
        // elevation: 0,
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Text(
                  'Ruangan yang bertanda (',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '*',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                Text(
                  ') wajib diisi',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          inputTextField("Nama Awal", widget.firstName, "Nama Awal",
              TextInputType.text, true),
          const Divider(
            thickness: 0.5,
          ),
          inputTextField("Nama Akhir", widget.lastName, "Nama Akhir",
              TextInputType.text, true),
          const Divider(
            thickness: 0.5,
          ),
          inputTextField("Syarikat", widget.company, "Syarikat",
              TextInputType.text, false),
          const Divider(
            thickness: 0.5,
          ),
          inputTextField(
              "Emel", widget.email, "Emel", TextInputType.emailAddress, true),
          const Divider(
            thickness: 0.5,
          ),
          inputTextField("No. telefon", widget.phone, "No. telefon",
              TextInputType.number, true),
          const Divider(
            thickness: 0.5,
          ),
          inputTextField(
              "Alamat", widget.address, "Alamat", TextInputType.text, true),
          const Divider(
            thickness: 0.5,
          ),
          inputTextField(
              "Bandar", widget.city, "Bandar", TextInputType.text, true),
          const Divider(
            thickness: 0.5,
          ),
          inputSelectField(
              "Negeri", widget.state, GlobalVar.wcAddressNegeriList, true),
          const Divider(
            thickness: 0.5,
          ),
          inputTextField("Poskod", widget.postalcode, "Poskod",
              TextInputType.number, true),
          const Divider(
            thickness: 0.5,
          ),
          inputTextField(
              "Negara", widget.country, "Negara", TextInputType.text, true,
              enabled: true),
          const Divider(
            thickness: 0.5,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                checkIfFormComplete();
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                    color: DbpColor().jendelaOrange,
                    border: Border.all(color: DbpColor().jendelaOrange),
                    borderRadius: BorderRadius.circular(8)),
                child: const Text(
                  'Simpan',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> checkIfFormComplete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool emailValid = true;
    try {
      if (widget.firstName!.text != "" &&
          widget.lastName!.text != "" &&
          widget.email!.text != "" &&
          widget.phone!.text != "" &&
          widget.address!.text != "" &&
          widget.state!.text != "" &&
          widget.postalcode!.text != "" &&
          widget.country!.text != "") {
        emailValid = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(widget.email!.text);

        if (!emailValid) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Format emel salah'),
            duration: Duration(seconds: 1),
          ));
        } else {
          var userBillingDetails = {
            "id": userData['id'],
            "name": widget.firstName!.text,
            "company": widget.company!.text,
            "last_name": widget.lastName!.text,
            "email": widget.email!.text,
            "phone": widget.phone!.text,
            "address_1": widget.address!.text,
            "city": widget.city!.text,
            "state": widget.state!.text,
            "postcode": widget.postalcode!.text,
            "country": widget.country!.text,
          };

          prefs.setString('BillingDetails', json.encode(userBillingDetails));
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        }
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Anda perlu melengkapkan maklumat pembelian'),
          duration: Duration(seconds: 1),
        ));
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(e.toString()),
        duration: const Duration(seconds: 1),
      ));
    }
  }

  Widget inputTextField(title, controller, hint, typeInput, isRequired,
      {bool? enabled = true}) {
    double textFieldWidth;
    if (ResponsiveLayout.isDesktop(context)) {
      // Increase left and right padding for desktop
      textFieldWidth = MediaQuery.of(context).size.width / 1.1;
    } else if (ResponsiveLayout.isTablet(context)) {
      // Increase left and right padding for tablets
      textFieldWidth = MediaQuery.of(context).size.width / 1.2;
    } else {
      // Use the default padding for phones and other devices
      textFieldWidth = MediaQuery.of(context).size.width / 1.5;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  title + '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                isRequired
                    ? const Text(
                        "*",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : Container(),
                const Text(
                  " : ",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
            SizedBox(
                width: textFieldWidth,
                child: TextField(
                  enabled: enabled,
                  keyboardType: typeInput,
                  controller: controller,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hint,
                      hintStyle: TextStyle(color: Colors.grey.shade400)),
                )),
          ],
        ),
      ),
    );
  }

  Widget inputSelectField(String hint, TextEditingController? controller,
      List<Map> list, bool isRequired) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        height: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  hint,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                isRequired
                    ? const Text(
                        "*",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : Container(),
                const Text(
                  " : ",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.4,
              child: DropdownButton<String>(
                hint: widget.state?.text == ''
                    ? const Text('Pilih')
                    : Text(widget.state!.text),
                // icon: SizedBox(),
                style: const TextStyle(
                    // fontSize: SizeConfig.textMultiplier * 1.5,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                items: list.map((Map value) {
                  return DropdownMenuItem<String>(
                    value: value['value'],
                    child: Text(value['text']),
                  );
                }).toList(),
                onChanged: (_) {
                  setState(() {
                    widget.state!.value = TextEditingValue(text: _ ?? '');
                  });
                },
                underline: const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
