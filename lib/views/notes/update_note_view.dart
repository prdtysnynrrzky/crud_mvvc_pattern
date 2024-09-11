import 'package:flutter/material.dart';
import 'package:frontend_mvvc/models/note.dart'; // Import model Post
import 'package:frontend_mvvc/viewmodels/note_viewmodels.dart';
import 'package:frontend_mvvc/viewmodels/login_viewmodels.dart';
import 'package:frontend_mvvc/views/auth/login_view.dart';
import 'package:frontend_mvvc/widgets/message/errorMessage.dart';
import 'package:frontend_mvvc/widgets/message/successMessage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UpdateNoteView extends StatefulWidget {
  final Note note;

  const UpdateNoteView({super.key, required this.note});

  @override
  State<UpdateNoteView> createState() => _UpdateNoteViewState();
}

class _UpdateNoteViewState extends State<UpdateNoteView> {
  late TextEditingController titleController;
  late TextEditingController bodyController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note.title);
    bodyController = TextEditingController(text: widget.note.body);
  }

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
          'Edit Catatan',
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
                    hintText: 'Judul Catatan',
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                    border: InputBorder.none,
                  ),
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
                    hintText: 'Isi Catatan',
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () async {
                  String title = titleController.text.trim();
                  String body = bodyController.text.trim();

                  if (title.isEmpty || body.isEmpty) {
                    showErrorMessage('Judul dan Isi Catatan harus diisi!');
                    return;
                  }

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
                    await postViewModel.updateNote(
                      loginViewModel.token!,
                      widget.note.id,
                      title,
                      body,
                    );
                    Navigator.pop(context);
                    showSuccessMessage('Berhasil Memperbarui Catatan!');
                  } catch (e) {
                    showErrorMessage('Gagal Memperbarui Catatan!');
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
                    color: Colors.black,
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
                          'Perbarui',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                          ),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
