import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});
  @override
  CreatePostState createState() => CreatePostState();
}

class CreatePostState extends State<CreatePost> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green[300]!,
                  Colors.green[500]!,

                ],
              ),
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 50, bottom: 20),
                child: const Text(
                  "Créer un événement",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Material(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: Colors.white,
                  elevation: 10,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: Colors.green[400]!,
                      ),
                      scrollbarTheme: ScrollbarThemeData(
                        thickness: MaterialStateProperty.all(5),
                      ),
                    ),
                    child: Stepper(
                      elevation: 7,
                      currentStep: _activeStepIndex,
                      steps: stepList(),
                      onStepContinue: () {
                        final bool isValid = _activeStepIndex == 0
                            ? titre.text.isNotEmpty && description.text.isNotEmpty
                            : _activeStepIndex == 1
                                ? !isSearching
                                : date.text.isNotEmpty && time.text.isNotEmpty;
                        if (isValid) {
                          if (_activeStepIndex < (stepList().length - 1)) {
                            setState(() {
                              _activeStepIndex += 1;
                              error = "";
                            });
                          } else {
                            if (isImaged) {}
                            setState(() {
                              titre.text = "";
                              description.text = "";
                              date.text = "";
                              time.text = "";
                              isSearching = true;
                              _activeStepIndex = 0;
                              error = "";
                              isImaged = false;
                              image = null;
                            });
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Succès"),
                                  content: const Text(
                                    "Nous avons bien reçu votre événement, il sera publié après validation par un administrateur.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        } else {
                          setState(() {
                            error = _activeStepIndex == 0
                                ? "Veuillez remplir tous les champs"
                                : _activeStepIndex == 1
                                    ? "Veuillez choisir un lieu"
                                    : "Veuillez choisir une date et une heure";
                          });
                        }
                      },
                      onStepCancel: () {
                        if (_activeStepIndex == 0) {
                          return;
                        }
                        setState(() {
                          _activeStepIndex -= 1;
                          error = "";
                        });
                      },
                      onStepTapped: (int index) {},
                      controlsBuilder:
                          (BuildContext context, ControlsDetails details) {
                        final isLastStep =
                            _activeStepIndex == stepList().length - 1;
                        return Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: details.onStepContinue,
                                child: isLastStep
                                    ? const Text('Submit')
                                    : const Text('Next'),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            if (_activeStepIndex > 0)
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: details.onStepCancel,
                                  child: const Text('Back'),
                                ),
                              )
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20, right: 15),
              child: InkWell(
                onTap: () {
                  setState(() {
                    titre.text = "";
                    description.text = "";
                    date.text = "";
                    time.text = "";
                    isSearching = true;
                    _activeStepIndex = 0;
                    isImaged = false;
                    image = null;
                  });
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    gradient: LinearGradient(
                      colors: [
                        Colors.green[300]!,
                        Colors.green[500]!,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withAlpha(50),
                        spreadRadius: 4,
                        blurRadius: 4,
                        offset: const Offset(
                          3,
                          3,
                        ), // changes position of shadow
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.clear_sharp,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _activeStepIndex = 0;
  TextEditingController titre = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController lieu = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();
  String error = "";
  DateTime? pickedDate;
  bool isSearching = true;
  XFile? image;
  bool isImaged = false;

  Future<void> getImage() async {
    final ImagePicker picker = ImagePicker();
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        isImaged = true;
      });
    }
    // convert image to type File
  }

  List<Step> stepList() => [
        Step(
          state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 0,
          title: const Text(
            'Description',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          subtitle: const Text('Décrivez votre événement.'),
          content: Column(
            children: [
              TextField(
                controller: titre,
                decoration: InputDecoration(
                  hintText: 'Titre',
                  prefixIcon: const Icon(Icons.text_fields_sharp),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: lieu,
                decoration: InputDecoration(
                  hintText: 'Lieu',
                  prefixIcon: const Icon(Icons.location_on_sharp),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                maxLines: 2,
                controller: description,
                decoration: InputDecoration(
                  hintText: ' Description',
                  prefixIcon: const Icon(Icons.segment_sharp),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                error,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        // Step(
        //   state: _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
        //   isActive: _activeStepIndex >= 0,
        //   title: const Text(
        //     'Localisation',
        //     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        //   ),
        //   subtitle: const Text('Où se déroulera votre événement ?'),
        //   content: Padding(
        //     padding: const EdgeInsets.only(top: 8.0),
        //     child: Column(
        //       children: [
        //         if (isSearching)
        //           TextField(
        //             onChanged: (value) {},
        //             decoration: InputDecoration(
        //               prefixIcon: const Icon(Icons.search_sharp),
        //               filled: true,
        //               fillColor: Colors.grey.withOpacity(.3),
        //               border: OutlineInputBorder(
        //                 borderRadius: BorderRadius.circular(15),
        //                 borderSide: BorderSide.none,
        //               ),
        //               hintText: "ex: Chez nono",
        //             ),
        //           ),
        //         const SizedBox(
        //           height: 10,
        //         ),
        //         Text(
        //           error,
        //           style: const TextStyle(color: Colors.red),
        //         ),
        //         const SizedBox(
        //           height: 10,
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        Step(
          state: _activeStepIndex <= 2 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 0,
          title: const Text(
            'Date',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          subtitle: const Text('Quand se déroulera votre événement ?'),
          content: Column(
            children: [
              TextField(
                controller: date,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Entrer une date',
                  prefixIcon: const Icon(Icons.calendar_today_sharp),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                onTap: () async {
                  pickedDate = await showDatePicker(
                    context: context, initialDate: DateTime.now(),
                    firstDate: DateTime
                        .now(), //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2050),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: ColorScheme.light(
                            primary: Colors.green[400]!,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (pickedDate != null) {
                    final String formattedDate =
                        DateFormat('dd/MM/yyyy').format(pickedDate!);
                    setState(() {
                      date.text = formattedDate;
                    });
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: time,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "Entrer l'heure",
                  prefixIcon: const Icon(Icons.timer_sharp),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                onTap: () async {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    initialTime: TimeOfDay.now(),
                    context: context,
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: ColorScheme.light(
                            primary: Colors.green[400]!,
                            secondary: Colors.green[700]!,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (pickedTime != null) {
                    //output 10:51 PM
                    final DateTime parsedTime =
                        DateFormat.Hm().parse(pickedTime.format(context));
                    final String formattedTime =
                        DateFormat('HH:mm:ss').format(parsedTime);
                    setState(() {
                      time.text = formattedTime;
                    });
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                error,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        Step(
          state: _activeStepIndex <= 3 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 0,
          title: const Text(
            'Image',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          subtitle: const Text('Ajouter une image.'),
          content: !isImaged
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Image par défault : ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: const DecorationImage(
                            image: AssetImage("assets/party.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text(
                          "Saisir votre image : ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Center(
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(0.2),
                            ),
                            child: IconButton(
                              onPressed: getImage,
                              icon: const Icon(Icons.photo, color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Stack(
                        children: [
                          Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(File(image!.path)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isImaged = false;
                                    image = null;
                                  });
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
        ),
        Step(
          state: StepState.complete,
          isActive: _activeStepIndex >= 2,
          title: const Text(
            'Vérification',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          subtitle: const Text('Vérifiez les informations saisies.'),
          content: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Material(
              elevation: 7,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                  child: Row(
                    children: [
                      // rounded image
                      if (isImaged)
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: FileImage(File(image!.path)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      else
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: const DecorationImage(
                              image: AssetImage("assets/party.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      const SizedBox(width: 10),
                      // text
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    titre.text,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                // const SizedBox(width: 5),
                                // DecoratedBox(
                                //   decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(10),
                                //     color: Colors.green,
                                //   ),
                                //   child: const Padding(
                                //     padding: EdgeInsets.symmetric(
                                //       vertical: 2.0,
                                //       horizontal: 5.0,
                                //     ),
                                //     child: Center(
                                //       child: Text(
                                //         "Test",
                                //         style: TextStyle(
                                //           color: Colors.white,
                                //           fontSize: 12,
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    description.text,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  color: Colors.grey,
                                  size: 9,
                                ),
                                const SizedBox(width: 5),
                                Flexible(
                                  child: Text(
                                    "${date.text} - ${time.text}",
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.grey,
                                  size: 9,
                                ),
                                const SizedBox(width: 5),
                                Flexible(
                                  child: Text(
                                    isSearching ? "" : "deffe",
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ];

  @override
  bool get wantKeepAlive => true;
}
