import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wtoncare/bloc/device/device_bloc.dart';
import 'package:wtoncare/bloc/lapor_peduli/lapor_peduli_bloc.dart';
import 'package:wtoncare/bloc/photo_picker/photo_picker_bloc.dart';
import 'package:wtoncare/bloc/set_form/set_form_bloc.dart';
import 'package:wtoncare/shared/util/color.dart';
import 'package:wtoncare/model/model_auth.dart';
import 'package:wtoncare/model/model_kategori.dart';
import 'package:wtoncare/model/model_keparahan.dart';
import 'package:wtoncare/model/model_kriteria.dart';
import 'package:wtoncare/model/model_lokasi.dart';
import 'package:wtoncare/model/model_pic.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:wtoncare/shared/widget/background.dart';
import 'package:wtoncare/shared/widget/datefield.dart';
import 'package:wtoncare/shared/widget/dropdown.dart';
import 'package:wtoncare/shared/widget/dropdown_search.dart';
import 'package:wtoncare/shared/widget/image.dart';
import 'package:wtoncare/shared/widget/loading.dart';
import 'package:wtoncare/shared/widget/textfield.dart';
import 'package:wtoncare/shared/widget/alert.dart';
import 'package:wtoncare/shared/util/validator.dart';

class PageLaporPeduli extends StatefulWidget {
  final ModelAuth modelAuth;

  const PageLaporPeduli({Key? key, required this.modelAuth}) : super(key: key);

  @override
  State<PageLaporPeduli> createState() => _PageLaporPeduliState();
}

class _PageLaporPeduliState extends State<PageLaporPeduli> {
  LaporPeduliBloc laporPeduliBloc = LaporPeduliBloc();
  PhotoPickerBloc photoPickerBloc = PhotoPickerBloc();
  SetFormBloc setFormBloc = SetFormBloc();

  ListLokasi? lokasi;
  ListPic? pic;
  ListKriteria? kriteria;
  ListKategori? kategori;
  ListKeparahan? keparahan;

  late ValueNotifier<String?> _fotoValidator;
  late ValueNotifier<String?> _lokasiValidator;
  late ValueNotifier<String?> _picValidator;
  late ValueNotifier<String?> _kriteriaValidator;
  late ValueNotifier<String?> _kategoriValidator;
  late ValueNotifier<String?> _keparahanValidator;
  late ValueNotifier<String?> _keteranganValidator;
  late ValueNotifier<String?> _kronologiValidator;
  late ValueNotifier<String?> _jumlahValidator;

  late AutoScrollController columnScroll;

  DateTime tanggal = DateTime.now();
  String keterangan = "";
  String kronologi = "";
  int jumlah = 1;
  bool isKronologi = false;

  @override
  void initState() {
    setFormBloc.add(SetFormEventGetDetails(widget.modelAuth.username));
    _fotoValidator = ValueNotifier<String?>('');
    _lokasiValidator = ValueNotifier<String?>('');
    _picValidator = ValueNotifier<String?>('');
    _kriteriaValidator = ValueNotifier<String?>('');
    _kategoriValidator = ValueNotifier<String?>('');
    _keparahanValidator = ValueNotifier<String?>('');
    _keteranganValidator = ValueNotifier<String?>('');
    _kronologiValidator = ValueNotifier<String?>('');
    _jumlahValidator = ValueNotifier<String?>('');
    columnScroll = AutoScrollController(axis: Axis.vertical);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => laporPeduliBloc,
        ),
        BlocProvider(
          create: (context) => setFormBloc,
        ),
        BlocProvider(
          create: (context) => photoPickerBloc,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset(
            "assets/images/logo_wika.png",
            height: 36.0,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/pageHome', (Route<dynamic> route) => false);
            },
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/pageHome', (Route<dynamic> route) => false);
            return false;
          },
          child: Stack(
            children: [
              const BG(),
              BlocBuilder<SetFormBloc, SetFormState>(
                builder: (context, formState) {
                  if (formState is SetFormFailed) {
                    return ButtonReload(
                      function: () {
                        setFormBloc.add(
                            SetFormEventGetDetails(widget.modelAuth.username));
                      },
                      errorMessage: formState.errorMessage,
                    );
                  } else if (formState is SetLocationFailed) {
                    return ButtonReload(
                      function: () {
                        setFormBloc.add(
                            SetFormEventGetDetails(widget.modelAuth.username));
                      },
                      errorMessage: formState.errorMessage,
                    );
                  } else if (formState is SetFormSuccess) {
                    return BlocConsumer<LaporPeduliBloc, LaporPeduliState>(
                        listener: (context, state) {
                      if (state is LaporPeduliSuccess) {
                        showSnackBar(
                          context: context,
                          message: "Laporan Terkirim",
                          messageType: MessageType.success,
                        );
                        Navigator.pushReplacementNamed(context, '/pageHome');
                      }
                    }, builder: (context, state) {
                      if (state is LaporPeduliLoading) {
                        return Center(
                          child: LoadingWidget(message: state.loadingMessage),
                        );
                      } else if (state is LaporPeduliError) {
                        return ButtonReload(
                          function: () {
                            validate();
                          },
                          errorMessage: state.errorMessage,
                        );
                      } else if (state is LaporPeduliSuccess) {
                        return const Center(child: Text('Berhasil'));
                      }
                      return SingleChildScrollView(
                        controller: columnScroll,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                child: Text(
                                  "Form Laporan Temuan",
                                  style: TextStyle(
                                    color: cSecondColor,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              _wrapScrollTag(
                                  child: CardImage(
                                    title: "Foto Temuan",
                                    photoPickerBloc: photoPickerBloc,
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  index: 0),
                              Align(
                                alignment: Alignment.center,
                                child: validatorMesage(_fotoValidator),
                              ),
                              QDatePicker(
                                label: "Waktu",
                                value: tanggal,
                                // validator: Validator.required,
                                onChanged: (value) {
                                  tanggal = value;
                                },
                              ),
                              _wrapScrollTag(
                                child: QDropdownSearchField(
                                  label: "Lokasi",
                                  hint: "Pilih Lokasi",
                                  hintText: "Cari Lokasi",
                                  items: formState.listLokasi
                                      .map((ListLokasi data) {
                                    return {
                                      "label": data.lokasiNama,
                                      "value": data,
                                    };
                                  }).toList(),
                                  onChanged: (value, label) {
                                    if (value is ListLokasi) {
                                      lokasi = value;
                                    }
                                  },
                                ),
                                index: 1,
                              ),
                              validatorMesage(_lokasiValidator),
                              _wrapScrollTag(
                                child: QDropdownField(
                                  label: "PIC",
                                  hint: "Pilih PIC",
                                  hintText: "",
                                  items: formState.listPic.map((ListPic data) {
                                    return {
                                      "label": data.picNama,
                                      "value": data,
                                    };
                                  }).toList(),
                                  onChanged: (value, label) {
                                    if (value is ListPic) {
                                      pic = value;
                                    }
                                  },
                                ),
                                index: 2,
                              ),
                              validatorMesage(_picValidator),
                              _wrapScrollTag(
                                child: QDropdownField(
                                  label: "Kriteria",
                                  hint: "Pilih Kriteria",
                                  hintText: "",
                                  items: formState.listKriteria
                                      .map((ListKriteria data) {
                                    return {
                                      "label": data.kriteriaNama,
                                      "value": data,
                                    };
                                  }).toList(),
                                  onChanged: (value, label) {
                                    if (value is ListKriteria) {
                                      kriteria = value;
                                      String kriteriaKejadian =
                                          value.kriteriaKejadian;
                                      if (kriteriaKejadian == "1") {
                                        isKronologi = true;
                                      } else {
                                        isKronologi = false;
                                      }
                                      setState(() {});
                                    }
                                  },
                                ),
                                index: 3,
                              ),
                              validatorMesage(_kriteriaValidator),
                              _wrapScrollTag(
                                child: QDropdownField(
                                  label: "Kategori",
                                  hint: "Pilih Kategori",
                                  hintText: "",
                                  items: formState.listKategori
                                      .map((ListKategori data) {
                                    return {
                                      "label": data.kategoriNama,
                                      "value": data,
                                    };
                                  }).toList(),
                                  onChanged: (value, label) {
                                    if (value is ListKategori) {
                                      kategori = value;
                                    }
                                  },
                                ),
                                index: 4,
                              ),
                              validatorMesage(_kategoriValidator),
                              _wrapScrollTag(
                                child: QDropdownField(
                                  label: "Keparahan",
                                  hint: "Pilih Keparahan",
                                  hintText: "",
                                  items: formState.listKeparahan
                                      .map((ListKeparahan data) {
                                    return {
                                      "label":
                                          "${data.keparahanLevel}. ${data.keparahanNama}",
                                      "value": data,
                                    };
                                  }).toList(),
                                  onChanged: (value, label) {
                                    if (value is ListKeparahan) {
                                      keparahan = value;
                                    }
                                  },
                                ),
                                index: 5,
                              ),
                              validatorMesage(_keparahanValidator),
                              _wrapScrollTag(
                                child: QTextField(
                                  label: "Jumlah",
                                  hint: "Masukkan Jumlah",
                                  value: jumlah.toString(),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      if (int.tryParse(value) != null) {
                                        jumlah = int.parse(value);
                                      } else {
                                        jumlah = 0;
                                      }
                                    } else {
                                      jumlah = 0;
                                    }
                                  },
                                ),
                                index: 8,
                              ),
                              validatorMesage(_jumlahValidator),
                              _wrapScrollTag(
                                child: QTextField(
                                  label: "Uraian Temuan",
                                  hint: "Masukkan Uraian Temuan",
                                  maxLine: 4,
                                  value: "",
                                  onChanged: (value) {
                                    keterangan = value;
                                  },
                                ),
                                index: 6,
                              ),
                              validatorMesage(_keteranganValidator),
                              isKronologi
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _wrapScrollTag(
                                          child: QTextField(
                                            label: "Kronologi Kejadian",
                                            hint: "Masukkan Kronologi Kejadian",
                                            maxLine: 4,
                                            value: "",
                                            onChanged: (value) {
                                              kronologi = value;
                                            },
                                          ),
                                          index: 7,
                                        ),
                                        validatorMesage(_kronologiValidator)
                                      ],
                                    )
                                  : const SizedBox(),
                              const SizedBox(
                                height: 20.0,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 48,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: cSecondColor,
                                  ),
                                  onPressed: () => validate(),
                                  child: const Text(
                                    "Kirim Laporan",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  }
                  return const Center(
                    child: LoadingWidget(message: "Memuat Form"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void validate() {
    FocusScope.of(context).unfocus();
    bool isImage = imageValidator();
    bool isLokasi = lokasiValidator();
    bool isPIC = picValidator();
    bool isKriteria = kriteriaValidator();
    bool isKategori = kategoriValidator();
    bool isKeparahan = keparahanValidator();
    bool isKeterangan = keteranganValidator(keterangan);
    if (isKronologi) {
      bool isValidKronologi = kronologiValidator(kronologi);
      if (!isValidKronologi) {
        columnScroll.scrollToIndex(7, preferPosition: AutoScrollPosition.begin);
        return;
      }
    }
    bool isJumlah = jumlahValidator(jumlah);

    PhotoPickerState photoPickerState = photoPickerBloc.state;
    if (!isImage) {
      columnScroll.scrollToIndex(0, preferPosition: AutoScrollPosition.begin);
      return;
    }
    if (!isLokasi) {
      columnScroll.scrollToIndex(1, preferPosition: AutoScrollPosition.begin);
      return;
    }
    if (!isPIC) {
      columnScroll.scrollToIndex(2, preferPosition: AutoScrollPosition.begin);
      return;
    }
    if (!isKriteria) {
      columnScroll.scrollToIndex(3, preferPosition: AutoScrollPosition.begin);
      return;
    }
    if (!isKategori) {
      columnScroll.scrollToIndex(4, preferPosition: AutoScrollPosition.begin);
      return;
    }
    if (!isKeparahan) {
      columnScroll.scrollToIndex(5, preferPosition: AutoScrollPosition.begin);
      return;
    }
    if (!isKeterangan) {
      columnScroll.scrollToIndex(6, preferPosition: AutoScrollPosition.begin);
      return;
    }
    if (!isJumlah) {
      columnScroll.scrollToIndex(8, preferPosition: AutoScrollPosition.begin);
      return;
    }

    if (photoPickerState is PhotoPickerPhotoPicked) {
      laporPeduliBloc.add(
        LaporPeduliEventSimpan(
          modelAuth: widget.modelAuth,
          tanggal: DateFormat('dd-MM-y').format(tanggal),
          lokasi: lokasi!,
          pic: pic!,
          kriteria: kriteria!,
          kategori: kategori!,
          keparahan: keparahan!,
          keterangan: keterangan,
          kejadian: kronologi,
          jumlah: jumlah,
          deviceInitial: context.read<DeviceBloc>().state,
          fileFoto: photoPickerState.pickedPhoto,
        ),
      );
    }
  }

  bool imageValidator() {
    PhotoPickerState photoPickerState = photoPickerBloc.state;
    if (photoPickerState is! PhotoPickerPhotoPicked) {
      _fotoValidator.value = 'Ambil Foto';
      return false;
    }
    _fotoValidator.value = null;
    return true;
  }

  bool lokasiValidator() {
    if (lokasi == null) {
      _lokasiValidator.value = 'Pilih Lokasi';
      return false;
    }
    _lokasiValidator.value = null;
    return true;
  }

  bool picValidator() {
    if (pic == null) {
      _picValidator.value = 'Pilih PIC';
      return false;
    }
    _picValidator.value = null;
    return true;
  }

  bool kriteriaValidator() {
    if (kriteria == null) {
      _kriteriaValidator.value = 'Pilih Kriteria';
      return false;
    }
    _kriteriaValidator.value = null;
    return true;
  }

  bool kategoriValidator() {
    if (kategori == null) {
      _kategoriValidator.value = 'Pilih Kategori';
      return false;
    }
    _kategoriValidator.value = null;
    return true;
  }

  bool keparahanValidator() {
    if (keparahan == null) {
      _keparahanValidator.value = 'Pilih Keparahan';
      return false;
    }
    _keparahanValidator.value = null;
    return true;
  }

  bool keteranganValidator(String? text) {
    if (text?.replaceAll(' ', '').isEmpty ?? false) {
      _keteranganValidator.value = 'Isi Uraian Temuan';
      return false;
    }
    _keteranganValidator.value = null;
    return true;
  }

  bool kronologiValidator(String? text) {
    if (text?.replaceAll(' ', '').isEmpty ?? false) {
      _kronologiValidator.value = 'Isi Kronologi Kejadian';
      return false;
    }
    _kronologiValidator.value = null;
    return true;
  }

  bool jumlahValidator(int? text) {
    if (text == null || text == 0) {
      _jumlahValidator.value = 'Isi Jumlah';
      return false;
    }
    _jumlahValidator.value = null;
    return true;
  }

  Widget _wrapScrollTag({required int index, required Widget child}) =>
      AutoScrollTag(
        key: ValueKey(index),
        controller: columnScroll,
        index: index,
        highlightColor: Colors.black.withOpacity(0.1),
        child: child,
      );
}
