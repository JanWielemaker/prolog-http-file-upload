# Test SWI-Prolog file upload

This repo has been created after discussing about [file upload in
the SWI-Prolog HTTP
services](https://groups.google.com/forum/#!topic/swi-prolog/ABzhD4EKKAY).

To run it,

    swipl post.pl
    ?- server(8080).

Surf to http://localhost:8080/, Select `jprolog.txt` and `swipl-128.png`
for the text and binary file and hit `submit`. If all is well, your page
looks like the file `result.png`.

Note that `jprolog.txt` is UTF-8 encoded. You might need to recode it to
your current locale before upload.
