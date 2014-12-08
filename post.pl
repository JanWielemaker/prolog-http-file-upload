:- encoding(utf8).
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_dispatch)).

server(Port) :-
	http_server(http_dispatch, [port(Port)]).

:- http_handler(root(.),      form,   []).
:- http_handler(root(handle), handle, []).

form(_Request) :-
	reply_html_page(
	    title('Form test'),
	    \form).

form -->
	{ http_link_to_id(handle, [], HREF)
	},
	html(form([action(HREF), method('POST'), enctype('multipart/form-data')],
	    [ label('Text file'),
	      input([name(text_file), type(file)]), br([]),
	      label('Bin file'),
	      input([name(bin_file), type(file)]), br([]),
	      label('Text'),
	      input([name(text), type(text), value('Prolog のプログラムは')]), br([]),
	      input([type(submit)])
	    ])).


handle(Request) :-
	http_parameters(Request,
			[ text_file(TextFile, [optional(true)]),
			  bin_file(BinFile,   [optional(true)]),
			  text(Text,          [optional(true)])
			]),
	reply_html_page(
	    title('Form results'),
	    [ \text('text file', TextFile),
	      \bin_file(BinFile),
	      \text('text', Text)
	    ]).

text(_, Text) --> {var(Text)}, !.
text(Label, TextFile) -->
	html([ h1('Content of ~w'-[Label]),
	       pre(TextFile)
	     ]).

bin_file(Data) --> {var(Data)}, !.
bin_file(Data) -->
	{ atom_length(Data, Len),
	  sha_hash(Data, Hash, [encoding(octet)]),
	  hash_atom(Hash, HashAtom)
	},
	html([ h1('Binary data'),
	       table([ tr([th('Length'), td(Len)]),
		       tr([th('SHA1 hash'), td(HashAtom)])
		     ])
	     ]).
