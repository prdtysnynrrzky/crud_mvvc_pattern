import 'package:flutter/material.dart';
import 'package:frontend_mvvc/viewmodels/login_viewmodels.dart';
import 'package:frontend_mvvc/viewmodels/note_viewmodels.dart';
import 'package:frontend_mvvc/views/auth/login_view.dart';
import 'package:frontend_mvvc/views/notes/create_note_view.dart';
import 'package:frontend_mvvc/views/notes/update_note_view.dart';
import 'package:frontend_mvvc/widgets/simmer/card_simmer_laoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NoteView extends StatefulWidget {
  final String token;

  NoteView({required this.token});

  @override
  _NoteViewState createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    await Provider.of<NoteViewmodel>(context, listen: false)
        .fetchNotes(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    final noteViewModel = Provider.of<NoteViewmodel>(context);
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Posts',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () async {
              await loginViewModel.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginView()),
              );
            },
          ),
        ],
      ),
      body: noteViewModel.isLoading
          ? SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: List.generate(
                    10,
                    (index) => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: CardShimmerLoading(
                        width: double.infinity,
                        height: 80,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : noteViewModel.notes.isEmpty
              ? const Center(child: Text('Tidak ada postingan tersedia'))
              : RefreshIndicator(
                  onRefresh: _loadPosts,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 70),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: noteViewModel.notes.length,
                      itemBuilder: (context, index) {
                        final note = noteViewModel.notes[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          child: ListTile(
                            title: Text(
                              note.title,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            subtitle: Text(
                              note.body,
                              style: GoogleFonts.poppins(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) async {
                                if (value == 'edit') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpdateNoteView(
                                        note: note,
                                      ),
                                    ),
                                  );
                                } else if (value == 'delete') {
                                  await noteViewModel.deleteNote(
                                      widget.token, note.id);
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                return ['edit', 'delete'].map((String choice) {
                                  return PopupMenuItem<String>(
                                    value: choice,
                                    child: Text(choice.toUpperCase()),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateNoteView(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
