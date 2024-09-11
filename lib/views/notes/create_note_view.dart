import 'package:flutter/material.dart';
import 'package:frontend_mvvc/viewmodels/login_viewmodels.dart';
import 'package:frontend_mvvc/viewmodels/note_viewmodels.dart';
import 'package:frontend_mvvc/views/auth/login_view.dart';
import 'package:frontend_mvvc/widgets/message/errorMessage.dart';
import 'package:frontend_mvvc/widgets/message/successMessage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreateNoteView extends StatefulWidget {
  const CreateNoteView({super.key});

  @override
  State<CreateNoteView> createState() => _CreateNoteViewState();
}

class _CreateNoteViewState extends State<CreateNoteView> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postViewModel = Provider.of<NoteViewmodel>(context);
    final loginViewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Buat Postingan',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 125,
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Judul Postingan',
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Judul harus diisi';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextFormField(
                  controller: bodyController,
                  minLines: 4,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Isi Postingan',
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Isi postingan harus diisi';
                    }
                    return null;
                  },
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: postViewModel.isLoading
                    ? null
                    : () async {
                        String title = titleController.text.trim();
                        String body = bodyController.text.trim();

                        if (title.isEmpty || body.isEmpty) {
                          showErrorMessage(
                              'Judul dan Isi Postingan harus diisi!');
                          return;
                        }

                        FocusScope.of(context).unfocus();

                        if (loginViewModel.token == null) {
                          showErrorMessage(
                              'Token tidak tersedia. Silakan login kembali.');
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginView(),
                            ),
                          );
                          return;
                        }

                        try {
                          // Tambahkan post
                          await postViewModel.addNote(
                              loginViewModel.token!, title, body);

                          Navigator.pop(context);

                          showSuccessMessage('Berhasil Mengunggah Postingan!');
                        } catch (e) {
                          showErrorMessage('Gagal Mengunggah Postingan!');
                        }
                      },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: postViewModel.isLoading ? Colors.grey : Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: postViewModel.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Unggah',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
